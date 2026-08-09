###############################################################################
# Reusable VM module — resource definition
#
# Defines a single Yandex Cloud compute instance driven entirely by input
# variables. No environment-specific literals live here.
###############################################################################

resource "yandex_compute_instance" "this" {
  name        = var.name
  zone        = var.zone
  platform_id = var.platform_id
  labels      = var.labels

  resources {
    cores         = var.cores
    memory        = var.memory
    core_fraction = var.core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = var.image_id
      size     = var.disk_size
      type     = var.disk_type
    }
  }

  network_interface {
    subnet_id = var.subnet_id
    nat       = var.nat
  }

  scheduling_policy {
    preemptible = var.preemptible
  }

  metadata = {
    ssh-keys = "${var.ssh_user}:${var.ssh_public_key}"
  }
}
