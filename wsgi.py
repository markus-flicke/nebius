"""Production WSGI entry point.

Run with a real WSGI server instead of ``python app.py`` (the Flask dev
server). The ``application`` object below is what gunicorn imports:

    gunicorn --config gunicorn.conf.py wsgi:application

The schema is ensured once at import time so a fresh deployment comes up with
its tables in place, mirroring what ``app.py``'s ``__main__`` block did for
the dev server.
"""
import db
from app import app as application

db.init_db()
