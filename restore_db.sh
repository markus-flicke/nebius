#!/usr/bin/env bash
#
# Restore the tooldb PostgreSQL database from a dump created with pg_dump.
#
# Usage:
#   ./restore_db.sh [dump_file]
#
# The dump file defaults to tooldb_dump.sql (next to this script).
# Override the target database/connection with the standard libpq env vars
# (PGHOST, PGPORT, PGUSER, PGPASSWORD) or set DATABASE so a different db name
# is created and loaded:
#
#   PGHOST=db.example.com PGUSER=app ./restore_db.sh
#   DATABASE=tooldb ./restore_db.sh my_dump.sql
#
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DUMP_FILE="${1:-$SCRIPT_DIR/tooldb_dump.sql}"
DATABASE="${DATABASE:-tooldb}"

if [[ ! -f "$DUMP_FILE" ]]; then
    echo "Error: dump file not found: $DUMP_FILE" >&2
    exit 1
fi

echo "Restoring '$DATABASE' from $DUMP_FILE ..."

# Create the database if it does not already exist (connect via the default
# 'postgres' maintenance db so this works on a fresh server).
if ! psql -d postgres -tAc "SELECT 1 FROM pg_database WHERE datname='$DATABASE'" | grep -q 1; then
    echo "Database '$DATABASE' does not exist; creating it."
    createdb "$DATABASE"
fi

# The dump was made with --clean --if-exists, so it drops and recreates the
# objects itself; this is safe to run against an existing database.
psql -v ON_ERROR_STOP=1 -d "$DATABASE" -f "$DUMP_FILE"

echo "Done. '$DATABASE' restored successfully."
