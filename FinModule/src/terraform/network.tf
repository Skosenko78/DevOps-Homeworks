resource "yandex_vpc_network" "net" {
  name = "network-${terraform.workspace}"
}

resource "yandex_vpc_route_table" "route" {
  network_id = "${yandex_vpc_network.net.id}"
  static_route {
    destination_prefix = "0.0.0.0/0"
    next_hop_address   = local.default_gw[terraform.workspace]
  }
}

resource "yandex_vpc_subnet" "subnet_front" {
  name = "subnet-front-${terraform.workspace}"
  zone           = "ru-central1-a"
  network_id     = "${yandex_vpc_network.net.id}"
  v4_cidr_blocks = local.subnets_v4_cidr_front[terraform.workspace]
  route_table_id = yandex_vpc_route_table.route.id
}

resource "yandex_vpc_subnet" "subnet_back" {
  name = "subnet-back-${terraform.workspace}"
  zone           = "ru-central1-b"
  network_id     = "${yandex_vpc_network.net.id}"
  v4_cidr_blocks = local.subnets_v4_cidr_back[terraform.workspace]
  route_table_id = yandex_vpc_route_table.route.id
}