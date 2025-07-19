# 🚀 Planned Services Integration Sequence

This document outlines the logical sequence for integrating planned services into the homelab infrastructure, organized by dependencies and implementation phases.

## 📋 Integration Overview

The planned services will be integrated in phases to ensure proper dependencies are met and to minimize disruption to existing infrastructure. Each phase builds upon the previous one, creating a robust and scalable foundation.

## ✅ Already Implemented Services

The following services are currently operational and will serve as the foundation for the planned integration:

### Core Infrastructure
- **Proxmox VE** - Hypervisor and VM management
- **K3s Cluster** - Kubernetes cluster with control plane and worker nodes
- **Nginx** - Reverse proxy and HTTPS termination
- **Authelia** - Authentication and 2FA portal

### Application Services
- **Ollama** - Local LLM server with GPU support
- **OpenWebUI** - Web chat interface for Ollama
- **PhotoPrism** - Photo management and search
- **Homepage** - Central dashboard and service overview
- **Webmin** - System administration panel

### Supporting Infrastructure
- **NVIDIA GPU Operator** - GPU resource management in K3s
- **Certbot** - SSL certificate management and renewal
- **Legacy Networking** - NAT and port forwarding (Wi-Fi setup)

### Documentation & Configuration
- **Helm Charts** - PhotoPrism deployment
- **Docker Compose** - Homepage and Authelia services
- **Configuration Management** - Centralized configs for all services

## 🎯 Phase 1: Foundation & Monitoring

### 1.1 Prometheus + Grafana
**Deployment Target:** VM + Frontend server  
**Timeline:** First priority  
**Dependencies:** None  

**Rationale:**
- Provides observability for all subsequent services
- Enables proactive monitoring and alerting
- Essential for troubleshooting and performance optimization

**Implementation:**
- Prometheus on dedicated VM for resource monitoring
- Grafana on frontend server for dashboards
- Configure service discovery for K3s cluster
- Set up alerting rules for critical services

**Resource Requirements:**
- Prometheus VM: 2-4 vCPU, 4-8GB RAM, 50GB+ disk
- Grafana: Frontend server (existing)

### 1.2 Secret Vault (HashiCorp Vault)
**Deployment Target:** VM  
**Timeline:** Early in Phase 1  
**Dependencies:** None  

**Rationale:**
- Required for secure credential management
- Centralized secrets for all services
- Enables dynamic secret generation and rotation

**Implementation:**
- VM with 4-8 vCPU, 8-16GB RAM
- Configure TLS certificates
- Set up authentication and policies
- Integrate with External Secrets Operator for K3s

**Resource Requirements:**
- Vault VM: 4-8 vCPU, 8-16GB RAM, 50GB+ disk

---

## 🔧 Phase 2: Core CI/CD Infrastructure

### 2.1 GitLab CE
**Deployment Target:** VM  
**Timeline:** After Phase 1 completion  
**Dependencies:** Secret Vault (for credentials)  

**Rationale:**
- Foundation for all development workflows
- Provides Git hosting, issue tracking, and CI/CD
- Built-in container registry for image storage

**Implementation:**
- VM with 4-8 vCPU, 8-16GB RAM, 100GB+ disk
- Configure external PostgreSQL (optional)
- Set up container registry
- Integrate with Vault for secrets management
- Configure backup and monitoring

**Resource Requirements:**
- GitLab VM: 4-8 vCPU, 8-16GB RAM, 100GB+ disk

### 2.2 GitLab Runner
**Deployment Target:** k3s-w-1, k3s-w-2  
**Timeline:** After GitLab CE deployment  
**Dependencies:** GitLab CE, K3s cluster  

**Rationale:**
- Enables CI/CD pipeline execution
- Leverages Kubernetes scheduling and scaling
- Supports GPU workloads for LLM testing

**Implementation:**
- Helm chart deployment in K3s
- Configure for GPU workloads (k3s-w-1)
- Configure for general workloads (k3s-w-2)
- Set up resource limits and security policies

**Resource Requirements:**
- Uses existing K3s worker node resources
- GPU access on k3s-w-1 for LLM workloads

---

## 🔄 Phase 3: GitOps & Automation

### 3.1 ArgoCD
**Deployment Target:** k3s-cp-1  
**Timeline:** After Phase 2 completion  
**Dependencies:** GitLab CE (for Git repos), K3s cluster  

**Rationale:**
- GitOps deployment for Kubernetes workloads
- Declarative configuration management
- Automated drift detection and reconciliation

**Implementation:**
- Helm chart deployment in k3s-cp-1
- Configure GitLab integration
- Set up application repositories
- Configure RBAC and security policies
- Integrate with monitoring stack

**Resource Requirements:**
- Uses existing k3s-cp-1 resources
- Minimal additional overhead

### 3.2 Ansible
**Deployment Target:** VM  
**Timeline:** After ArgoCD deployment  
**Dependencies:** GitLab CE (for playbook storage)  

**Rationale:**
- Infrastructure automation and configuration management
- VM provisioning and maintenance
- Integration with CI/CD pipelines

**Implementation:**
- VM with 2-4 vCPU, 4-8GB RAM
- Configure GitLab integration
- Create playbooks for VM provisioning
- Set up inventory management
- Configure backup and monitoring

