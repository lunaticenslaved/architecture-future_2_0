###############################################################################
# Root config — module invocation
#
# Reuses the SHARED VM module authored in Task 1 (referenced directly via a
# relative path — the module is intentionally NOT duplicated). All values are
# passed in via variables (terraform.tfvars / TF_VAR_* env vars from CI).
###############################################################################

module "vm" {
  source = "../Task1Advanced/modules/vm"

  name = var.vm_name
  zone = var.zone

  cores         = var.cores
  memory        = var.memory
  core_fraction = var.core_fraction

  image_family = var.image_family

  subnet_id = var.subnet_id
  nat       = var.nat

  ssh_user       = var.ssh_user
  ssh_public_key = var.ssh_public_key

  platform_id = var.platform_id
  preemptible = var.preemptible
  labels      = var.labels
}
