###############################################################################
# stage environment — module invocation
#
# Reuses the shared VM module. The ONLY difference between environments is the
# set of values passed in via terraform.tfvars.
###############################################################################

module "vm" {
  source = "../../modules/vm"

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

# ---- Re-export module outputs -------------------------------------------------

output "instance_id" {
  description = "ID of the created VM."
  value       = module.vm.instance_id
}

output "name" {
  description = "Name of the created VM."
  value       = module.vm.name
}

output "internal_ip_address" {
  description = "Internal IP of the VM."
  value       = module.vm.internal_ip_address
}

output "external_ip_address" {
  description = "External (NAT) IP of the VM, if enabled."
  value       = module.vm.external_ip_address
}

output "boot_disk_id" {
  description = "Boot disk ID of the VM."
  value       = module.vm.boot_disk_id
}

output "zone" {
  description = "Zone of the VM."
  value       = module.vm.zone
}

output "fqdn" {
  description = "FQDN of the VM."
  value       = module.vm.fqdn
}
