resource "macaddress" "master_net0_mac" {
  count = local.master_count
}

resource "random_string" "master_serial" {
  count = local.master_count

  length  = 16
  special = false
  upper   = false
}

resource "random_uuid" "master_uuid" {
  count = local.master_count
}

resource "null_resource" "master_smbios1_values" {
  count      = local.master_count
  depends_on = [module.master_instances]

  provisioner "local-exec" {
    command = <<EOF
      curl --silent --insecure -H \
         "Authorization: PVEAPIToken=${local.pve_token_id}=${local.pve_token}" \
         -X POST --data-urlencode \
         smbios1="serial=${random_string.master_serial[count.index].result},family=${local.family},sku=${local.master_sku},uuid=${random_uuid.master_uuid[count.index].result}" \
         ${local.pm_api_url}/nodes/${local.master_placement[count.index].host}/qemu/${local.master_placement[count.index].vmid}/config
    EOF
  }
}

resource "null_resource" "master_stop" {
  count      = local.master_count
  depends_on = [null_resource.master_smbios1_values]

  provisioner "local-exec" {
    command = <<EOF
      curl --silent --insecure -H \
         "Authorization: PVEAPIToken=${local.pve_token_id}=${local.pve_token}" \
         -X POST \
         ${local.pm_api_url}/nodes/${local.master_placement[count.index].host}/qemu/${local.master_placement[count.index].vmid}/status/stop
    EOF
  }
}

resource "time_sleep" "master_sleep_10s" {
  count      = local.master_count
  depends_on = [null_resource.master_stop]

  create_duration = "10s"
}

resource "null_resource" "master_start" {
  count      = local.master_count
  depends_on = [time_sleep.master_sleep_10s]

  provisioner "local-exec" {
    command = <<EOF
      curl --silent --insecure -H \
         "Authorization: PVEAPIToken=${local.pve_token_id}=${local.pve_token}" \
         -X POST \
         ${local.pm_api_url}/nodes/${local.master_placement[count.index].host}/qemu/${local.master_placement[count.index].vmid}/status/start
    EOF
  }
}

module "master_instances" {
  count = local.master_count

  source = "github.com/glitchcrab/terraform-module-proxmox-instance?ref=v1.8.0"

  pve_instance_name        = "master${count.index}-${local.name_stub}"
  pve_instance_description = "${local.master_description} (serial: ${random_string.master_serial[count.index].result})"
  vmid                     = lookup(local.master_placement[count.index], "vmid")

  target_node   = lookup(local.master_placement[count.index], "host")
  resource_pool = var.resource_pool

  hastate = local.hastate
  hagroup = lookup(local.master_placement[count.index], "hagroup")

  pxe_boot = var.pxe_boot

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

resource "macaddress" "worker_net0_mac" {
  count = local.worker_count
}

resource "random_string" "worker_serial" {
  count = local.worker_count

  length  = 16
  special = false
  upper   = false
}

resource "random_uuid" "worker_uuid" {
  count = local.worker_count
}

resource "null_resource" "worker_smbios1_values" {
  count      = local.worker_count
  depends_on = [module.worker_instances]

  provisioner "local-exec" {
    command = <<EOF
      curl --silent --insecure -H \
         "Authorization: PVEAPIToken=${local.pve_token_id}=${local.pve_token}" \
         -X POST --data-urlencode \
         smbios1="serial=${random_string.worker_serial[count.index].result},family=${local.family},sku=${local.worker_sku},uuid=${random_uuid.worker_uuid[count.index]}" \
         ${local.pm_api_url}/nodes/${local.worker_placement[count.index].host}/qemu/${local.worker_placement[count.index].vmid}/config
    EOF
  }
}

resource "null_resource" "worker_stop" {
  count      = local.worker_count
  depends_on = [null_resource.worker_smbios1_values]

  provisioner "local-exec" {
    command = <<EOF
      curl --silent --insecure -H \
         "Authorization: PVEAPIToken=${local.pve_token_id}=${local.pve_token}" \
         -X POST \
         ${local.pm_api_url}/nodes/${local.worker_placement[count.index].host}/qemu/${local.worker_placement[count.index].vmid}/status/stop
    EOF
  }
}

resource "time_sleep" "worker_sleep_10s" {
  count      = local.master_count
  depends_on = [null_resource.master_stop]

  create_duration = "10s"
}

resource "null_resource" "worker_start" {
  count      = local.worker_count
  depends_on = [time_sleep.worker_sleep_10s]

  provisioner "local-exec" {
    command = <<EOF
      curl --silent --insecure -H \
         "Authorization: PVEAPIToken=${local.pve_token_id}=${local.pve_token}" \
         -X POST \
         ${local.pm_api_url}/nodes/${local.worker_placement[count.index].host}/qemu/${local.worker_placement[count.index].vmid}/status/start
    EOF
  }
}

module "worker_instances" {
  count = local.worker_count

  source = "github.com/glitchcrab/terraform-module-proxmox-instance?ref=v1.8.0"

  pve_instance_name        = "worker${count.index}-${local.name_stub}"
  pve_instance_description = "${local.worker_description} (serial: ${random_string.worker_serial[count.index].result})"
  vmid                     = lookup(local.worker_placement[count.index], "vmid")

  target_node   = lookup(local.worker_placement[count.index], "host")
  resource_pool = var.resource_pool

  hastate = local.hastate
  hagroup = lookup(local.worker_placement[count.index], "hagroup")

  pxe_boot = var.pxe_boot

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
