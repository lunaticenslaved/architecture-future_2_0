###############################################################################
# stage environment — input variables
#
# Values are supplied via terraform.tfvars. Secrets/IDs are kept as variables,
# never as literals in code.
###############################################################################

# ---- Provider / authentication ------------------------------------------------

variable "yc_token" {
  type        = string
  description = "Yandex Cloud OAuth/IAM token (leave null when using a service account key file)."
  default     = null
  sensitive   = true
}

variable "yc_service_account_key_file" {
  type        = string
  description = "Path to a Yandex Cloud service account key JSON file (leave null when using a token)."
  default     = null
}

variable "cloud_id" {
  type        = string
  description = "Yandex Cloud cloud ID."
}

variable "folder_id" {
  type        = string
  description = "Yandex Cloud folder ID."
}

variable "zone" {
  type        = string
  description = "Availability zone (e.g. ru-central1-a)."
}

# ---- Networking ---------------------------------------------------------------

variable "subnet_id" {
  type        = string
  description = "Subnet ID the VM network interface attaches to."
}

# ---- SSH ----------------------------------------------------------------------

variable "ssh_public_key" {
  type        = string
  description = "SSH public key contents injected into the VM."
}

variable "ssh_user" {
  type        = string
  description = "Login user associated with the SSH key."
  default     = "ubuntu"
}

# ---- VM sizing / image --------------------------------------------------------

variable "vm_name" {
  type        = string
  description = "Name of the VM instance."
}

variable "image_id" {
  type        = string
  description = "OS image ID for the boot disk."
}

variable "cores" {
  type        = number
  description = "Number of vCPU cores."
}

variable "memory" {
  type        = number
  description = "RAM in GB."
}

variable "core_fraction" {
  type        = number
  description = "Guaranteed vCPU performance percentage."
  default     = 100
}

variable "disk_size" {
  type        = number
  description = "Boot disk size in GB."
}

variable "disk_type" {
  type        = string
  description = "Boot disk type (network-hdd / network-ssd)."
  default     = "network-hdd"
}

variable "platform_id" {
  type        = string
  description = "Compute platform ID."
  default     = "standard-v3"
}

variable "preemptible" {
  type        = bool
  description = "Whether the VM is preemptible."
  default     = false
}

variable "nat" {
  type        = bool
  description = "Whether to assign a public NAT IP."
  default     = false
}

variable "labels" {
  type        = map(string)
  description = "Labels applied to the VM."
  default     = {}
}
