resource "local_file" "inventory" {
  content = <<-DOC
    # Ansible inventory containing variable values from Terraform.
    # Generated by Terraform.

---

all:
   hosts:
      nginx:
         ansible_host: ${yandex_compute_instance.nginx.network_interface.0.nat_ip_address}
      app:
         ansible_host: ${yandex_compute_instance.app.network_interface.0.ip_address}
      db01:
         ansible_host: ${yandex_compute_instance.db01.network_interface.0.ip_address}
      db02:
         ansible_host: ${yandex_compute_instance.db02.network_interface.0.ip_address}
      gitlab:
         ansible_host: ${yandex_compute_instance.gitlab.network_interface.0.ip_address}
      runner:
         ansible_host: ${yandex_compute_instance.runner.network_interface.0.ip_address}
      monitoring:
         ansible_host: ${yandex_compute_instance.monitoring.network_interface.0.ip_address}

   children:
      innodes:
         hosts:
            app:
            db01:
            db02:
            gitlab:
            monitoring:
            runner:
         vars:
            ansible_ssh_common_args: '-o ControlMaster=auto -o ControlPersist=10m -o ProxyCommand="ssh -W %h:%p -q ubuntu@${yandex_compute_instance.nginx.network_interface.0.nat_ip_address}"'

      mysqldb:
         hosts:
            db01:
            db02:
   vars:
      domain_name: ${var.domain_name}
      ip_nginx_host: ${yandex_compute_instance.nginx.network_interface.0.ip_address}
      ip_app_host: ${yandex_compute_instance.app.network_interface.0.ip_address}
      ip_db01_host: ${yandex_compute_instance.db01.network_interface.0.ip_address}
      ip_db02_host: ${yandex_compute_instance.db02.network_interface.0.ip_address}
      ip_gitlab_host: ${yandex_compute_instance.gitlab.network_interface.0.ip_address}
      ip_runner_host: ${yandex_compute_instance.runner.network_interface.0.ip_address}
      ip_monitoring_host: ${yandex_compute_instance.monitoring.network_interface.0.ip_address}
...
DOC
filename = "../ansible/inventory"

  depends_on = [
    yandex_compute_instance.nginx,
    yandex_compute_instance.db01,
    yandex_compute_instance.db02,
    yandex_compute_instance.app,
    yandex_compute_instance.gitlab,
    yandex_compute_instance.runner,
    yandex_compute_instance.monitoring
  ]

}