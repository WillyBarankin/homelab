# ⚙️ Planned CI/CD Stack & Services

The homelab is designed to simulate a production-like CI/CD environment for DevOps experimentation and personal projects.

## Planned Services & Deployment Targets

| Service/Tool                      | Deployment Target      | Rationale |
|----------------------------------|------------------------|-----------|
| **GitLab CE**                    | Separate VM            | Resource-intensive; isolation improves reliability and avoids contention with K3s workloads. |
| **GitLab Runner**                | `k3s-w-1`, `k3s-w-2`   | Deployed via Helm inside K3s; leverages Kubernetes scheduling and scaling. |
| **ArgoCD**                       | `k3s-cp-1` (K3s)       | Designed to run within Kubernetes; integrates tightly with GitOps workflows. |
| **External Secrets / SOPS + KMS**| `k3s-cp-1` (K3s)       | Lightweight controller; clean integration into K3s for secret syncing from encrypted files. |
| **PhotoPrism**                   | `charts/photoprism/`   | Self-hosted photo management (Helm chart). |

## Planned CI/CD Stack

| Category            | Tool/Service     | Purpose                                                                 |
|---------------------|------------------|-------------------------------------------------------------------------|
| **Git Hosting**     | GitLab CE        | Centralized Git repository management and integrated CI/CD platform     |
| **Runners**         | GitLab Runner    | Executes CI/CD pipelines on Kubernetes worker nodes                     |
| **K8s GitOps**      | ArgoCD           | Declarative GitOps delivery and continuous deployment for K8s workloads |
| **Container Registry** | GitLab Container Registry (self-hosted) | Stores Docker images securely within the GitLab CE environment          |
| **Secrets Management** | External Secrets / SOPS + KMS | Secure injection of secrets into Kubernetes from version-controlled encrypted files |
| **Webhook Gateway** | Gitea Webhook Proxy / GitLab Webhooks | Event-based triggers for pipelines and auto-deploy hooks                 |
| **Monitoring & Alerts** | Prometheus + Alertmanager | Observability stack for CI runners, ArgoCD status, and pod health        |
| **Dashboarding**    | Grafana          | Visualization of CI/CD and cluster health metrics                        |

This stack is intended to provide a robust, production-like CI/CD workflow for all homelab workloads. 