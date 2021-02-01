
output "bastion_public_ip" {
  value = oci_core_instance.bastion[0].public_ip
}

output "bastion_private_ip" {
  value = oci_core_instance.bastion[0].private_ip
} 