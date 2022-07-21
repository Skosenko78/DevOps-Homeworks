terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}

provider "yandex" {
  service_account_key_file = "key.json"
  cloud_id  = "b1gl404splab9eas7u6l"
  folder_id = "b1g8t7bb3jnhfrkoa6uk"
  zone      = "ru-central1-a"
}

resource "yandex_storage_bucket" "tf-state" {
  bucket = "terraform-running-state"
}