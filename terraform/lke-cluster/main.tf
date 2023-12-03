terraform {
  required_providers {
    linode = {
      source = "linode/linode"
      version = "2.7.1"
    }
  }
}
//Use the Linode Provider
provider "linode" {
  token = var.token
}

//Use the linode_lke_cluster resource to create
//a Kubernetes cluster
resource "linode_lke_cluster" "lke" {
  k8s_version = var.k8s_version
  label = var.label
  region = var.region
  tags = var.tags

  dynamic "pool" {
    for_each = var.pools
    content {
      type  = pool.value["type"]
      count = pool.value["count"]
    }
  }
}

//Export this cluster's attributes
output "kubeconfig" {
  value = linode_lke_cluster.lke.kubeconfig
  sensitive = true
}

output "api_endpoints" {
  value = linode_lke_cluster.lke.api_endpoints
}

output "status" {
  value = linode_lke_cluster.lke.status
}

output "id" {
  value = linode_lke_cluster.lke.id
}

output "pool" {
  value = linode_lke_cluster.lke.pool
}

resource "null_resource" "lke_config" {
  depends_on = [
    linode_lke_cluster.lke
  ]

  provisioner "local-exec" {
    command = "/bin/bash scripts/export-config.sh"
  }
}