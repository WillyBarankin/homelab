# 🖥️ Virtualization Environment

This homelab runs on a Proxmox VE hypervisor, leveraging KVM/QEMU for virtualization. Key features include:

- **Hypervisor:** Proxmox VE
- **Virtualization Type:** KVM/QEMU
- **GPU Passthrough:** Enabled via `vfio` and NVIDIA GPU Operator in K3s
- **Networking:**
  - **LAN (bridged):** For internal traffic and overlay networks
  - **NAT:** Via home router for outbound/internet traffic
  - **HTTPS exposure:** Through reverse proxy (Nginx)

**GPU Passthrough Note:**
- The EVGA P104-100 GPU requires manual unlocking by flashing a custom BIOS using `nvflash` to enable full access to all 8 GB of VRAM.

```mermaid
graph TD;
    PVE[Proxmox Host] --> K3sMaster[Control Plane Node];
    PVE --> K3sWorker[Worker Node w/ GPU];
    PVE -.->|"GPU Passthrough (HW)"| K3sWorker;
    K3sMaster -->|Runs| Core["Core Services (etcd, kube-apiserver, scheduler)"];
    K3sWorker -->|Runs| Ollama[Ollama LLM Server];
    K3sWorker -->|Runs| OpenWebUI[OpenWebUI Frontend];
    K3sWorker -.->|"NVIDIA GPU Operator (SW)"| Ollama;
```

**Networking Evolution:**
- The lab previously used a USB Wi-Fi adapter (no bridged mode support), requiring NAT and custom iptables rules. Now, bridged Ethernet is used for direct IP assignment to VMs and Kubernetes services, simplifying service exposure and removing the need for NAT or manual port forwarding. 
