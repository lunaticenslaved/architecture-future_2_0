###############################################################################
# dev environment — concrete values
#
# NOTE: The IDs and SSH key below are PLACEHOLDERS. Replace every *REPLACE_ME*
# value with your real Yandex Cloud IDs / keys before running terraform apply.
###############################################################################

# ---- Provider / auth ----------------------------------------------------------
# Provide auth via CLI/env instead of committing secrets, e.g.:
#   export TF_VAR_yc_token="$(yc iam create-token)"
# or set yc_service_account_key_file to a key JSON path.
cloud_id  = "b1gkf3k5e26c3hdu9kn3"
folder_id = "b1gss7mrahaff07vko61"
zone      = "ru-central1-a"

# ---- Networking ---------------------------------------------------------------
subnet_id = "e9bcpe73l5kobvk1d0gh"

# ---- SSH ----------------------------------------------------------------------
ssh_user       = "ubuntu"
ssh_public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIR_PUBLIC_KEY user@example"

# ---- VM sizing / image (dev: small, cheap, preemptible) -----------------------
vm_name       = "app-dev"
image_family  = "ubuntu-2204-lts"
cores         = 2
memory        = 2
core_fraction = 20
preemptible   = true
nat           = true

labels = {
  env   = "dev"
  team  = "platform"
}
