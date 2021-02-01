output "bastion_ip_public_instance" {
  value = module.bastion[0].bastion_public_ip
}

resource "local_file" "loggin_bastion_ssh" {
  ###depends_on = [ oci_core_instance.test_instance, null_resource.update_server ]
  content         = <<EOT
# file created by output-bastion.tf
  ${format("%s %s%s", "ssh -i wls-wdt-testkey-priv.txt ", "opc@", module.bastion[0].bastion_public_ip)}
EOT  
  file_permission = "700"
  filename        = "ssh_opc_bastion.sh"
}