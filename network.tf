resource "google_compute_network" "minikube-network" {
  name                    = "minikube-network"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "minikube-subnet" {
  name          = "minikube-subnet"
  region        = var.subnet-region
  network       = google_compute_network.minikube-network.id
  ip_cidr_range = var.subnet-cidr # Replace with your desired IP range
}
