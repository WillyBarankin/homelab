# 🧠 LLM Stack Details

The LLM (Large Language Model) stack in this homelab is designed for local, GPU-accelerated inference and experimentation:

- **Ollama:** Serves locally hosted LLMs (e.g., LLaMA, Mistral) and provides a backend API for inference.
- **OpenWebUI:** A browser-based chat interface that connects to Ollama, allowing interactive LLM usage.
- **NVIDIA GPU Operator:** Automatically provisions and manages GPU resources in Kubernetes, ensuring that LLM workloads can access the GPU.
- **GitLab Runner:** Executes CI jobs for LLM testing pipelines, enabling automated model evaluation and deployment.

**Key Features:**
- GPU resource allocation via the NVIDIA GPU Operator
- Persistent storage for model cache
- Resource limits and requests for optimal performance
- Integration with CI/CD pipelines for continuous improvement 