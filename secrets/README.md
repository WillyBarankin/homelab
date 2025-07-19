# 🔐 Secrets Management

This directory contains templates and examples for secure secret management in the homelab infrastructure. All actual secrets are stored externally using HashiCorp Vault to maintain security best practices.

## ⚠️ Security Architecture

- **No secrets in version control** - encrypted or unencrypted
- **HashiCorp Vault integration** - centralized secret management and storage
- **Template-based approach** - examples provided for reference only
- **Environment-based separation** - different secrets per deployment environment

## 📁 Directory Structure

```
secrets/
├── README.md              # Security documentation and guidelines
├── .gitignore            # Prevents accidental commits of sensitive files
└── example.sops.yaml     # SOPS template for Kubernetes secrets
```

## 🔧 Secret Management Strategy

### HashiCorp Vault Implementation

The homelab uses HashiCorp Vault as the primary secret management solution:

- **Centralized Storage** - All secrets stored in Vault with encryption at rest
- **Dynamic Secrets** - Automatic credential generation and rotation
- **Access Control** - Role-based access control (RBAC) for secret access
- **Audit Logging** - Complete audit trail of all secret operations
- **Kubernetes Integration** - External Secrets Operator for K8s secret injection

### External Secrets Operator Integration

Vault integrates with Kubernetes through External Secrets Operator:

```yaml
# Example ExternalSecret manifest
apiVersion: external-secrets.io/v1beta1
kind: ExternalSecret
metadata:
  name: vault-secret
spec:
  secretStoreRef:
    name: vault-backend
    kind: SecretStore
  target:
    name: kubernetes-secret
  data:
  - secretKey: database-password
    remoteRef:
      key: database/creds/my-role
      property: password
```

### SOPS Template Usage

The `example.sops.yaml` file demonstrates the SOPS encryption format for Kubernetes secrets. This can be used as a fallback or for local development:

```bash
# Copy template to external location
cp example.sops.yaml ~/secure-secrets/

# Create actual secret (SOPS encrypts automatically)
sops ~/secure-secrets/production-secret.sops.yaml

# Deploy from secure location
kubectl apply -f ~/secure-secrets/production-secret.sops.yaml
```

## 🛡️ Security Implementation

- **Repository isolation** - No secrets committed to version control
- **Vault encryption** - All secrets encrypted at rest in Vault
- **Access control** - Vault RBAC and Kubernetes service accounts
- **Rotation policy** - Automatic secret rotation via Vault
- **Environment separation** - Distinct Vault namespaces per environment

## 📋 Supported Secret Formats

- **Kubernetes Secrets** - YAML files with `apiVersion: v1, kind: Secret`
- **Environment Files** - `.env` files for local development
- **Configuration Files** - Any YAML/JSON requiring encryption
- **Dynamic Secrets** - Database credentials, API keys generated on-demand

## 🔗 Integration Resources

- [HashiCorp Vault Documentation](https://developer.hashicorp.com/vault/docs)
- [External Secrets Operator](https://external-secrets.io/)
- [SOPS Documentation](https://github.com/mozilla/sops)
- [Kubernetes Secrets](https://kubernetes.io/docs/concepts/configuration/secret/)

## 🚨 Incident Response

In the event of secret compromise:

1. **Immediate rotation** of affected credentials via Vault
2. **Git history audit** to identify and remove any committed secrets
3. **System updates** to use new credentials
4. **Security review** to prevent future incidents 