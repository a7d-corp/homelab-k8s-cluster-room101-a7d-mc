terraform {
  backend "s3" {
    bucket                      = "homelab-k8s-cluster-room101-a7d-mc"
    force_path_style            = true
    key                         = "cluster.tfstate"
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    skip_region_validation      = true
  }
}
