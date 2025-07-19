# ☸️ Kubernetes Infrastructure

This directory contains the Kubernetes manifests, Helm charts, and GitOps configurations for the homelab infrastructure. The deployment follows a GitOps approach using ArgoCD for declarative application management.

## 📁 Directory Structure

```
k8s/
├── README.md              # This documentation
├── base/                  # Base Kustomize configurations
│   ├── namespaces/        # Namespace definitions
│   ├── crds/             # Custom Resource Definitions
│   └── common/           # Shared resources and configurations
├── charts/               # Helm charts for applications
│   ├── ollama/           # Ollama LLM server chart
│   ├── openwebui/        # OpenWebUI frontend chart
│   ├── nvidia-gpu-operator/ # NVIDIA GPU Operator chart
│   └── photoprism/      # PhotoPrism photo management chart
└── overlays/             # Environment-specific configurations
    ├── development/      # Development environment overlays
    └── production/       # Production environment overlays
```

## Accessing the Cluster

To manage your K3s cluster remotely with `kubectl`, you need the kubeconfig file from the control plane node.

1. **Obtain the kubeconfig:**
   - On the control plane node, the file is located at `/etc/rancher/k3s/k3s.yaml`.
   - Copy it to your client machine (e.g., with `scp`):
     ```sh
     scp user@k3s-control-plane:/etc/rancher/k3s/k3s.yaml ~/k3s.yaml
     ```
   - Edit the `server:` line in `k3s.yaml` to use the control plane's real IP or DNS name (not `127.0.0.1`).

2. **Use with kubectl:**
   - Run:
     ```sh
     KUBECONFIG=~/k3s.yaml kubectl get nodes
     ```
   - Or set it as your default:
     ```sh
     export KUBECONFIG=~/k3s.yaml
     kubectl get pods -A
     ```

> **Security Note:** Never commit your kubeconfig file to version control. It contains credentials that grant access to your cluster.

## 🏗️ Architecture Overview

The Kubernetes infrastructure is organized using a **GitOps pattern** with the following components:

- **Base Configurations** - Reusable Kustomize bases for common resources
- **Helm Charts** - Application-specific deployment configurations
- **Environment Overlays** - Environment-specific customizations
- **ArgoCD Integration** - Automated deployment and synchronization

## 🔧 Deployment Strategy

### GitOps Workflow

1. **Base Configuration** - Common resources defined in `base/`
2. **Application Charts** - Helm charts for each application in `charts/`
3. **Environment Overlays** - Environment-specific customizations in `overlays/`
4. **ArgoCD Sync** - Automated deployment and drift detection

### Application Deployment

Applications are deployed using ArgoCD Application manifests. See `overlays/production/` for specific application configurations.

## 🧠 LLM Stack Configuration

### Ollama Deployment

The Ollama LLM server is deployed with GPU support. Configuration details are in `charts/ollama/values.yaml`.

Key features:
- GPU resource allocation via NVIDIA GPU Operator
- Persistent storage for model cache
- Resource limits and requests for optimal performance

### OpenWebUI Integration

OpenWebUI provides the web interface for Ollama. Configuration is in `charts/openwebui/values.yaml`.

Features:
- Ingress configuration with SSL termination
- Service discovery for Ollama backend
- Resource optimization for web interface

## 🎮 GPU Configuration

### NVIDIA GPU Operator

GPU resources are managed through the NVIDIA GPU Operator. See `charts/nvidia-gpu-operator/values.yaml` for configuration details.

Features:
- Automatic GPU device plugin installation
- DCGM monitoring and metrics
- Container runtime integration

### GPU Resource Allocation

Applications request GPU resources using standard Kubernetes resource specifications. See individual chart configurations for specific resource allocations.

## 🔐 Security Implementation

### Namespace Isolation

Applications are deployed in dedicated namespaces:

- `llm` - LLM applications (Ollama, OpenWebUI)
- `gitops` - ArgoCD and GitOps tools
- `secrets` - External Secrets Operator

### RBAC Configuration

Role-based access control is implemented for:

- **Service Accounts** - Application-specific identities
- **Cluster Roles** - System-wide permissions
- **Namespaced Roles** - Namespace-specific permissions

## 📊 Monitoring and Observability

### External Monitoring Stack

Prometheus and Grafana are deployed on a separate server outside the Kubernetes cluster. Kubernetes applications expose metrics for external Prometheus scraping.

### ServiceMonitor Configuration

Applications include ServiceMonitor configurations for external Prometheus integration:

- **Ollama Metrics** - LLM inference performance and GPU utilization
- **OpenWebUI Metrics** - Web interface performance and user activity
- **NVIDIA GPU Metrics** - GPU resource usage and health

## 🔄 CI/CD Integration

### ArgoCD Applications

Applications are managed through ArgoCD. Application manifests are in `overlays/production/applications/`.

### GitLab Runner Integration

CI/CD pipelines run on Kubernetes using GitLab Runner. Configuration is in `charts/gitlab-runner/values.yaml`.

## 🛠️ Development Workflow

### Local Development

1. **Install Tools**:
   ```bash
   kubectl version --client
   helm version
   kustomize version
   ```

2. **Apply Base Configuration**:
   ```bash
   kubectl apply -k k8s/base/
   ```

3. **Deploy Applications**:
   ```bash
   helm install ollama k8s/charts/ollama/
   helm install openwebui k8s/charts/openwebui/
   ```

### Production Deployment

1. **Configure ArgoCD**:
   ```bash
   kubectl apply -f k8s/argocd/
   ```

2. **Create Applications**:
   ```bash
   kubectl apply -f k8s/applications/
   ```

3. **Monitor Sync Status**:
   ```bash
   argocd app list
   argocd app sync llm-stack
   ```

## 📋 Supported Applications

| Application | Chart Location | Purpose |
|-------------|----------------|---------|
| **Ollama** | `charts/ollama/` | LLM server with GPU support |
| **OpenWebUI** | `charts/openwebui/` | Web interface for Ollama |
| **NVIDIA GPU Operator** | `charts/nvidia-gpu-operator/` | GPU resource management |
| **PhotoPrism** | `charts/photoprism/` | Self-hosted photo management (Helm chart) |

### PhotoPrism Deployment

PhotoPrism is deployed via its own Helm chart for private photo management and search.

## 🔗 Related Resources

- [K3s Documentation](https://docs.k3s.io/)
- [ArgoCD Documentation](https://argo-cd.readthedocs.io/)
- [Helm Documentation](https://helm.sh/docs/)
- [Kustomize Documentation](https://kustomize.io/)
- [NVIDIA GPU Operator](https://docs.nvidia.com/datacenter/cloud-native/gpu-operator/)

## 🚨 Troubleshooting

### Common Issues

1. **GPU Not Available**:
   ```bash
   kubectl get nodes -o json | jq '.items[].status.allocatable'
   ```

2. **ArgoCD Sync Failures**:
   ```bash
   argocd app logs llm-stack
   ```

3. **Resource Constraints**:
   ```bash
   kubectl describe pod -n llm ollama-pod
   ```

### Debug Commands

```bash
# Check GPU operator status
kubectl get pods -n gpu-operator-resources

# Verify Ollama GPU access
kubectl exec -it ollama-pod -- nvidia-smi

# Check ArgoCD application status
argocd app get llm-stack
``` 

> Note: The `charts/` directory for Helm charts does not currently exist. It will be created to store new charts such as photoprism. 