# agent.jac
import catalog
import utils
import os
import json

# We will use Python helper modules for vector search and session memory
# Jac can import Python modules because it's a superset of Python.
from vector_search.search import semantic_search
from sessions.session_mgr import get_session_history, append_session

import requests

function initialize() do
    catalog.initialize()
    # ensure sessions file exists
    try:
        with open(config.SESSIONS_PATH, "r") as f:
            pass
    except:
        with open(config.SESSIONS_PATH, "w") as f:
            f.write("{}")
    end
end

function call_grok_api(str prompt) -> str:
    let env_name = config.LLM_API_KEY_ENV
    let key = os.environ.get(env_name, "")
    if not key:
        return "ERROR: Grok API key not found. Set environment variable " + env_name
    end
    let payload = {
        "prompt": prompt,
        "max_tokens": 512
    }
    let headers = {
        "Authorization": "Bearer " + key,
        "Content-Type": "application/json"
    }
    try:
        let resp = requests.post(config.LLM_API_URL, json=payload, headers=headers, timeout=30)
        if resp.status_code == 200:
            let j = resp.json()
            return j.get("text", "") or j.get("output", "") or str(j)
        else:
            return f"ERROR: Grok API returned status {resp.status_code}: {resp.text}"
        end
    except Exception as e:
        return "ERROR: Exception when calling Grok API: " + str(e)
    end
end

function build_prompt(str question, list contexts, list history) -> str:
    # history is list of previous turns (user/question and assistant/answer)
    let hist_text = ""
    for turn in history:
        # expected turn = {"role":"user"|"assistant", "text": "..."}
        hist_text += f"{turn['role']}: {turn['text']}\n"
    end

    let ctx_texts = []
    for (id, snippet, url) in contexts:
        ctx_texts.append(f"Source: {id}\nURL: {url}\nSnippet: {snippet}\n---\n")
    end
    let ctx_joined = "\n".join(ctx_texts)
    let prompt = f"""You are a helpful university assistant. Use the provided sources (if relevant) to answer the question.
Include citations to the provided sources when they support your answer. If a question asks for private data, do not hallucinate - state that the user must authenticate.

SESSION HISTORY:
{hist_text}

CONTEXT:
{ctx_joined}

QUESTION:
{question}

Answer concisely and include citations like [source: filename]."""
    return prompt
end

function handle_query(str session, str query) -> str:
    let q = query.strip()
    #  Structured lookups
    let course = catalog.lookup_course(q)
    if course is not None:
        let ans = f"Course {course['code']} — {course['title']}: {course.get('description','No description')} (More: {course.get('url','')})"
        append_session(session, {"role":"user","text":q})
        append_session(session, {"role":"assistant","text":ans})
        return ans
    end
    let staff = catalog.lookup_staff(q)
    if staff is not None:
        let ans = f"{staff['name']} — {staff.get('title','')}\nEmail: {staff.get('email','')}\nProfile: {staff.get('url','')}"
        append_session(session, {"role":"user","text":q})
        append_session(session, {"role":"assistant","text":ans})
        return ans
    end

    # Semantic retrieval
    let docs = semantic_search(q, config.TOP_K, config.VECTOR_INDEX_PATH, config.VECTOR_META_PATH)
    let history = get_session_history(session)
    let prompt = build_prompt(q, docs, history)
    let ans = call_grok_api(prompt)
    append_session(session, {"role":"user","text":q})
    append_session(session, {"role":"assistant","text":ans})
    utils.log_interaction(session, q, ans)
    return ans
end
