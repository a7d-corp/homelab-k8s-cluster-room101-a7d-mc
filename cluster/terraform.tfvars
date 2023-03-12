pm_host_port    = 8006
pm_tls_insecure = true

resource_pool = "room101-a7d-mc"

resource_cpu_cores   = 2
resource_cpu_sockets = 1
resource_memory      = 3072

pxe_boot = true
boot     = "order=scsi0;net0"

# network config
network_model = "virtio"

# primary nic config
net0_network_bridge = "vmbr0"
net0_vlan_tag       = 1100

master_disk_type    = "scsi"
master_disk_storage = "local-lvm"
master_disk_size    = "30G"

worker_disk_type    = "scsi"
worker_disk_storage = "local-lvm"
worker_disk_size    = "30G"
