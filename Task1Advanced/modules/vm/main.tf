###############################################################################
# Reusable VM module — resource definition
#
# Defines a single Yandex Cloud compute instance driven entirely by input
# variables. No environment-specific literals live here.
###############################################################################

data "yandex_compute_image" "os_image" {
  family = var.image_family
}

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
      image_id = data.yandex_compute_image.os_image.id
      size     = 20
      type     = "network-hdd"
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
