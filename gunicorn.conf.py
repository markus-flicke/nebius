"""Gunicorn configuration for the Tool-as-a-Service app.

nginx sits in front and proxies to the loopback address below. Binding to
127.0.0.1 keeps gunicorn off the public network (only nginx is exposed) while
avoiding unix-socket ownership issues. Workers are sized for a typical small
VM; tune ``workers`` to ``2 * CPU + 1`` for your host.
"""
import multiprocessing

# nginx proxies to this loopback port; it is never reachable from outside.
bind = "127.0.0.1:8000"

workers = multiprocessing.cpu_count() * 2 + 1
worker_class = "sync"
timeout = 60
graceful_timeout = 30
keepalive = 5

# Recycle workers periodically to bound any per-process leakage.
max_requests = 1000
max_requests_jitter = 100

# Log to stdout/stderr so journald captures everything via systemd.
accesslog = "-"
errorlog = "-"
loglevel = "info"