**Resource Requirements:**
- Ansible VM: 2-4 vCPU, 4-8GB RAM, 50GB+ disk

---

## 💾 Phase 4: Backup & Management

### 4.1 Proxmox Backup
**Deployment Target:** Frontend server  
**Timeline:** After all other services are stable  
**Dependencies:** All VMs and services running  

**Rationale:**
- Automated VM backups and disaster recovery
- Centralized backup management
- Integration with existing infrastructure

**Implementation:**
- Frontend server deployment
- Configure backup schedules
- Set up retention policies
- Integrate with monitoring and alerting
- Test restore procedures

**Resource Requirements:**
- Uses existing frontend server resources
- Additional storage for backup retention

---

## 🔗 Service Integration Matrix

| Service | Prometheus | Grafana | Vault | GitLab CE | GitLab Runner | ArgoCD | Ansible | Proxmox Backup |
|---------|------------|---------|-------|-----------|---------------|--------|---------|----------------|
| **Prometheus** | - | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ |
| **Grafana** | ✅ | - | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ |
| **Vault** | ✅ | ✅ | - | ❌ | ❌ | ❌ | ❌ | ❌ |
| **GitLab CE** | ✅ | ✅ | ✅ | - | ❌ | ❌ | ❌ | ❌ |
| **GitLab Runner** | ✅ | ✅ | ✅ | ✅ | - | ❌ | ❌ | ❌ |
| **ArgoCD** | ✅ | ✅ | ✅ | ✅ | ✅ | - | ❌ | ❌ |
| **Ansible** | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | - | ❌ |
| **Proxmox Backup** | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | - |

**Legend:**
- ✅ = Integrates with
- ❌ = No direct integration
- - = Self-reference

## 🛡️ Security Considerations

### Authentication & Authorization
- All services integrate with existing Authelia setup
- Vault provides centralized authentication
- RBAC configured for each service
- Service-to-service communication secured

### Network Security
- All services behind Nginx reverse proxy
- HTTPS termination and SSL/TLS encryption
- Internal service communication over secure networks
- Firewall rules configured for service access

### Secrets Management
- Vault as central secrets store
- External Secrets Operator for K3s integration
- SOPS for encrypted configuration files
- Regular secret rotation and audit

## 📊 Resource Planning

### VM Resource Allocation
| VM Name | Purpose | vCPU | RAM | Disk | Priority |
|---------|---------|------|-----|------|----------|
| `prometheus` | Monitoring | 2-4 | 4-8GB | 50GB+ | High |
| `vault` | Secrets Management | 4-8 | 8-16GB | 50GB+ | High |
| `gitlab-ce` | Git Hosting | 4-8 | 8-16GB | 100GB+ | Medium |
| `ansible` | Automation | 2-4 | 4-8GB | 50GB+ | Low |
| `proxmox-backup` | Backup Management | 2-4 | 4-8GB | 100GB+ | Low |

### K3s Resource Usage
- **k3s-cp-1:** ArgoCD deployment (minimal overhead)
- **k3s-w-1:** GitLab Runner (GPU workloads)
- **k3s-w-2:** GitLab Runner (general workloads)

## 🔄 Migration Strategy

### Existing Services
- Current services (Ollama, OpenWebUI, PhotoPrism) remain unchanged
- Gradual migration to GitOps deployment via ArgoCD
- Backup and monitoring integration for existing services

### Rollback Plan
- Each phase includes rollback procedures
- Service-specific backup and restore procedures
- Dependency-aware rollback sequence

## 📈 Success Metrics

### Phase 1 Success Criteria
- [ ] Prometheus collecting metrics from all nodes
- [ ] Grafana dashboards operational
- [ ] Vault accessible and configured
- [ ] Alerting rules configured and tested

### Phase 2 Success Criteria
- [ ] GitLab CE accessible and functional
- [ ] GitLab Runner executing jobs
- [ ] Container registry operational
- [ ] CI/CD pipelines running

### Phase 3 Success Criteria
- [ ] ArgoCD managing applications
- [ ] GitOps workflows operational
- [ ] Ansible playbooks functional
- [ ] Infrastructure automation working

### Phase 4 Success Criteria
- [ ] Proxmox Backup operational
- [ ] Backup schedules configured
- [ ] Restore procedures tested
- [ ] Disaster recovery plan documented

## 🔗 Related Documentation

- [Kubernetes Infrastructure](./k8s/README.md)
- [Planned CI/CD Stack & Services](./ci-cd.md)
- [Cluster Topology & Rationale](./cluster-topology.md)
- [Secrets Management](./../secrets/README.md)
- [Roadmap & To-Do](./roadmap.md)

## 🚨 Risk Mitigation

### Technical Risks
- **Resource contention:** Monitor resource usage and scale as needed
- **Service dependencies:** Implement health checks and circuit breakers
- **Data loss:** Regular backups and disaster recovery testing

### Operational Risks
- **Complexity management:** Document procedures and automate where possible
- **Security vulnerabilities:** Regular security updates and vulnerability scanning
- **Performance degradation:** Monitor performance metrics and optimize

---

*This integration plan is designed to be flexible and can be adjusted based on changing requirements, resource availability, and operational priorities.* 