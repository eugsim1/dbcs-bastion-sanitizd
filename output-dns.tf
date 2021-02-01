
output "dns_loadbalancer" {
  value = var.use_lb == true ? module.dns[0].dns_loadbalancer : 0
}


output "all_zones" {
  value = var.use_lb == true ? module.dns[0].all_zones : 0
}
