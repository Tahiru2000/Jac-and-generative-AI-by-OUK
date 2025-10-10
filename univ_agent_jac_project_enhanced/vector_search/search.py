# vector_search/search.py
import os
import json
import faiss
import numpy as np
from sentence_transformers import SentenceTransformer

model = SentenceTransformer("all-MiniLM-L6-v2")

def build_index(docs_dir, index_path, meta_path):
    """Build FAISS index from all .txt files in docs_dir"""
    texts = []
    meta = []
    for filename in os.listdir(docs_dir):
        if filename.endswith(".txt"):
            path = os.path.join(docs_dir, filename)
            with open(path, "r", encoding="utf-8") as f:
                content = f.read().strip()
                texts.append(content)
                meta.append({"id": filename, "url": f"/docs/{filename}"})
    if not texts:
        print("No documents found.")
        return

    embeddings = model.encode(texts, convert_to_numpy=True)
    dim = embeddings.shape[1]
    index = faiss.IndexFlatL2(dim)
    index.add(embeddings)
    faiss.write_index(index, index_path)

    with open(meta_path, "w") as f:
        json.dump(meta, f, indent=2)
    print(f"Built index with {len(texts)} documents.")

def semantic_search(query, top_k, index_path, meta_path):
    """Return top_k documents related to query"""
    if not os.path.exists(index_path) or not os.path.exists(meta_path):
        print("Index or metadata not found. Please run build_index.py first.")
        return []

    index = faiss.read_index(index_path)
    with open(meta_path, "r") as f:
        meta = json.load(f)

    query_vec = model.encode([query], convert_to_numpy=True)
    D, I = index.search(query_vec, top_k)
    results = []
    for idx in I[0]:
        if idx < len(meta):
            doc_id = meta[idx]["id"]
            with open(os.path.join("data/docs", doc_id), "r", encoding="utf-8") as f:
                snippet = f.read()[:400]
            results.append((doc_id, snippet, meta[idx]["url"]))
    return results
