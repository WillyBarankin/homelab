# 📈 Cluster Topology & Rationale

The homelab is structured as a two-node K3s cluster running on Proxmox VMs:

- **Control Plane Node (`k3s-cp-1`):** Hosts core Kubernetes services (etcd, kube-apiserver, scheduler).
- **Worker Node 1 (`k3s-w-1`):** GPU-enabled, runs Ollama, OpenWebUI, and the NVIDIA GPU Operator.
- **Worker Node 2 (`k3s-w-2`):** Storage-focused, runs PhotoPrism and other workloads.

**Diagram Explanation:**
- The diagram shows the Proxmox host at the base, with VMs for the control plane and worker nodes.
- GPU passthrough is enabled for the first worker node, allowing LLM workloads to utilize the GPU.
- Services are distributed to optimize resource usage and reliability.
- Dimmed blocks in the diagram represent planned (not yet implemented) services.

This topology allows for:
- Efficient use of hardware resources
- Isolation of resource-intensive services (e.g., GitLab CE on a separate VM)
- Flexibility for future expansion (additional nodes, services, or workloads) 