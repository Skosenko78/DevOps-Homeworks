resource "yandex_compute_instance" "nginx" {
  name = "nginx"
  hostname = "${var.domain_name}"
  platform_id = local.comp_instance_type_map[terraform.workspace]
  zone = "ru-central1-a"

  resources {
    core_fraction = 20
    cores  = 2
    memory = 2
  }

  scheduling_policy {
    preemptible = true
  }

  boot_disk {
    initialize_params {
      image_id = "${var.ubuntu_nat_instance}"
      type = "network-nvme"
      size = 20
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet_front.id
    nat = true
    ip_address = local.default_gw[terraform.workspace]
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }
}