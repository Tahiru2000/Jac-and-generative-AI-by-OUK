# SMART AI Assistant

An intelligent multi-functional assistant built with **Jac Programming Language** and **Flask**, designed to help students, educators, and professionals interact with AI in real time.

This project started as a **Student CGPA Calculator** but has been extended into a more **versatile AI assistant** that can support academic, financial, and personal productivity use cases.



##  Features

*  **CGPA Calculator** → Students can enter their courses, credit hours, and scores, then get their CGPA along with performance advice.
*  **AI-Powered Assistant** → Extendable modules for education, finance, and general queries.
*  **Web Interface** → Simple and user-friendly interface built with Flask & HTML templates.
*  **Customizable Advice System** → Context-aware tips for academic performance improvement.
*  **Cloud-Ready** → Can be deployed on services like Heroku, Render, or AWS for public access.


##  Tech Stack

* **Jac** → Core logic and AI modeling.
* **Flask (Python)** → Web server & routing.
* **HTML/CSS (Templates)** → User interface.



## The Project Structure and locally deployed

SMART_AI_ASSISTANT/
│── app.py                # Flask application entry point
│── templates/            # HTML templates for the UI
│   ├── homepage.html
│   └── index.html
│── CGPA_CALCULATOR.jac   # Core Jac script for CGPA calculation
│── requirements.txt      # Python dependencies
│── README.md             # Project documentation
│── .gitignore            # Ignore unnecessary files




##  Installation & Setup

1. **Clone the repository**

   ```bash
   git clone https://github.com/<your-username>/SMART_AI_ASSISTANT.git
   cd SMART_AI_ASSISTANT
   ```

2. **Create and activate virtual environment**

   ```bash
   python3 -m venv venv
   source venv/bin/activate   # Linux/Mac
   venv\Scripts\activate      # Windows
   

3. **Install dependencies**

   bash
   pip install -r requirements.txt
   

4. **Run the Jac program (CLI mode)**

   bash
   jac run Main.jac
   

5. **Run the web server (Flask mode)**

   ```bash
   python app.py
   ```

   Open browser → [http://127.0.0.1:5000](http://127.0.0.1:5000)

---

## 📊 Future Improvements

* Add AI chatbot for academic Q&A.
* Integrate finance/banking simulation.
* Cloud deployment with Docker + Render.
* Voice-based input/output support.

---

## 👨‍💻 Author

**Shaibu Tahiru**
Built as part of an AI programming training program using the Jac language.

---
# 🎓 University Jac AI Agent (Enhanced)

This project implements an **intelligent university assistant** powered by **Jac language**, **FAISS semantic search**, and an optional **LLM backend (Grok or other compatible APIs)**.  
It enables querying university information (like courses, staff, admissions, and fees) via structured data and semantic document retrieval.

---

## 🚀 Features

- 🧭 **Semantic Search** — Retrieves relevant university documents using FAISS and SentenceTransformers.
- 📘 **Structured Catalog Lookup** — Supports direct queries about courses or staff.
- 🧑‍💻 **Session Memory** — Maintains dialogue context across sessions.
- 🧩 **Jac AI Agent Integration** — Uses `agent.jac` as the central logic for managing LLM and document search.
- 🔍 **LLM Integration** — Optionally connects to **Grok API** for enhanced, natural language answers.
- 📂 **Data-Driven Design** — Documents and catalog data stored under `data/`.

---

## 🏗️ Project Structure

univ_agent_jac_project_enhanced/
│
├── agent.jac # Main Jac agent logic
├── catalog.jac # Course & staff lookup logic
├── config.jac # Global configuration (paths, API keys, etc.)
├── utils.jac # JSON and logging utilities
│
├── sessions/
│ └── session_mgr.py # Session storage and history manager
│
├── vector_search/
│ └── search.py # FAISS-based vector indexing and semantic search
│
├── data/
│ ├── docs/ # Text documents for semantic retrieval
│ ├── catalog.json # Course and staff data
│ ├── sessions.json # Stores user session memory
│ ├── faiss_index.bin # FAISS vector index file
│ └── faiss_meta.json # FAISS metadata (document info)
│
├── build_index.py # Builds FAISS vector index from data/docs
├── main.py # FastAPI app to expose the Jac agent
├── requirements.txt # Python dependencies
└── README.md # Project documentation


## 🧩 How It Works

1. **Documents and catalog** are loaded from the `data/` folder.
2. The **FAISS vector index** is built by encoding text documents via `SentenceTransformer`.
3. When a user submits a query:
   - The agent first checks for **course or staff matches** in the catalog.
   - If not found, it runs a **semantic search** using FAISS.
   - Optionally, results are enhanced using **Grok API** if a key is provided.
4. User sessions are tracked and logged to allow contextual continuity.

---

## ⚙️ Requirements

### 🐍 Python Environment
Make sure you have **Python 3.11+** installed.

### 📦 Install Dependencies

```bash
python -m venv venv311
source venv311/bin/activate  # On Windows: venv311\Scripts\activate
pip install --upgrade pip setuptools wheel
pip install -r requirements.txt
🧠 Core Dependencies

Main packages used:

faiss-cpu

sentence-transformers

fastapi

uvicorn

jaseci

requests

numpy

🧰 Building the Vector Index
Before running the agent, you must build the semantic index:

bash
Copy code
python build_index.py
You should see output like:

pgsql
Copy code
Built index with 5 documents.
This generates:

data/faiss_index.bin

data/faiss_meta.json

 Running the Application
Start the FastAPI server:

bash
Copy code
uvicorn main:app --reload
Then open your browser to:
 http://127.0.0.1:8000/ui

You’ll see the Jac Agent Query UI.
Try queries like:

Admission overview

Fees information

List of available courses

Lecturer contact for Computer Science

 Environment Variables
Set your Grok API key (if available):

bash
Copy code
export GROK_API_KEY="your_grok_api_key_here"
If no key is set, the agent will fall back to local snippet-based answers.

