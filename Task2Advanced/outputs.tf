###############################################################################
# Root config — outputs (re-exported from the shared VM module)
###############################################################################

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
