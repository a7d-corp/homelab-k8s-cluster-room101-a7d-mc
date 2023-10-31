pm_host_port    = 8006
pm_tls_insecure = true

resource_pool = "room101-a7d-mc"

cpu                  = "custom-talos-kvm64"
resource_cpu_cores   = 2
resource_cpu_sockets = 1
resource_memory      = 3072

qemu_agent = 1

pxe_boot = true
boot     = "order=virtio0;net0"

# network config
network_model = "virtio"

# primary nic config
net0_network_bridge = "vmbr0"
net0_vlan_tag       = 1100

master_disk_type    = "virtio"
master_disk_storage = "local-lvm"
master_disk_size    = "30G"

worker_disk_type    = "virtio"
worker_disk_storage = "local-lvm"
worker_disk_size    = "30G"
