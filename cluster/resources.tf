resource "macaddress" "master_net0_mac" {
  count = local.master_count
}

module "master_instances" {
  count = local.master_count

  source = "github.com/glitchcrab/terraform-module-proxmox-instance?ref=v1.3.0"

  pve_instance_name        = "master${count.index}-${local.name_stub}"
  pve_instance_description = "kubernetes managment cluster master"
  vmid                     = local.vmid_base + count.index + local.vmid_offset_master

  target_node   = element(local.host_list, count.index)
  resource_pool = var.resource_pool

  pxe_boot = true

  cores   = var.resource_cpu_cores
  sockets = var.resource_cpu_sockets
  memory  = var.resource_memory
  boot    = var.boot

  network_interfaces = [{
    model   = var.network_model
    bridge  = var.net0_network_bridge
    tag     = var.net0_vlan_tag
    macaddr = upper(macaddress.master_net0_mac[count.index].address)
  }]

  disks = [{
    type    = var.master_disk_type
    storage = var.master_disk_storage
    size    = var.master_disk_size
  }]
}

resource "macaddress" "worker_net0_mac" {
  count = local.worker_count
}

module "worker_instances" {
  count = local.worker_count

  source = "github.com/glitchcrab/terraform-module-proxmox-instance?ref=v1.3.0"

  pve_instance_name        = "worker${count.index}-${local.name_stub}"
  pve_instance_description = "kubernetes managment cluster worker"
  vmid                     = local.vmid_base + local.vmid_offset_master + 1 + count.index

  target_node   = element(local.host_list, count.index)
  resource_pool = var.resource_pool

  pxe_boot = true

  cores   = var.resource_cpu_cores
  sockets = var.resource_cpu_sockets
  memory  = var.resource_memory
  boot    = var.boot

  network_interfaces = [{
    model   = var.network_model
    bridge  = var.net0_network_bridge
    tag     = var.net0_vlan_tag
    macaddr = upper(macaddress.worker_net0_mac[count.index].address)
  }]

  disks = [{
    type    = var.worker_disk_type
    storage = var.worker_disk_storage
    size    = var.worker_disk_size
  }]
}
