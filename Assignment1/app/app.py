import os
from flask import Flask, render_template, jsonify
import redis

app = Flask(__name__)

REDIS_HOST = os.environ.get("REDIS_HOST", "redis")
REDIS_PORT = int(os.environ.get("REDIS_PORT", 6379))

r = redis.Redis(host=REDIS_HOST, port=REDIS_PORT, decode_responses=True)


@app.route("/")
def index():
    count = r.incr("visits")
    return render_template("index.html", count=count)


@app.route("/health")
def health():
    try:
        r.ping()
        return jsonify(status="ok", redis="connected"), 200
    except Exception as e:
        return jsonify(status="error", redis=str(e)), 500


@app.route("/api/count")
def api_count():
    count = r.get("visits") or 0
    return jsonify(visits=int(count))


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
