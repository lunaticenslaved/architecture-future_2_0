###############################################################################
# Reusable VM module — outputs
###############################################################################

output "instance_id" {
  description = "The unique ID of the compute instance."
  value       = yandex_compute_instance.this.id
}

output "name" {
  description = "The name of the compute instance."
  value       = yandex_compute_instance.this.name
}

output "internal_ip_address" {
  description = "Private (internal) IPv4 address of the primary network interface."
  value       = yandex_compute_instance.this.network_interface.0.ip_address
}

output "external_ip_address" {
  description = "Public (NAT) IPv4 address of the primary network interface, if NAT is enabled (empty otherwise)."
  value       = yandex_compute_instance.this.network_interface.0.nat_ip_address
}

output "boot_disk_id" {
  description = "The ID of the instance's boot disk."
  value       = yandex_compute_instance.this.boot_disk.0.disk_id
}

output "zone" {
  description = "Availability zone in which the instance was created."
  value       = yandex_compute_instance.this.zone
}

output "fqdn" {
  description = "Fully qualified domain name assigned to the instance."
  value       = yandex_compute_instance.this.fqdn
}
