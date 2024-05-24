resource "google_compute_instance" "minikube-instance" {
  name         = "minikube-instance"
  machine_type = "n1-standard-8" 
  zone         = var.subnet-zone

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2004-lts"
      size  = 20 # Boot disk size in GB
    }
  }

  network_interface {
    network    = google_compute_network.minikube-network.name
    subnetwork = google_compute_subnetwork.minikube-subnet.name

  }



  metadata_startup_script = <<-EOT
#!/bin/bash

#!/bin/bash

# Log file path
LOG_FILE="$HOME/minikube-startup.log"
# Reference file to check if Minikube has been installed
REFERENCE_FILE="$HOME/.minikube_installed"

# Function to check if a command exists
command_exists() {
    command -v "$1" &>/dev/null
}

# Redirect stdout and stderr to the log file
exec > >(tee -a ${LOG_FILE}) 2>&1

echo "Starting startup script at $(date)"

# Check if Docker is installed
if ! command_exists docker; then
    echo "Docker is not installed. Installing Docker..."
    sudo apt-get update
    sudo apt-get install -y docker.io
    sudo systemctl enable docker
    sudo systemctl start docker
    sudo usermod -aG docker $(whoami)
    echo "Docker installation completed."
    
    # Re-execute the script with the new group
    exec sg docker "$0"
fi

# Check if Minikube has been installed before using the reference file
if [ ! -f "$REFERENCE_FILE" ]; then
    echo "Minikube is not installed. Installing Minikube..."
    curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
    sudo install minikube-linux-amd64 /usr/local/bin/minikube
    rm minikube-linux-amd64
    echo "Minikube installation completed."

    # Create the reference file to indicate Minikube has been installed
    touch "$REFERENCE_FILE"
else
    echo "Minikube is already installed. Skipping installation."
fi

# Start Minikube with Docker driver
echo "Starting Minikube..."
minikube start --driver=docker

echo "Startup script completed at $(date)"


EOT
}

resource "google_compute_firewall" "allow-ssh-rdp-icmp" {
  name    = "allow-ssh-rdp-icmp"
  network = google_compute_network.minikube-network.name

  allow {
    protocol = "tcp"
    ports    = ["22", "3389", "80", "8080"] #allowing ssh, rdp and http
  }

  allow {
    protocol = "icmp" #allowing pings
  }

  source_ranges = ["0.0.0.0/0"] #allowing incoming traffic from the specified network address, in this case all addresses are allowed
}
