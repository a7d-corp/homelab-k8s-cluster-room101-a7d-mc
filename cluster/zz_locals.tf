locals {
  master_count       = 3
  name_stub          = "room101-a7d-mc"
  vmid_base          = 400
  vmid_offset_master = 10
  worker_count       = 3

  host_list = ["host-01", "host-02", "host-03"]

  pm_host_address = data.vault_generic_secret.terraform_generic.data["host"]
}
