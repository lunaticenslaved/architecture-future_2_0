###############################################################################
# Concrete values (PLACEHOLDERS)
#
# Replace every *REPLACE_ME* value with your real Yandex Cloud IDs / keys
# before running terraform apply. In CI these are supplied as TF_VAR_* env
# vars from CI secrets instead of committing them here.
#
# NOTE: This file configures the Terraform RESOURCES only. The remote backend
# (bucket/key/region/endpoint + AWS_ACCESS_KEY_ID / AWS_SECRET_ACCESS_KEY) is
# configured separately via backend.hcl + env vars at `terraform init` time.
###############################################################################

# ---- Provider / auth ----------------------------------------------------------
# Provide auth via env instead of committing secrets, e.g.:
#   export TF_VAR_yc_token="$(yc iam create-token)"
# or set yc_service_account_key_file to a key JSON path.
cloud_id  = "b1gxxxxxxxxxxxREPLACE_ME"
folder_id = "b1gyyyyyyyyyyyREPLACE_ME"
zone      = "ru-central1-a"

# ---- Networking ---------------------------------------------------------------
subnet_id = "e9bxxxxxxxxxxxREPLACE_ME"

# ---- SSH ----------------------------------------------------------------------
ssh_user       = "ubuntu"
ssh_public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIREPLACE_ME_PUBLIC_KEY user@example"

# ---- VM sizing / image --------------------------------------------------------
vm_name       = "app-cicd"
image_id      = "fd8xxxxxxxxxxxREPLACE_ME" # e.g. Ubuntu 22.04 LTS image id
cores         = 2
memory        = 2
core_fraction = 20
disk_size     = 20
disk_type     = "network-hdd"
preemptible   = true
nat           = true

labels = {
  env     = "cicd"
  team    = "platform"
  owner   = "REPLACE_ME"
  managed = "terraform"
}
