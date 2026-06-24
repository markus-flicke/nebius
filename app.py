"""Tool-as-a-Service — Flask web application.

Routes
------
GET  /                 list every tool with its measured success rate (W2)
GET  /tool/<id>        tool detail + input form (W3)
POST /tool/<id>/run    execute the tool, record the run, return JSON (W3)
GET  /new              form to submit a new tool (W5)
POST /new              validate + store the new tool (W5)
"""
import json
import traceback

from flask import Flask, render_template, request, redirect, url_for, jsonify

import db
import runner

app = Flask(__name__)

# Default code shown in the "Add a tool" form (W5). Kept here so the form
# always reflects the current tool_base contract.
DEFAULT_TOOL_CODE = '''from tool_base import Tool

# Call the LLM from your tool with get_chat_response(prompt). It returns the
# model's reply as a string and caches repeated prompts.
from nebius import get_chat_response


class ReverseString(Tool):
    name = "Reverse String"
    description = "Reverses the characters of the given text."
    inputs = {"text": "The text to reverse."}
    outputs = "An object with the reversed text."

    def run(self, parameters):
        text = parameters["text"]
        # Example LLM call:
        # answer = get_chat_response("Reverse this text: " + text)
        return {"reversed": text[::-1]}
'''


def current_user():
    """Identify the caller for personal success rates (VP4).

    Prototype: a header or query param, defaulting to 'anonymous'. Swap for
    real auth later.
    """
    return request.headers.get("X-User") or request.args.get("user") or "anonymous"


@app.route("/")
def index():
    tools = db.list_tools()
    return render_template("index.html", tools=tools)


@app.route("/about")
def about():
    return render_template("about.html")


@app.route("/tool/<int:tool_id>")
def tool_detail(tool_id):
    tool = db.get_tool(tool_id, current_user())
    if tool is None:
        return "Tool not found", 404
    return render_template("tool.html", tool=tool)


@app.route("/tool/<int:tool_id>/run", methods=["POST"])
def tool_run(tool_id):
    tool = db.get_tool(tool_id, current_user())
    if tool is None:
        return jsonify({"ok": False, "error": "Tool not found"}), 404

    # Collect only the declared inputs from the submitted form/JSON.
    payload = request.get_json(silent=True) or request.form
    parameters = {name: payload.get(name, "") for name in (tool["inputs"] or {})}

    user = current_user()
    try:
        result = runner.run_tool(tool["code"], parameters)
        # Ensure the result is JSON-serialisable before we commit to "success".
        json.dumps(result)
        db.record_run(tool_id, user, True, parameters, result, None)
        return jsonify({"ok": True, "result": result})
    except Exception as exc:
        err = "".join(traceback.format_exception_only(type(exc), exc)).strip()
        db.record_run(tool_id, user, False, parameters, None, err)
        return jsonify({"ok": False, "error": err})


@app.route("/new", methods=["GET"])
def new_tool_form():
    return render_template("new_tool.html", default_code=DEFAULT_TOOL_CODE,
                           code=DEFAULT_TOOL_CODE, conditions="", error=None)


@app.route("/new", methods=["POST"])
def new_tool_submit():
    code = request.form.get("code", "")
    conditions = request.form.get("conditions", "").strip()

    try:
        meta = runner.extract_metadata(code)
    except Exception as exc:
        err = "".join(traceback.format_exception_only(type(exc), exc)).strip()
        return render_template(
            "new_tool.html", default_code=DEFAULT_TOOL_CODE, code=code,
            conditions=conditions, error=err,
        ), 400

    tool_id = db.insert_tool(
        meta["name"], meta["description"], meta["inputs"],
        meta["outputs"], conditions, code,
    )
    return redirect(url_for("tool_detail", tool_id=tool_id))


if __name__ == "__main__":
    db.init_db()
    app.run()
