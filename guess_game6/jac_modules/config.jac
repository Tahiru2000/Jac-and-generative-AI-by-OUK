# config.jac
# Configuration for the University Jac AI Agent

glob LLM_PROVIDER = "grok"  # set to "grok" per your preference
glob LLM_API_URL = "https://api.grok.ai/v1/generate"  # placeholder - replace with actual Grok API endpoint if available
glob LLM_API_KEY_ENV = "GROK_API_KEY"  # environment variable name for the Grok API key

glob TOP_K = 5  # number of documents to retrieve for context

glob DOCS_PATH = "data/docs"
glob CATALOG_PATH = "data/catalog.json"

glob BASE_URL = "https://www.university.edu"
glob SESSIONS_PATH = "data/sessions.json"

# Vector index files
glob VECTOR_INDEX_PATH = "data/faiss_index.bin"
glob VECTOR_META_PATH = "data/faiss_meta.json"
