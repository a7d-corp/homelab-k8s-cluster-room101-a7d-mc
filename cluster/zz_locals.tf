locals {
  dns_servers                = ["10.101.0.60", "10.101.0.55"]
  master_count               = 1
  name_stub                  = "room101-a7d-mc"
  primary_ip_gateway         = "172.25.0.1"
  primary_ip_offset_master   = 163
  primary_ip_offset_worker   = local.primary_ip_offset_master + 3
  secondary_ip_offset_master = 1
  secondary_ip_offset_worker = 4
  snippet_root_dir           = "/mnt/pve/cloudinit"
  snippet_dir                = "snippets"
  vmid_base                  = 330
  vmid_offset_master         = 3
  vmid_offset_worker         = 6
  worker_count               = 2

  host_list = ["host-01", "host-02", "host-03"]

  pm_host_address = data.vault_generic_secret.terraform_generic.data["host"]
}
