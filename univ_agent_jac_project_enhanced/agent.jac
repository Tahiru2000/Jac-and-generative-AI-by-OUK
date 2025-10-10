# agent.jac
import: catalog
import as utils;
import: config

import os
import json
import requests

# Python helpers for semantic search and sessions
from vector_search.search import semantic_search
from sessions.session_mgr import get_session_history, append_session

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

def call_grok_api(str prompt) -> str:
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

def build_prompt(str question, list contexts, list history) -> str:
    let hist_text = ""
    for turn in history:
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

def handle_query(str session, str query) -> str:
    let q = query.strip()

    # --- 1️⃣ Structured lookups (catalog data)
    let course = catalog.lookup_course(q)
    if course is not None:
        let ans = f"Course {course['code']} — {course['title']}: {course.get('description','No description')} (More: {course.get('url','')})"
        append_session(session, {"role":"user","text":q})
        append_session(session, {"role":"assistant","text":ans})
        return ans
    end

    let staff = catalog.lookup_staff(q)
    if staff is not None:
        let ans = f"{staff['name']} — {staff.get('title','')}\nEmail: {staff.get('email','')}\nProfile: {staff.get('url','')} "
        append_session(session, {"role":"user","text":q})
        append_session(session, {"role":"assistant","text":ans})
        return ans
    end

    # --- 2️⃣ Semantic search
    let docs = semantic_search(q, config.TOP_K, config.VECTOR_INDEX_PATH, config.VECTOR_META_PATH)
    let history = get_session_history(session)

    if len(docs) == 0:
        return "I'm sorry, I couldn't find any information related to your question."
    end

    # --- 3️⃣ Use local snippets if Grok API key not set
    let env_name = config.LLM_API_KEY_ENV
    let key = os.environ.get(env_name, "")

    if not key:
        let ans = "Here’s what I found from university documents:\n"
        for (id, snippet, url) in docs:
            ans += f"\nFrom {id}:\n{snippet[:300]}...\n"
        append_session(session, {"role":"user","text":q})
        append_session(session, {"role":"assistant","text":ans})
        utils.log_interaction(session, q, ans)
        return ans
    end

    # --- 4️⃣ Use Grok API if available
    let prompt = build_prompt(q, docs, history)
    let ans = call_grok_api(prompt)

    append_session(session, {"role":"user","text":q})
    append_session(session, {"role":"assistant","text":ans})
    utils.log_interaction(session, q, ans)

    return ans
end
