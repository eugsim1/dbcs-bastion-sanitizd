
output "lb_public_ip" {
  value = var.use_lb == true ? module.loadbalancer[0].lb_public_ip : 0
}

output "hostname_lb" {
  value = var.use_lb == true ? module.loadbalancer[0].hostname_lb : 0
}


output "all_certificates" {
  value = var.use_lb == true ? module.loadbalancer[0].all_certificates : 0
}