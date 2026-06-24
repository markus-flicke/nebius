"""The contract every tool on the platform must implement.

This module is the single source of truth for what a "tool" is. Both the
running platform and the default code shown in the "Add a tool" form import
from here, so the abstract base never drifts from what users are asked to
subclass.
"""


class Tool(object):
    """Abstract base class for a tool.

    Subclass this and implement :meth:`run`. Declare ``name``,
    ``description``, ``inputs`` and ``outputs`` as class attributes so the
    website can render a form and document the tool.

    Conventions
    -----------
    * ``inputs`` maps a parameter name to a human description. The website
      renders one text field per entry, and passes them to ``run`` as a dict
      of ``{name: value}`` (values arrive as strings from the web form).
    * ``run`` returns any JSON-serialisable value (a dict is recommended).
    * If the tool cannot succeed under the current conditions, ``run`` should
      raise an exception. A raised exception is recorded as a failed run and
      lowers the tool's measured success rate -- which is exactly the signal
      this platform exists to surface.
    """

    name = "my_tool"
    description = "What this tool does, in one sentence."
    inputs = {"example_param": "Description of this parameter."}
    outputs = "Description of what run() returns."

    def run(self, parameters):
        """Execute the tool.

        :param parameters: dict of {input_name: value}
        :returns: any JSON-serialisable result
        """
        raise NotImplementedError("Implement run() in your Tool subclass.")
