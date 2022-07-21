provider "yandex" {
  service_account_key_file = "key.json"
  cloud_id  = "b1gl404splab9eas7u6l"
  folder_id = "b1g8t7bb3jnhfrkoa6uk"
  zone      = "ru-central1-a"
}

resource "yandex_compute_image" "test-image" {
  name       = "ubuntu-public-image"
  source_image = "fd8fte6bebi857ortlja"
}

locals {
  comp_instance_type_map = {
    stage = "standard-v1"
    prod = "standard-v2"
  }

  instance_count_map = {
    stage = 0
    prod = 2
  }

  hosts = {
    stage = toset(["nodes-1"])
    prod = toset(["nodep-1", "nodep-2"])
  }
}

resource "yandex_compute_instance" "nodes_count" {
  platform_id = local.comp_instance_type_map[terraform.workspace]
  name        = "${terraform.workspace}-node-${count.index}"
  count = local.instance_count_map[terraform.workspace]

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

resource "yandex_compute_instance" "nodes_each" {

  for_each = local.hosts[terraform.workspace]
  name = each.key
  platform_id = local.comp_instance_type_map[terraform.workspace]

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

  lifecycle {
    create_before_destroy = true
  }
}

resource "yandex_vpc_network" "net" {}

resource "yandex_vpc_subnet" "subnet" {
  zone       = "ru-central1-a"
  network_id = "${yandex_vpc_network.net.id}"
  v4_cidr_blocks = ["192.168.1.0/24"]
}