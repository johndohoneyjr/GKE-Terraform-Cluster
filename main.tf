terraform {
  required_version = ">= 0.11.0"
}

provider "google" {
 credentials = "${var.gcp_credentials}"
 project     = "${var.gcp_project}"
 region      = "${var.gcp_region}"
}

data "google_container_engine_versions" "west" {
  location = "${var.gcp_zone}"
}

resource "google_container_cluster" "k8sexample" {
  name               = "${var.cluster_name}"
  description        = "example k8s cluster"
  location               = "${var.gcp_zone}"
  initial_node_count = "${var.initial_node_count}"
  enable_kubernetes_alpha = "true"
  enable_legacy_abac = "true"

  master_auth {
    username = "${var.master_username}"
    password = "${var.master_password}"
  }

  node_config {
    machine_type = "${var.node_machine_type}"
    disk_size_gb = "${var.node_disk_size}"
    oauth_scopes = [
      "https://www.googleapis.com/auth/compute",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring"
    ]
  }
}

