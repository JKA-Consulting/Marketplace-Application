resource "google_compute_network" "marketplace-vpc" {
  name                    = "marketplace-vpc"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "marketplace-subnet1" {
  name          = "subnet-1"
  region        = var.subnet-region
  network       = google_compute_network.marketplace-vpc.id
  ip_cidr_range = var.subnet-cidr # Replace with your desired IP range
}
