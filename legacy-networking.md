## 🌐 Networking: NAT and Port Forwarding

Due to hardware limitations, specifically the use of a **USB Wi-Fi adapter**, bridged networking is not supported on this Proxmox host. This constraint prevents me from assigning public IPs directly to VMs or containers. To work around this, the system uses **NAT-based forwarding** and `iptables` rules to provide:

- **Internet access** for K3s nodes.
- **External access** to select services inside the K3s cluster (e.g., OpenWebUI).

### Why NAT?

NAT (Network Address Translation) is required because:

- The USB Wi-Fi interface cannot be bridged in Proxmox (no MAC spoofing support).
- All K3s nodes are on a private internal network (e.g., `192.168.100.0/24`).
- Public internet traffic must be routed through the host using masquerade rules.

### Current iptables Configuration

Below are the current `iptables` rules used to enable NAT and port forwarding.

#### Masquerade K3s Subnet for Internet Access

```bash
iptables -t nat -A POSTROUTING -s 192.168.100.0/24 -o wlxd03745f7912b -j MASQUERADE
```

#### DNAT Rule: Expose OpenWebUI

This rule forwards incoming TCP traffic on port `8080` from the host to the K3s service on `192.168.100.3:32000` (NodePort exposed by OpenWebUI):

```bash
iptables -t nat -A PREROUTING -p tcp --dport 8080 -j DNAT --to-destination 192.168.100.3:32000
iptables -t nat -A POSTROUTING -p tcp -d 192.168.100.3 --dport 32000 -j MASQUERADE
```

### Example: Accessing OpenWebUI

With the current setup, I can access the OpenWebUI chat interface by visiting:

```
http://<proxmox-ip>:8080
```

This forwards traffic to the NodePort inside the K3s worker node.

### Future Plans

- Replace USB Wi-Fi with a bridgable Ethernet interface or PCI Wi-Fi card to simplify networking.
- Move port forwarding logic to a managed firewall script or tool (e.g., `firewalld`, `ufw`, or Ansible role).
- Add HTTPS reverse proxy (e.g., Caddy or Nginx) to expose selected services securely.
