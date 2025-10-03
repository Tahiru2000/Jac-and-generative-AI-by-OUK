# Jac Multimodal AI Chatbot

This project demonstrates how to build a **modern multimodal chatbot** capable of interacting with documents, images, and videos. By leveraging **Jac's unique programming paradigms**.

---

## Features

- **Multimodal Interaction**: Chat with PDFs, text files, images, and videos.  
- **Context-Aware Responses**: Search documents and provide relevant answers.  
- **Web Search Integration**: Answer general questions using real-time web search.  
- **AI Vision**: Understand and discuss images and videos.  
- **Intelligent Query Routing**: Automatically route questions to specialized AI handlers.  

---

## Learning Objectives

- **Object Spatial Programming (OSP)**: Organize your application using Jac's node-walker architecture.  
- **Mean Typed Programming (MTP)**: Enable AI to classify and route user queries automatically.  
- **Model Context Protocol (MCP)**: Build modular, reusable AI tools.  
- **Multimodal AI Development**: Work with text, images, and videos in one application.  

---

## Technologies Used

- **Jac Language**: Core application logic.  
- **Jac Cloud**: Backend server infrastructure.  
- **Streamlit**: User-friendly web interface.  
- **ChromaDB**: Document search and storage.  
- **OpenAI GPT**: AI chat and vision capabilities.  
- **Serper API**: Real-time web search.  

---

## Project Structure

| File | Purpose |
|------|---------|
| `client.jac` | Web interface for chat and file uploads. |
| `server.jac` | Main application logic using Object Spatial Programming. |
| `server.impl.jac` | Implementation details for `server.jac`. |
| `mcp_server.jac` | Tool server for document and web search. |
| `mcp_client.jac` | Interface for tool communication. |
| `tools.jac` | Document processing and search logic. |

---

## Setup Instructions

### Prerequisites

- Python **3.12** or newer  
- API keys for **OpenAI** and **Serper**  

### Installation

Install required packages:

```bash
pip install jaclang jac-cloud jac-streamlit byllm langchain langchain-community langchain-openai langchain-chroma chromadb openai pypdf tiktoken requests mcp[cli] anyio


#Set environment variables: go to serper and openai to create yours
"""export OPENAI_API_KEY=<your-openai-key>
export SERPER_API_KEY=<your-serper-key>"""

Running the Application

Follow these steps to start the chatbot:

1.Start the tool server: jac run mcp_server.jac


2.Start the main application: jac serve server.jac


3.Launch the web interface: jac streamlit client.jac


Access the web interface: http://localhost:8501
