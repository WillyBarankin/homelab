# 🚧 Known Limitations

- **GPU (EVGA P104-100):** Requires manual unlocking by flashing a custom BIOS using `nvflash` to enable full access to all 8 GB of VRAM. This is necessary for certain LLM workloads that require large memory.
- **P2 NVMe SSD:** May throttle under sustained load, which can impact performance for I/O-intensive workloads.

**Networking Constraints (Historical):**
- The original use of a USB Wi-Fi adapter (no bridged mode support) required NAT and custom iptables rules, complicating service exposure. This has since been resolved by switching to bridged Ethernet. 