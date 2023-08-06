locals {
  uuid = "85bcea56-4ebb-4ffc-8177-22ef3d66e6eb"
  # general config
  hastate   = "enabled"
  name_stub = "room101-a7d-mc"
  oncreate  = false

  # master config
  master_count       = 0
  master_description = "room101-a7d MC master"
  master_placement = [
    {
      hagroup = "ha-group-1"
      host    = "host-01"
      vmid    = 410
      uuid    = "7eb6cf89-d07f-40a5-bfb0-c3003045e013"
    },
    {
      hagroup = "ha-group-2"
      host    = "host-02"
      vmid    = 411
      uuid    = "203e63cb-a8aa-4bf8-a5b6-333090507777"
    },
    {
      hagroup = "ha-group-3"
      host    = "host-03"
      vmid    = 412
      uuid    = "2d1e5620-fdbc-4487-8f43-98cc9f36c308"
    }
  ]

  # smbios1 values
  family     = replace(local.name_stub, "-", "")
  master_sku = "master"
  worker_sku = "worker"

  # worker config
  worker_count       = 0
  worker_description = "room101-a7d MC worker"
  worker_placement = [
    {
      hagroup = "ha-group-1"
      host    = "host-01"
      vmid    = 415
      uuid    = "fc25565c-e70d-4e6f-9e60-bf966ea330f3"
    },
    {
      hagroup = "ha-group-2"
      host    = "host-02"
      vmid    = 416
      uuid    = "6904e125-fc6c-4614-a16f-bef7474373f4"
    },
    {
      hagroup = "ha-group-3"
      host    = "host-03"
      vmid    = 417
      uuid    = "498eeb6c-76dd-4fb1-9bc4-bb940e8803ff"
    }
  ]

  # proxmox config
  pm_host_address = data.vault_generic_secret.terraform_generic.data["host"]
  pm_api_url      = "${var.pm_host_scheme}://${local.pm_host_address}:${var.pm_host_port}${var.pm_host_path}"

  # api token used for setting instance smbios1 balues
  pve_token_id = data.vault_generic_secret.terraform_pve_token.data["tokenid"]
  pve_token    = data.vault_generic_secret.terraform_pve_token.data["token"]
}
