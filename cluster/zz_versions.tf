terraform {
  required_version = ">= 1.0"

  required_providers {
    macaddress = {
      source  = "ivoronin/macaddress"
      version = "~> 0.3.0"
    }
    proxmox = {
      source  = "Telmate/proxmox"
      version = "2.9.10"
    }
    vault = {
      source  = "hashicorp/vault"
      version = "~> 3.11.0"
    }
  }
}
