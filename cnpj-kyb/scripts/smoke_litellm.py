import json
import os
import urllib.request

base = os.environ["LITELLM_BASE_URL"].rstrip("/")
req = urllib.request.Request(
    f"{base}/chat/completions",
    data=json.dumps({
        "model": os.environ["LITELLM_MODEL"],
        "messages": [{"role": "user", "content": "Responda só: ok"}],
    }).encode(),
    headers={
        "Authorization": f"Bearer {os.environ['LITELLM_API_KEY']}",
        "Content-Type": "application/json",
    },
)
with urllib.request.urlopen(req, timeout=30) as r:
    print(json.load(r)["choices"][0]["message"]["content"])