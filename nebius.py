"""Client for a self-hosted FLAN-T5 served by vLLM's OpenAI-compatible API.

FLAN-T5 is an encoder-decoder model with no chat template, so we use the
text-completion endpoint (/v1/completions), not /v1/chat/completions.

The vLLM server must be started with the V0 engine (VLLM_USE_V1=0), since
the V1 engine — the only one in vllm-openai:latest — does not support
encoder-decoder models. See README / docker command.

Config via environment:
    NEBIUS_BASE_URL   base URL of the vLLM server (default http://localhost:8000/v1)
    NEBIUS_API_KEY    value passed to vLLM's --api-key (default sk-local-test)
    NEBIUS_MODEL      served model name (default google/flan-t5-small)

Usage:
    python nebius.py "Translate to German: Hello, how are you?"
    python nebius.py            # runs a few demo prompts
"""
import os

from dotenv import load_dotenv

# Load NEBIUS_* settings from a .env file next to this script, so the client
# runs without manually exporting them. Real environment variables win.
load_dotenv(os.path.join(os.path.dirname(os.path.abspath(__file__)), ".env"))

import os
from functools import lru_cache

from openai import OpenAI


client = OpenAI(
    base_url="https://api.tokenfactory.nebius.com/v1/",
    api_key=os.environ.get("NEBIUS_API_KEY")
)


@lru_cache(maxsize=None)
def get_chat_response(prompt):
    """Send `prompt` to the chat model and return the response text.

    Results are cached, so repeating the same prompt returns the previous
    response without another API call.
    """
    response = client.chat.completions.create(
        model=os.environ.get("MODEL_ID"),
        messages=[
            {
                "role": "user",
                "content": prompt,
            }
        ],
    )
    return response.choices[0].message.content


if __name__ == "__main__":
    print(get_chat_response("Hello World!"))