terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "5.20.0"
    }
  }
  backend "gcs" {

  }
}

provider "google" {
  project = var.project-id
  region  = var.region
}
