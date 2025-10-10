# build_index.py
from vector_search.search import build_index

if __name__ == "__main__":
    build_index("data/docs", "data/faiss_index.bin", "data/faiss_meta.json")
