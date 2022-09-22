locals {
  comp_instance_type_map = {
    stage = "standard-v1"
    prod = "standard-v2"
  }

  subnets_v4_cidr_front = {
    stage = ["192.168.10.0/24"]
    prod  = ["192.168.20.0/24"]
  }

  subnets_v4_cidr_back = {
    stage = ["192.168.11.0/24"]
    prod  = ["192.168.22.0/24"]
  }

  default_gw = {
    stage = "192.168.10.254"
    prod = "192.168.20.254"
  }
}