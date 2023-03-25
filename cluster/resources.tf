resource "macaddress" "master_net0_mac" {
  count = local.master_count
}

resource "random_string" "master_serial" {
  count = local.master_count

  length  = 16
  special = false
  upper   = false
}

module "master_instances" {
  count = local.master_count

  source = "github.com/glitchcrab/terraform-module-proxmox-instance?ref=v1.6.0"

  pve_instance_name        = "master${count.index}-${local.name_stub}"
  pve_instance_description = "${local.master_description} (serial: ${random_string.master_serial[count.index].result})"
  vmid                     = local.vmid_base + count.index + local.vmid_offset

  target_node   = lookup(local.host_list[count.index], "name")
  resource_pool = var.resource_pool

  hastate = local.hastate
  hagroup = lookup(local.host_list[count.index], "hagroup")

  pxe_boot = var.pxe_boot

  cores   = var.resource_cpu_cores
  sockets = var.resource_cpu_sockets
  memory  = var.resource_memory
  boot    = var.boot

  oncreate = local.master_oncreate

  network_interfaces = [{
    bridge  = var.net0_network_bridge
    macaddr = upper(macaddress.master_net0_mac[count.index].address)
    model   = var.network_model
    tag     = var.net0_vlan_tag
  }]

  disks = [{
    size    = var.master_disk_size
    storage = var.master_disk_storage
    type    = var.master_disk_type
  }]
}

resource "macaddress" "worker_net0_mac" {
  count = local.worker_count
}

resource "random_string" "worker_serial" {
  count = local.worker_count

  length  = 16
  special = false
  upper   = false
}

module "worker_instances" {
  count = local.worker_count

  source = "github.com/glitchcrab/terraform-module-proxmox-instance?ref=v1.6.0"

  pve_instance_name        = "worker${count.index}-${local.name_stub}"
  pve_instance_description = "${local.worker_description} (serial: ${random_string.worker_serial[count.index].result})"
  vmid                     = local.vmid_base + count.index + local.vmid_offset + 5

  target_node   = lookup(local.host_list[count.index], "name")
  resource_pool = var.resource_pool

  hastate = local.hastate
  hagroup = lookup(local.host_list[count.index], "hagroup")

  pxe_boot = var.pxe_boot

  cores   = var.resource_cpu_cores
  sockets = var.resource_cpu_sockets
  memory  = var.resource_memory
  boot    = var.boot

  oncreate = local.worker_oncreate

  network_interfaces = [{
    bridge  = var.net0_network_bridge
    macaddr = upper(macaddress.worker_net0_mac[count.index].address)
    model   = var.network_model
    tag     = var.net0_vlan_tag
  }]

  disks = [{
    size    = var.worker_disk_size
    storage = var.worker_disk_storage
    type    = var.worker_disk_type
  }]
}
