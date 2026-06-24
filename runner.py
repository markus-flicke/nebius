"""Load and execute user-submitted tool code.

SECURITY NOTE
-------------
Tools are arbitrary Python that is exec()'d and called in-process. That is the
explicit design of this prototype ("tool as a service"), but it means anyone
who can submit a tool can run arbitrary code on the server. Do NOT expose this
service to untrusted users without real sandboxing (separate process, seccomp,
container, resource limits). See README.md.
"""
import importlib
import tool_base


def load_tool_class(code):
    """Exec ``code`` and return the Tool subclass it defines.

    The submitted code must ``from tool_base import Tool`` (or otherwise have
    ``Tool`` available) and define exactly one subclass of it.
    """
    namespace = {"Tool": tool_base.Tool, "__name__": "submitted_tool"}
    exec(compile(code, "<submitted_tool>", "exec"), namespace)

    candidates = [
        obj
        for obj in namespace.values()
        if isinstance(obj, type)
        and issubclass(obj, tool_base.Tool)
        and obj is not tool_base.Tool
    ]
    if not candidates:
        raise ValueError("No subclass of Tool found in the submitted code.")
    if len(candidates) > 1:
        raise ValueError(
            "Multiple Tool subclasses found; define exactly one: "
            + ", ".join(c.__name__ for c in candidates)
        )
    return candidates[0]


def extract_metadata(code):
    """Instantiate the tool and pull out the fields the website needs."""
    cls = load_tool_class(code)
    instance = cls()
    inputs = getattr(instance, "inputs", {}) or {}
    if not isinstance(inputs, dict):
        raise ValueError("Tool.inputs must be a dict of {name: description}.")
    return {
        "name": str(getattr(instance, "name", cls.__name__)),
        "description": str(getattr(instance, "description", "")),
        "inputs": {str(k): str(v) for k, v in inputs.items()},
        "outputs": str(getattr(instance, "outputs", "")),
    }


def run_tool(code, parameters):
    """Instantiate the tool and call run(parameters). Raises on tool failure."""
    cls = load_tool_class(code)
    return cls().run(parameters)
