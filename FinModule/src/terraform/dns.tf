resource "yandex_dns_zone" "public-zone" {
  name   = "dns-public-zone"
  zone   = "${var.domain_name}."
  public = true
}

resource "yandex_dns_recordset" "dns_domain_record" {
  zone_id = yandex_dns_zone.public-zone.id
  name    = "${var.domain_name}."
  type    = "A"
  ttl     = 600
  data    = [yandex_compute_instance.nginx.network_interface.0.nat_ip_address]
  depends_on = [
    yandex_compute_instance.nginx
  ]
}

resource "yandex_dns_recordset" "dns_www_record" {
  zone_id = yandex_dns_zone.public-zone.id
  name    = "www"
  type    = "A"
  ttl     = 600
  data    = [yandex_compute_instance.nginx.network_interface.0.nat_ip_address]
  depends_on = [
    yandex_compute_instance.nginx
  ]
}

resource "yandex_dns_recordset" "dns_gitlab_record" {
  zone_id = yandex_dns_zone.public-zone.id
  name    = "gitlab"
  type    = "A"
  ttl     = 600
  data    = [yandex_compute_instance.nginx.network_interface.0.nat_ip_address]
  depends_on = [
    yandex_compute_instance.nginx
  ]
}

resource "yandex_dns_recordset" "dns_grafana_record" {
  zone_id = yandex_dns_zone.public-zone.id
  name    = "grafana"
  type    = "A"
  ttl     = 600
  data    = [yandex_compute_instance.nginx.network_interface.0.nat_ip_address]
  depends_on = [
    yandex_compute_instance.nginx
  ]
}

resource "yandex_dns_recordset" "dns_prometheus_record" {
  zone_id = yandex_dns_zone.public-zone.id
  name    = "prometheus"
  type    = "A"
  ttl     = 600
  data    = [yandex_compute_instance.nginx.network_interface.0.nat_ip_address]
  depends_on = [
    yandex_compute_instance.nginx
  ]
}

resource "yandex_dns_recordset" "dns_alertmanager_record" {
  zone_id = yandex_dns_zone.public-zone.id
  name    = "alertmanager"
  type    = "A"
  ttl     = 600
  data    = [yandex_compute_instance.nginx.network_interface.0.nat_ip_address]
  depends_on = [
    yandex_compute_instance.nginx
  ]
}