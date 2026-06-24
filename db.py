"""Database access layer (PostgreSQL via psycopg 3).

Connection settings come from the ``DATABASE_URL`` environment variable, or
default to a local peer-auth connection to the ``tooldb`` database.
"""
import os
import psycopg
from psycopg.rows import dict_row

DATABASE_URL = os.environ.get("DATABASE_URL", "dbname=tooldb")


def get_conn():
    return psycopg.connect(DATABASE_URL, row_factory=dict_row)


SCHEMA = """
CREATE TABLE IF NOT EXISTS tools (
    id          SERIAL PRIMARY KEY,
    name        TEXT NOT NULL,
    description TEXT NOT NULL DEFAULT '',
    inputs      JSONB NOT NULL DEFAULT '{}',
    outputs     TEXT NOT NULL DEFAULT '',
    conditions  TEXT NOT NULL DEFAULT '',
    code        TEXT NOT NULL,
    created_at  TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Every execution is recorded so success rates are measured, not declared.
CREATE TABLE IF NOT EXISTS runs (
    id         SERIAL PRIMARY KEY,
    tool_id    INTEGER NOT NULL REFERENCES tools(id) ON DELETE CASCADE,
    user_id    TEXT NOT NULL DEFAULT 'anonymous',
    success    BOOLEAN NOT NULL,
    parameters JSONB NOT NULL DEFAULT '{}',
    result     JSONB,
    error      TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS runs_tool_id_idx ON runs(tool_id);
"""


def init_db():
    with get_conn() as conn:
        conn.execute(SCHEMA)
        conn.commit()


def list_tools():
    """Return all tools with their measured global success rate and run count."""
    sql = """
        SELECT t.*,
               COUNT(r.id)                                   AS run_count,
               COUNT(r.id) FILTER (WHERE r.success)          AS success_count
        FROM tools t
        LEFT JOIN runs r ON r.tool_id = t.id
        GROUP BY t.id
        ORDER BY t.created_at DESC, t.id DESC
    """
    with get_conn() as conn:
        rows = conn.execute(sql).fetchall()
    for row in rows:
        row["success_rate"] = _rate(row["success_count"], row["run_count"])
    return rows


def get_tool(tool_id, user_id="anonymous"):
    """Return a single tool plus global and personal success rates."""
    with get_conn() as conn:
        tool = conn.execute("SELECT * FROM tools WHERE id = %s", (tool_id,)).fetchone()
        if tool is None:
            return None
        g = conn.execute(
            "SELECT COUNT(*) c, COUNT(*) FILTER (WHERE success) s FROM runs WHERE tool_id = %s",
            (tool_id,),
        ).fetchone()
        p = conn.execute(
            "SELECT COUNT(*) c, COUNT(*) FILTER (WHERE success) s "
            "FROM runs WHERE tool_id = %s AND user_id = %s",
            (tool_id, user_id),
        ).fetchone()
    tool["run_count"] = g["c"]
    tool["success_count"] = g["s"]
    tool["success_rate"] = _rate(g["s"], g["c"])
    tool["personal_run_count"] = p["c"]
    tool["personal_success_rate"] = _rate(p["s"], p["c"])
    return tool


def insert_tool(name, description, inputs, outputs, conditions, code):
    import json
    with get_conn() as conn:
        row = conn.execute(
            """INSERT INTO tools (name, description, inputs, outputs, conditions, code)
               VALUES (%s, %s, %s, %s, %s, %s) RETURNING id""",
            (name, description, json.dumps(inputs), outputs, conditions, code),
        ).fetchone()
        conn.commit()
    return row["id"]


def record_run(tool_id, user_id, success, parameters, result, error):
    import json
    with get_conn() as conn:
        conn.execute(
            """INSERT INTO runs (tool_id, user_id, success, parameters, result, error)
               VALUES (%s, %s, %s, %s, %s, %s)""",
            (
                tool_id,
                user_id,
                success,
                json.dumps(parameters),
                json.dumps(result) if result is not None else None,
                error,
            ),
        )
        conn.commit()


def _rate(success_count, run_count):
    """Measured success rate as a percent, or None when there are no runs yet."""
    if not run_count:
        return None
    return round(100.0 * success_count / run_count, 1)
