output "lb_public_ip" {
  value = oci_load_balancer.load_balancer.ip_address_details[0].ip_address ##oci_load_balancer.load_balancer.*
  ### oci_load_balancer.load_balancer.ip_address_details[0].ip_address  
}

/*
output "hostname_lb" {
  value = zipmap(values(oci_load_balancer_hostname.hostname_lb)[*].name, values(oci_load_balancer_hostname.hostname_lb)[*].hostname)
}
*/

output "all_certificates" {
  value = values(oci_load_balancer_certificate.all_certificates)[*].certificate_name
}


output "hostname_lb" {
  value = values(oci_load_balancer_hostname.hostname_lb)[*].hostname
}
