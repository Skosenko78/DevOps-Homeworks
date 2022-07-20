provider "yandex" {
  cloud_id  = "b1gl404splab9eas7u6l"
  folder_id = "b1g8t7bb3jnhfrkoa6uk"
  zone      = "ru-central1-a"
}

resource "yandex_compute_image" "test-image" {
  name       = "ubuntu-public-image"
  family     = "ubuntu-2004-lts"
}

resource "yandex_compute_instance" "test" {
  name        = "test"
  platform_id = "standard-v1"

  resources {
    cores  = 2
    memory = 4
  }

  boot_disk {
    initialize_params {
      image_id = "${yandex_compute_image.test-image.id}"
    }
  }

  network_interface {
    subnet_id = "${yandex_vpc_subnet.subnet.id}"
  }
}

resource "yandex_vpc_network" "net" {}

resource "yandex_vpc_subnet" "subnet" {
  zone       = "ru-central1-a"
  network_id = "${yandex_vpc_network.net.id}"
  v4_cidr_blocks = ["192.168.1.0/24"]
}