locals {
  web_ip_public_instance = var.use_compute == true ? module.compute.web_ip_public_instance : 0
}


output "web_ip_private_instance" {
  value = var.use_compute == true ? module.compute.web_ip_private_instance : 0
}

/*
resource "local_file" "loggin_web_ssh" {
  ###depends_on = [ oci_core_instance.test_instance, null_resource.update_server ]
  content         = format("%s %s%s", "ssh -i wls-wdt-testkey-priv.txt ", "opc@", module.compute.web_ip_public_instance)
  file_permission = "700"
  filename        = "ssh_opc_web.sh"
}
*/

resource "local_file" "loggin_proxy_web_ssh" {
  count = var.use_compute == true ? 1 : 0
  ###depends_on = [ oci_core_instance.test_instance, null_resource.update_server ]
  content         = <<EOT
# file created by output.tf
  ${format("%s %s%s %s%s", "ssh -i wls-wdt-testkey-priv.txt -J ", "opc@", module.bastion[0].bastion_public_ip, " opc@", local.web_ip_public_instance)}
  EOT
  file_permission = "700"
  filename        = "ssh_opc_proxy_web.sh"
}

/*
## ssh -i wls-wdt-testkey-priv.txt -o ProxyCommand="ssh -i wls-wdt-testkey-priv.txt -W %h:%p opc@193.123.38.135 " opc@10.0.2.2 
resource "local_file" "loggin_compute_ssh" {
  count = var.use_compute == true ? 1 :0
  count = var.instance_count
  ###depends_on = [  oci_core_instance.test_instance, null_resource.update_server  ]
  content         = <<EOT
# file created by output.tf
  format("%s %s%s%s %s%s", "ssh -i wls-wdt-testkey-priv.txt -o ProxyCommand=\"ssh -i wls-wdt-testkey-priv.txt -W %h:%p ", "opc@", module.bastion.bastion_public_ip, "\" ", "opc@", module.compute.web_ip_private_instance[count.index])
  EOT
  file_permission = "700"
  filename        = "ssh_opc_admin-${count.index}.sh"
}
*/