locals {
  hastate            = "enabled"
  master_count       = 1
  master_description = "kubernetes management cluster master"
  name_stub          = "room101-a7d-mc"
  vmid_base          = 400
  vmid_offset_master = 10
  worker_count       = 0
  worker_description = "kubernetes managment cluster worker"

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

  pm_host_address = data.vault_generic_secret.terraform_generic.data["host"]
}
