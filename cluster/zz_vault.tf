data "vault_generic_secret" "terraform_pve_auth" {
  path = "proxmox/terraform-pve-auth"
}

data "vault_generic_secret" "terraform_generic" {
  path = "proxmox/terraform-pve-config"
}
