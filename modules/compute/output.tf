output "web_ip_public_instance" {
  value = oci_core_instance.instance[0].public_ip
}

output "web_ip_private_instance" {
  value = oci_core_instance.instance[*].private_ip
}