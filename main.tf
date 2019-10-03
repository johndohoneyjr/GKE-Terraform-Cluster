terraform {
  required_version = ">= 0.11.0"
}

provider "google" {
 credentials = "${var.gcp_credentials}"
 project     = "${var.gcp_project}"
 region      = "${var.gcp_region}"
}

resource "google_compute_network" "my-net" {
  name = "vpc-network"
}

resource "google_compute_firewall" "my-firewall" {
  name    = "ops-manager-fw"
  network = "${google_compute_network.my-net.name}"

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["8443", "8080", "8090", "27017", "587", "4949"]
  }

  source_tags = ["opsManager"]
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

