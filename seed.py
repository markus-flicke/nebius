"""Seed the database with example tools and generate real runs.

The success rates shown on the site are *measured*, so this script also
executes each tool many times with varied inputs. The examples are chosen to
illustrate the platform's thesis:

* ReverseString       — works unconditionally (≈100%).
* WednesdayGreeting   — conditional on the day of week (VP2).
* GermanCityPopulation— conditional on the input domain (VP2).
* FlakyGeocoder       — partial reliability, rate between 0.1 and 0.9 (VP3).

Run:  python seed.py            (seeds only if empty)
      python seed.py --force    (wipes tools/runs first)
"""
import random
import sys

import db
import runner

REVERSE = '''from tool_base import Tool


class ReverseString(Tool):
    name = "Reverse String"
    description = "Reverses the characters of the given text."
    inputs = {"text": "The text to reverse."}
    outputs = "{'reversed': <reversed text>}"

    def run(self, parameters):
        return {"reversed": parameters["text"][::-1]}
'''

WEDNESDAY = '''from tool_base import Tool
import datetime


class WednesdayGreeting(Tool):
    name = "Wednesday Greeting"
    description = "Greets the user, but only succeeds on Wednesdays."
    inputs = {"name": "Who to greet."}
    outputs = "{'greeting': <text>}"

    def run(self, parameters):
        today = datetime.date.today()
        if today.weekday() != 2:  # Monday=0 ... Wednesday=2
            raise RuntimeError("This tool only works on Wednesdays.")
        return {"greeting": "Happy Wednesday, %s!" % parameters["name"]}
'''

GERMAN_CITY = '''from tool_base import Tool


class GermanCityPopulation(Tool):
    name = "German City Population"
    description = "Returns the approximate population of a large German city."
    inputs = {"city": "Name of a German city (e.g. Berlin)."}
    outputs = "{'city': <name>, 'population': <int>}"

    _POP = {
        "berlin": 3677000, "hamburg": 1906000, "munich": 1488000,
        "cologne": 1073000, "frankfurt": 759000, "stuttgart": 626000,
        "duesseldorf": 619000, "leipzig": 597000, "dortmund": 588000,
        "marburg": 77000,  # below the 90k threshold on purpose
    }

    def run(self, parameters):
        city = parameters["city"].strip().lower()
        if city not in self._POP:
            raise ValueError("Unknown city; only major German cities are supported.")
        pop = self._POP[city]
        if pop < 90000:
            raise ValueError("Population below the supported 90,000 threshold.")
        return {"city": parameters["city"].title(), "population": pop}
'''

FLAKY = '''from tool_base import Tool
import hashlib


class FlakyGeocoder(Tool):
    name = "Flaky Geocoder"
    description = "Resolves an address to coordinates with imperfect coverage."
    inputs = {"address": "A free-text address."}
    outputs = "{'lat': <float>, 'lon': <float>}"

    def run(self, parameters):
        addr = parameters["address"].strip().lower()
        # Deterministic per-address coverage: ~65% of addresses resolve.
        h = int(hashlib.sha256(addr.encode()).hexdigest(), 16) % 100
        if h >= 65:
            raise RuntimeError("Address not found in the geocoding index.")
        return {"lat": 50.0 + (h % 10) / 10.0, "lon": 8.0 + (h % 7) / 10.0}
'''


def seed_tool(code, conditions, sample_inputs):
    meta = runner.extract_metadata(code)
    tool_id = db.insert_tool(
        meta["name"], meta["description"], meta["inputs"],
        meta["outputs"], conditions, code,
    )
    # Generate real runs so the success rate is measured, not declared.
    rng = random.Random(tool_id)  # reproducible
    users = ["anonymous", "markus", "agent-007"]
    for _ in range(40):
        params = {k: rng.choice(v) for k, v in sample_inputs.items()}
        user = rng.choice(users)
        try:
            result = runner.run_tool(code, params)
            db.record_run(tool_id, user, True, params, result, None)
        except Exception as exc:
            db.record_run(tool_id, user, False, params, None,
                          "%s: %s" % (type(exc).__name__, exc))
    print("seeded #%d  %s" % (tool_id, meta["name"]))


def main():
    db.init_db()
    force = "--force" in sys.argv
    with db.get_conn() as conn:
        count = conn.execute("SELECT COUNT(*) c FROM tools").fetchone()["c"]
        if count and not force:
            print("Database already has %d tool(s). Use --force to reseed." % count)
            return
        if force:
            conn.execute("TRUNCATE runs, tools RESTART IDENTITY CASCADE")
            conn.commit()

    seed_tool(REVERSE, "Always works for any text input.",
              {"text": ["hello", "world", "Nebius", "tool as a service", "12345"]})
    seed_tool(WEDNESDAY, "Only succeeds on Wednesdays (server local time).",
              {"name": ["Markus", "Ada", "Linus", "Grace"]})
    seed_tool(GERMAN_CITY,
              "Only German cities with population > 90,000.",
              {"city": ["Berlin", "Hamburg", "Munich", "Marburg", "Atlantis", "Leipzig"]})
    seed_tool(FLAKY, "Coverage is incomplete; ~65% of addresses resolve.",
              {"address": ["Hauptstr 1, Berlin", "10 Downing St", "MIT, Cambridge",
                           "Marktplatz, Marburg", "Unknownville 42"]})
    print("done.")


if __name__ == "__main__":
    main()
