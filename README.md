# Tool as a Service

A platform where every tool publishes the **conditions under which it works**
and a **measured success rate** computed from real runs — not a declared one.
This directly implements the value propositions from the spec:

- **VP2** — each tool lists conditions for success next to a success rate.
- **VP3** — conditions are free text and rates land anywhere in 0–100%
  (see `Flaky Geocoder` ≈ 47%, `German City Population` ≈ 55%).
- **VP4** — both a **global** and a **personal** success rate are shown
  (identify yourself with `?user=<name>` or the `X-User` header).
- **W1** — "Built with **Nebius**" in the footer of every page.

## What's here (maps to W1–W5)

| Spec | Where |
|------|-------|
| W1 footer "Built with Nebius" | [templates/base.html](templates/base.html) |
| W2 list of tools w/ I/O, conditions, success rate | [templates/index.html](templates/index.html), [db.py](db.py) |
| W3 click → fill inputs → run → spinner → output | [templates/tool.html](templates/tool.html), `POST /tool/<id>/run` in [app.py](app.py) |
| W4 PostgreSQL + Flask | [db.py](db.py), [app.py](app.py) |
| W5 web form to submit new tool code | [templates/new_tool.html](templates/new_tool.html), `runner.extract_metadata` |

The tool contract (the abstract `Tool` class authors subclass) lives in
[tool_base.py](tool_base.py). Submitted code is loaded and executed by
[runner.py](runner.py).

## How success rate is measured

Every execution is recorded in the `runs` table with `success = true/false`.
A tool's success rate is `successful_runs / total_runs`. A tool signals failure
by **raising an exception** from `run()` — so a tool that only works on
Wednesdays simply raises on other days, and its measured rate reflects reality.

## Run it locally

```bash
python3 -m venv .venv && . .venv/bin/activate
pip install -r requirements.txt

# PostgreSQL must be running. Default connection: dbname=tooldb (peer auth).
# Override with:  export DATABASE_URL="dbname=tooldb host=localhost user=... password=..."
createdb tooldb            # once

python seed.py             # creates schema + 4 example tools with real runs
python app.py              # http://127.0.0.1:5000
```

`seed.py --force` wipes and reseeds.

## Self-hosted FLAN-T5 on Nebius (vLLM)

[nebius.py](nebius.py) is a small client for a FLAN-T5 model served by vLLM's
OpenAI-compatible API on a Nebius GPU instance.

**Important:** FLAN-T5 is an encoder-decoder (seq2seq) model. vLLM only ever
ran encoder-decoder models on its **V0 engine**, which has been **removed** as
of mid-2025 — the V1 engine in `vllm/vllm-openai:latest` is decoder-only and
will refuse to load T5. So you must **pin an older image** and force V0 with
`VLLM_USE_V1=0`. FLAN-T5 also has no chat template, so requests go to
`/v1/completions`, not `/v1/chat/completions`.

Launch the server on the Nebius B200 instance:

```bash
docker run --runtime nvidia --gpus all \
  -p 8000:8000 --ipc=host \
  -e VLLM_USE_V1=0 \
  vllm/vllm-openai:v0.9.1 \
  --model google/flan-t5-small \
  --task generate \
  --dtype bfloat16 \
  --max-model-len 512 \
  --enforce-eager \
  --api-key sk-local-test
```

`VLLM_USE_V1=0` is the load-bearing flag; `--enforce-eager` avoids CUDA-graph
issues on the encoder-decoder path.

Send requests:

```bash
export NEBIUS_BASE_URL="http://<your-nebius-host>:8000/v1"
export NEBIUS_API_KEY="sk-local-test"

python nebius.py "Translate to German: Hello, how are you?"
python nebius.py            # runs a few demo prompts
```

`nebius.py` uses only the standard library and exposes `ask(prompt)`. Prompt it
like an instruction model: `"Answer the question: ..."`, `"Translate to German: ..."`.

> A B200 is huge overkill for an 80M-param model. If FLAN-T5 isn't required,
> stay on `vllm/vllm-openai:latest` with a decoder-only model (e.g.
> `Qwen/Qwen2.5-0.5B-Instruct`) to get the full chat API with no special flags.

## Adding a tool (W5)

Go to **/new**, edit the default `Tool` subclass, describe the conditions, and
submit. The platform instantiates your class to read `name`, `description`,
`inputs`, and `outputs`, then stores the code. Inputs declared in the `inputs`
dict become the form fields on the tool page.

## ⚠️ Security

Submitting a tool runs **arbitrary Python in the server process** (`exec`).
That is the explicit design of this prototype, but it means anyone who can
reach `/new` can run arbitrary code on the host. **Do not deploy this to
untrusted users** without real isolation: run each tool in a separate process /
container with seccomp, CPU/memory/time limits, and no network or filesystem
access by default. The current `runner.py` is the seam where that sandbox
belongs.

## Not yet built (from the broader spec)

The spec also describes a Python library + HTTP API surface (VP1), multiple
condition-sets per tool each with its own rate (VP3, beyond the single
free-text field), karma/payment incentives (TM2), and authentication. The data
model (`runs` carries `user_id` and `parameters`) is structured so these can be
layered on without migration churn.
