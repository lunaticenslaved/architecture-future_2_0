###############################################################################
# Reusable VM module — input variables
#
# This module is intentionally environment-agnostic: it contains NO hardcoded
# environment values. Every environment-specific setting is exposed as a
# variable so the same module can be reused across dev / stage / prod.
###############################################################################

variable "folder_id" {
  type        = string
  description = "Yandex Cloud folder ID where the instance will be created."

  validation {
    condition     = length(var.folder_id) > 0
    error_message = "folder_id must not be empty."
  }
}

variable "name" {
  type        = string
  description = "Name of the compute instance (VM)."

  validation {
    condition     = length(var.name) > 0
    error_message = "The VM name must not be empty."
  }
}

variable "zone" {
  type        = string
  description = "Availability zone where the instance will be created (e.g. ru-central1-a)."

  validation {
    condition     = length(var.zone) > 0
    error_message = "The zone must not be empty."
  }
}

variable "cores" {
  type        = number
  description = "Number of vCPU cores allocated to the instance."

  validation {
    condition     = var.cores > 0
    error_message = "cores must be greater than 0."
  }
}

variable "memory" {
  type        = number
  description = "Amount of RAM in GB allocated to the instance."

  validation {
    condition     = var.memory > 0
    error_message = "memory (GB) must be greater than 0."
  }
}

variable "image_family" {
  type        = string
  description = "Family of the OS image used to initialize the boot disk (e.g. ubuntu-2204-lts). The latest image in the family is resolved automatically."

  validation {
    condition     = length(var.image_family) > 0
    error_message = "image_family must not be empty."
  }
}

variable "subnet_id" {
  type        = string
  description = "ID of the subnet the instance's network interface attaches to."

  validation {
    condition     = length(var.subnet_id) > 0
    error_message = "subnet_id must not be empty."
  }
}

variable "ssh_public_key" {
  type        = string
  description = "SSH public key contents injected via instance metadata (ssh-keys)."

  validation {
    condition     = length(var.ssh_public_key) > 0
    error_message = "ssh_public_key must not be empty."
  }
}

variable "ssh_user" {
  type        = string
  description = "Login user associated with the SSH public key in metadata."
  default     = "ubuntu"
}

variable "platform_id" {
  type        = string
  description = "Compute platform to use for the instance."
  default     = "standard-v3"
}

variable "core_fraction" {
  type        = number
  description = "Baseline guaranteed vCPU performance as a percentage (e.g. 20, 50, 100)."
  default     = 100

  validation {
    condition     = var.core_fraction > 0 && var.core_fraction <= 100
    error_message = "core_fraction must be between 1 and 100."
  }
}

variable "preemptible" {
  type        = bool
  description = "Whether the instance is preemptible (can be stopped by the platform)."
  default     = false
}

variable "nat" {
  type        = bool
  description = "Whether to assign an ephemeral public IP (NAT) to the instance."
  default     = false
}

variable "labels" {
  type        = map(string)
  description = "Labels (key/value) attached to the instance."
  default     = {}
}
