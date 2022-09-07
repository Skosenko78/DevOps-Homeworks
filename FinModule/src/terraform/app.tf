resource "yandex_compute_instance" "app" {
  name = "app"
  hostname = "app.${var.domain_name}"
  platform_id = local.comp_instance_type_map[terraform.workspace]
  zone = "ru-central1-a"

  resources {
    core_fraction = 20
    cores  = 4
    memory = 4
  }

  scheduling_policy {
    preemptible = true
  }

  boot_disk {
    initialize_params {
      image_id = "${var.ubuntu_srv_instance}"
      type = "network-nvme"
      size = 20
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet_front.id
    nat = false
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }
}