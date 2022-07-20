# **7.2. Облачные провайдеры и синтаксис Terraform.**

# *Задача 1 (Вариант с Yandex.Cloud).*

Учётная запись была зарегистрирована при выполнении ДЗ из модуля 5. Переинициализируем профиль:

```
yc init 
Welcome! This command will take you through the configuration process.
Pick desired action:
 [1] Re-initialize this profile 'default' with new settings 
 [2] Create a new profile
Please enter your numeric choice: 1
Please enter OAuth token: <token>
Please choose folder to use:
 [1] default (id = b1gr8v9po6fuo7obdcps)
 [2] Create a new folder
Please enter your numeric choice: 2
Please enter a folder name: netology
Your current folder has been set to 'netology' (id = b1g8t7bb3jnhfrkoa6uk).
Do you want to configure a default Compute zone? [Y/n] 
Which zone do you want to use as a profile default?
 [1] ru-central1-a
 [2] ru-central1-b
 [3] ru-central1-c
 [4] Don't set default zone
Please enter your numeric choice: 1
Your profile default Compute zone has been set to 'ru-central1-a'.
```

Для работы Terraform потребуется создать сервисный аккаунт:

```
yc iam service-account create --name terra-robot
id: aje4h0j2i352da28q9k7
folder_id: b1g8t7bb3jnhfrkoa6uk
created_at: "2022-07-19T12:48:39.957327905Z"
name: terra-robot
```

Сервисному аккаунту необходимо назначить роль, т.е. указать что этот аккаунт может делать в нашем облаке. Назначим этой сервисной учётноной записи роль 'Editor':

```
yc iam service-account get terra-robot
id: aje4h0j2i352da28q9k7
folder_id: b1g8t7bb3jnhfrkoa6uk
created_at: "2022-07-19T12:48:39Z"
name: terra-robot

yc resource-manager folder add-access-binding netology --role editor --subject serviceAccount:aje4h0j2i352da28q9k7
```

Получим IAM-токен для авторизации сервисной учётной записи. Для этого создадим авторизованные ключи (пара открытый и закрытый):

```
yc iam key create --service-account-name terra-robot --output key.json
id: ajeentnp5cscf0e9nli4
service_account_id: aje4h0j2i352da28q9k7
created_at: "2022-07-19T13:35:34.009305557Z"
key_algorithm: RSA_2048
```

И получим token:

```
yc iam create-token 
<token>

```

Данный token запишем в переменую окружения YC_TOKEN, что бы не указывать авторизационный токен в коде.


# *Задача 2. Создание yandex_compute_instance через терраформ.*

Создадим файлы main.tf и versions.tf и проинициализируем рабочую директорию.

```
terraform init

Initializing the backend...

Initializing provider plugins...
- Finding latest version of yandex-cloud/yandex...
- Installing yandex-cloud/yandex v0.76.0...
- Installed yandex-cloud/yandex v0.76.0 (self-signed, key ID E40F590B50BB8E40)

Partner and community providers are signed by their developers.
If you'd like to know more about provider signing, you can read about it here:
https://www.terraform.io/docs/cli/plugins/signing.html

Terraform has created a lock file .terraform.lock.hcl to record the provider
selections it made above. Include this file in your version control repository
so that Terraform can guarantee to make the same selections by default when
you run "terraform init" in the future.

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.

```

Проверим выполнение 'terraform plan':

```
terraform plan

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # yandex_compute_image.test-image will be created
  + resource "yandex_compute_image" "test-image" {
      + created_at      = (known after apply)
      + family          = "ubuntu-2004-lts"
      + folder_id       = (known after apply)
      + id              = (known after apply)
      + min_disk_size   = (known after apply)
      + name            = "ubuntu-public-image"
      + os_type         = (known after apply)
      + pooled          = (known after apply)
      + product_ids     = (known after apply)
      + size            = (known after apply)
      + source_disk     = (known after apply)
      + source_family   = (known after apply)
      + source_image    = (known after apply)
      + source_snapshot = (known after apply)
      + source_url      = (known after apply)
      + status          = (known after apply)
    }

  # yandex_compute_instance.test will be created
  + resource "yandex_compute_instance" "test" {
      + created_at                = (known after apply)
      + folder_id                 = (known after apply)
      + fqdn                      = (known after apply)
      + hostname                  = (known after apply)
      + id                        = (known after apply)
      + name                      = "test"
      + network_acceleration_type = "standard"
      + platform_id               = "standard-v1"
      + service_account_id        = (known after apply)
      + status                    = (known after apply)
      + zone                      = (known after apply)

      + boot_disk {
          + auto_delete = true
          + device_name = (known after apply)
          + disk_id     = (known after apply)
          + mode        = (known after apply)

          + initialize_params {
              + block_size  = (known after apply)
              + description = (known after apply)
              + image_id    = (known after apply)
              + name        = (known after apply)
              + size        = (known after apply)
              + snapshot_id = (known after apply)
              + type        = "network-hdd"
            }
        }

      + network_interface {
          + index              = (known after apply)
          + ip_address         = (known after apply)
          + ipv4               = true
          + ipv6               = (known after apply)
          + ipv6_address       = (known after apply)
          + mac_address        = (known after apply)
          + nat                = (known after apply)
          + nat_ip_address     = (known after apply)
          + nat_ip_version     = (known after apply)
          + security_group_ids = (known after apply)
          + subnet_id          = (known after apply)
        }

      + placement_policy {
          + host_affinity_rules = (known after apply)
          + placement_group_id  = (known after apply)
        }

      + resources {
          + core_fraction = 100
          + cores         = 2
          + memory        = 4
        }

      + scheduling_policy {
          + preemptible = (known after apply)
        }
    }

  # yandex_vpc_network.net will be created
  + resource "yandex_vpc_network" "net" {
      + created_at                = (known after apply)
      + default_security_group_id = (known after apply)
      + folder_id                 = (known after apply)
      + id                        = (known after apply)
      + labels                    = (known after apply)
      + name                      = (known after apply)
      + subnet_ids                = (known after apply)
    }

  # yandex_vpc_subnet.subnet will be created
  + resource "yandex_vpc_subnet" "subnet" {
      + created_at     = (known after apply)
      + folder_id      = (known after apply)
      + id             = (known after apply)
      + labels         = (known after apply)
      + name           = (known after apply)
      + network_id     = (known after apply)
      + v4_cidr_blocks = [
          + "192.168.1.0/24",
        ]
      + v6_cidr_blocks = (known after apply)
      + zone           = "ru-central1-a"
    }

Plan: 4 to add, 0 to change, 0 to destroy.

─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

Note: You didn't use the -out option to save this plan, so Terraform can't guarantee to take exactly these actions if you run "terraform apply" now.
```

# *Результат задания*

1. При помощи какого инструмента (из разобранных на прошлом занятии) можно создать свой образ ami?

- Образ можно создать при помощи Packer

2. Ссылка на репозиторий с исходной конфигурацией терраформа.

- https://github.com/Skosenko78/DevOps-Homeworks/tree/main/Lab7.2Files/cloud-terraform
