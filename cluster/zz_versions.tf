terraform {
  required_version = ">= 1.0"

  required_providers {
    macaddress = {
      source  = "ivoronin/macaddress"
      version = "~> 0.3.0"
    }
    null = {
      source  = "hashicorp/null"
      version = "~> 3.2.1"
    }
    proxmox = {
      source  = "Telmate/proxmox"
      version = "~> 2.9.14"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.4.3"
    }
    time = {
      source  = "hashicorp/time"
      version = "0.9.1"
    }
    vault = {
      source  = "hashicorp/vault"
      version = "~> 3.11.0"
    }
  }
}
