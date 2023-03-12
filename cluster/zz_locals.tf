locals {
  # general config
  name_stub   = "room101-a7d-mc"
  vmid_base   = 400
  vmid_offset = 10

  # master config
  master_count       = 3
  master_description = "room101-a7d MC master"

  # worker config
  worker_count       = 0
  worker_description = "room101-a7d MC worker"

  # instance placement
  hastate = "enabled"
  host_list = [
    {
      name    = "host-01"
      hagroup = "ha-group-1"
    },
    {
      name    = "host-02"
      hagroup = "ha-group-2"
    },
    {
      name    = "host-03"
      hagroup = "ha-group-3"
    }
  ]

  # proxmox config
  pm_host_address = data.vault_generic_secret.terraform_generic.data["host"]
}
