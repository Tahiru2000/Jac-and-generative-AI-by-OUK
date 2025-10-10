import os
import json
import threading

# Path to session storage (matches config.jac)
DATA_PATH = "data/sessions.json"

# Lock for safe concurrent access
_lock = threading.Lock()


def _load_sessions():
    """Load all session data from JSON file."""
    if not os.path.exists(DATA_PATH):
        return {}
    try:
        with open(DATA_PATH, "r", encoding="utf-8") as f:
            return json.load(f)
    except Exception:
        return {}


def _save_sessions(data):
    """Save session data back to JSON file."""
    with _lock:
        os.makedirs(os.path.dirname(DATA_PATH), exist_ok=True)
        with open(DATA_PATH, "w", encoding="utf-8") as f:
            json.dump(data, f, indent=2)


def get_session_history(session_id):
    """Return the full chat history for a given session."""
    sessions = _load_sessions()
    return sessions.get(session_id, [])


def append_session(session_id, turn):
    """
    Append a new message turn to the session.
    turn must be a dict, e.g. {"role": "user"|"assistant", "text": "..."}
    """
    with _lock:
        sessions = _load_sessions()
        if session_id not in sessions:
            sessions[session_id] = []
        sessions[session_id].append(turn)
        _save_sessions(sessions)


def clear_session(session_id):
    """Delete a specific session."""
    with _lock:
        sessions = _load_sessions()
        if session_id in sessions:
            del sessions[session_id]
            _save_sessions(sessions)


def list_sessions():
    """Return a list of all active session IDs."""
    sessions = _load_sessions()
    return list(sessions.keys())
