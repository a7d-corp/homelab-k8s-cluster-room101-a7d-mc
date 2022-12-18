# proxmox provider connection config

variable "pm_host_scheme" {
  type        = string
  default     = "https"
  description = "Connection scheme for the Proxmox API."
}

variable "pm_host_port" {
  type        = number
  default     = 8006
  description = "Port for the Proxmox API."
}

variable "pm_host_path" {
  type        = string
  default     = "/api2/json"
  description = "Subpath for the Proxmox API."
}

variable "pm_tls_insecure" {
  type        = bool
  default     = false
  description = "Set to `true` if the Proxmox API is secured with a self-signed TLS certificate."
}

# network configuration

variable "network_model" {
  type        = string
  default     = "virtio"
  description = "Emulated NIC model."
}

variable "net0_network_bridge" {
  type        = string
  description = "Host bridge to attach the interface to."
}

variable "net0_vlan_tag" {
  type        = number
  description = ""
}

# master configuration

variable "master_disk_type" {
  type        = string
  description = "Master disk connectivity mode."
}

variable "master_disk_storage" {
  type        = string
  description = "Master disk storage location"
}

variable "master_disk_size" {
  type        = string
  description = "Master disk capacity."
}

# worker configuration

variable "worker_disk_type" {
  type        = string
  description = "Worker disk connectivity mode."
}

variable "worker_disk_storage" {
  type        = string
  description = "Worker disk storage location"
}

variable "worker_disk_size" {
  type        = string
  description = "Worker disk capacity."
}

# instance configuration

variable "instance_domain" {
  type        = string
  description = ""
}

variable "resource_pool" {
  type        = string
  description = "Pool to create resources in."
}

variable "resource_cpu_cores" {
  type        = number
  default     = 1
  description = ""
}

variable "resource_cpu_sockets" {
  type        = number
  default     = 2
  description = ""
}

variable "resource_memory" {
  type        = number
  default     = 1024
  description = ""
}

variable "boot" {
  type        = string
  default     = "order=net0,scsi0"
  description = "Boot device order."
}

variable "nameserver" {
  type        = string
  description = ""
}
