variable "region" {
  description = "default project region"
}

variable "project-id" {
  description = "project id"
}

variable "subnet-cidr" {
  description = "project cidr block"
}

variable "subnet-region" {
  description = "subnet region of the vpc"
}

variable "subnet-zone" {
  description = "subnet zone of the vpc"
}

variable "gcp_service_list" {
  type        = list(string)
  description = "the list of APIs to be enabled for this project"
  default     = []
}