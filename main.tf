resource "google_compute_instance" "minikube-instance" {
  name         = "minikube-instance"
  machine_type = "e2-medium"
  zone         = var.subnet-zone

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2004-lts"
      size  = 20 # Boot disk size in GB
    }
  }

  network_interface {
    network    = google_compute_network.marketplace-vpc.name
    subnetwork = google_compute_subnetwork.marketplace-subnet1.name

  }



  metadata_startup_script = <<-EOT
           #!/bin/bash

LOG_FILE="/var/log/minikube-install.log"

# Function to log messages
log() {
    echo "$(date +'%Y-%m-%d %H:%M:%S') - $1" | tee -a "$LOG_FILE"
}

# Check if Minikube is already installed
if command -v minikube &> /dev/null; then
    log "Minikube is already installed. Exiting script."
    exit 0
else
    log "Minikube not found. Proceeding with installation."
fi

# Update and install prerequisites
log "Updating package list and installing prerequisites..."
sudo apt-get update -y | tee -a "$LOG_FILE"
sudo apt-get install -y curl apt-transport-https virtualbox virtualbox-ext-pack | tee -a "$LOG_FILE"

# Download and install Minikube
log "Downloading and installing Minikube..."
curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 | tee -a "$LOG_FILE"
sudo install minikube /usr/local/bin/ | tee -a "$LOG_FILE"

# Download and install kubectl
log "Downloading and installing kubectl..."
curl -LO "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl" | tee -a "$LOG_FILE"
chmod +x kubectl | tee -a "$LOG_FILE"
sudo mv kubectl /usr/local/bin/ | tee -a "$LOG_FILE"

# Clean up
log "Cleaning up..."
rm -f minikube | tee -a "$LOG_FILE"

# Verify installation
log "Verifying Minikube installation..."
if minikube version &> /dev/null; then
    log "Minikube installed successfully."
else
    log "Minikube installation failed."
    exit 1
fi

log "Startup script completed."

        EOT
}

resource "google_compute_firewall" "allow-ssh-rdp-icmp" {
  name    = "allow-ssh-rdp-icmp"
  network = google_compute_network.marketplace-vpc.name

  allow {
    protocol = "tcp"
    ports    = ["22", "3389", "80", "8080"] #allowing ssh, rdp and http
  }

  allow {
    protocol = "icmp" #allowing pings
  }

  source_ranges = ["0.0.0.0/0"] #allowing incoming traffic from the specified network address, in this case all addresses are allowed
}
