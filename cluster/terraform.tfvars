pm_host_port    = 8006
pm_tls_insecure = true

instance_domain = "node.room101.a7d"

resource_pool = "room101-a7d-mc"

resource_cpu_cores   = 2
resource_cpu_sockets = 1
resource_memory      = 3072

# network config
network_model = "virtio"

# primary nic config
net0_name           = "ens18"
net0_network_bridge = "vmbr0"
net0_vlan_tag       = 1100

searchdomain = "analbeard.com"
nameserver   = "10.101.0.60"
