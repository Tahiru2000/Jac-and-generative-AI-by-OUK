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
