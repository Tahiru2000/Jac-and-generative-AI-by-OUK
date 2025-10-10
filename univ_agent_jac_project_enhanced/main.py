# main.py
import uvicorn
from fastapi import FastAPI, Request
from fastapi.staticfiles import StaticFiles
from jaseci.jsorc.jsorc import JsOrc
from pathlib import Path
import json
import os
import inspect
import subprocess

app = FastAPI()

# Initialize Jac runtime
js = JsOrc()

# Helper: compile all Jac files using Jaseci CLI
def compile_jac_files():
    project_path = Path(__file__).parent
    for pattern in ("*.jac", "*.jack"):
        for file in project_path.glob(pattern):
            try:
                print(f"Compiling {file.name} ...")
                subprocess.run(["jac", "run", str(file)], check=True)
            except Exception as e:
                print(f"Failed to compile {file.name}: {e}")

# Compile all .jac/.jack files before starting
compile_jac_files()

def jsorcrun_safe(call_str: str):
    if hasattr(js, "run"):
        try:
            sig = inspect.signature(js.run)
            params = [p for p in sig.parameters.values() if p.name != "self"]
            if len(params) >= 1:
                return {"ok": True, "result": js.run(call_str), "method": "run(call_str)"}
            else:
                if hasattr(js, "run_jac"):
                    return {"ok": True, "result": js.run_jac(call_str), "method": "run_jac"}
                return {"ok": True, "result": js.run(), "method": "run()"}
        except Exception as e:
            return {"ok": False, "result": f"Error calling js.run: {e}", "method": "run"}
    for alt in ("run_jac", "run_call", "exec", "execute"):
        if hasattr(js, alt):
            try:
                fn = getattr(js, alt)
                return {"ok": True, "result": fn(call_str), "method": alt}
            except Exception as e:
                return {"ok": False, "result": f"Error calling {alt}: {e}", "method": alt}
    return {"ok": False, "result": "No usable JsOrc run method found", "method": None}

@app.post("/agent/query")
async def query_endpoint(request: Request):
    body = await request.json()
    session = body.get("session", "anon")
    query = body.get("query", "")
    call = f'handle_query({json.dumps(session)}, {json.dumps(query)})'
    res = jsorcrun_safe(call)
    if not res["ok"]:
        return {"error": res["result"], "method": res["method"]}
    return {"answer": str(res["result"]), "method": res["method"]}

app.mount("/ui", StaticFiles(directory="static", html=True), name="static")

if __name__ == "__main__":
    uvicorn.run("main:app", host="0.0.0.0", port=8000, reload=True)
