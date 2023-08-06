resource "local_file" "set_smbios_values" {
  content = templatefile("${path.module}/templates/set_smbios_values.sh.tpl", {
    pm_api_url = local.pm_api_url
    master_sku = local.master_sku
    worker_sku = local.worker_sku
    family     = local.family
  })

  filename        = "scripts/set_smbios_values.sh"
  file_permission = "0755"
}

resource "macaddress" "master_net0_mac" {
  count = local.master_count
}

module "master_instances" {
  count      = local.master_count
  depends_on = [local_file.set_smbios_values]

  source = "github.com/glitchcrab/terraform-module-proxmox-instance?ref=v1.8.0"

  pve_instance_name        = "master${count.index}-${local.name_stub}"
  pve_instance_description = "${local.master_description} (UUID: ${local.master_placement[count.index].uuid})"
  vmid                     = lookup(local.master_placement[count.index], "vmid")

  target_node   = lookup(local.master_placement[count.index], "host")
  resource_pool = var.resource_pool

  hastate = local.hastate
  hagroup = lookup(local.master_placement[count.index], "hagroup")

  pxe_boot = var.pxe_boot

  # custom CPU profile
  cpu     = var.cpu
  cores   = var.resource_cpu_cores
  sockets = var.resource_cpu_sockets
  memory  = var.resource_memory
  boot    = var.boot

  oncreate = local.oncreate

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

resource "null_resource" "set_master_smbios_values" {
  count      = local.master_count
  depends_on = [module.master_instances]

  provisioner "local-exec" {
    command = "/usr/bin/env bash scripts/set_smbios_values.sh ${replace(local.pve_token_id, "!", "'!'")} ${local.pve_token} ${local.master_placement[count.index].host} ${local.master_placement[count.index].vmid} ${local.master_sku} ${local.master_placement[count.index].uuid}"
  }

  lifecycle {
    ignore_changes = all
  }
}

resource "macaddress" "worker_net0_mac" {
  count = local.worker_count
}

module "worker_instances" {
  count      = local.worker_count
  depends_on = [local_file.set_smbios_values]

  source = "github.com/glitchcrab/terraform-module-proxmox-instance?ref=v1.8.0"

  pve_instance_name        = "worker${count.index}-${local.name_stub}"
  pve_instance_description = "${local.worker_description} (UUID: ${local.worker_placement[count.index].uuid})"
  vmid                     = lookup(local.worker_placement[count.index], "vmid")

  target_node   = lookup(local.worker_placement[count.index], "host")
  resource_pool = var.resource_pool

  hastate = local.hastate
  hagroup = lookup(local.worker_placement[count.index], "hagroup")

  pxe_boot = var.pxe_boot

  # custom CPU profile
  cpu     = var.cpu
  cores   = var.resource_cpu_cores
  sockets = var.resource_cpu_sockets
  memory  = var.resource_memory
  boot    = var.boot

  oncreate = local.oncreate

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

resource "null_resource" "set_worker_smbios_values" {
  count      = local.worker_count
  depends_on = [module.worker_instances]

  provisioner "local-exec" {
    command = "/usr/bin/env bash scripts/set_smbios_values.sh ${replace(local.pve_token_id, "!", "'!'")} ${local.pve_token} ${local.worker_placement[count.index].host} ${local.worker_placement[count.index].vmid} ${local.worker_sku} ${local.worker_placement[count.index].uuid}"
  }

  lifecycle {
    ignore_changes = all
  }
}

