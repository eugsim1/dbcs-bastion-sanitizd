/* Instances */

 

locals {
  public_keys = format("%s\n%s%s", file(var.compute.ssh_public_key),
    var.opc_key.public_key_openssh,
  var.oracle_key.public_key_openssh)
}


resource "oci_core_instance" "instance" {
  count = var.compute.instance_count

  availability_domain = var.availability_domain
  compartment_id      = var.oci_provider.compartment_ocid
  display_name        = format("%s-%03s", var.compute.display_name, count.index)
  shape               = var.compute.instance_shape
  shape_config {
    memory_in_gbs = "4"
    ocpus         = "1"
  }


  metadata = {
    ###user_data           = base64encode(var.user-data)
    ssh_authorized_keys = local.public_keys ##file(var.ssh_public_key)
  }

  create_vnic_details {
    subnet_id        = var.compute.subnet_id
    hostname_label   = format("%s-%03s", var.compute.display_name, count.index)
    assign_public_ip = "false"
  }

  source_details {
    source_type = "image"
    source_id   = data.oci_core_images.oracle.images.0.id
  }
}






resource "null_resource" "instance_setup" {
  count      = var.compute.instance_count
  depends_on = [oci_core_instance.instance]

  connection {
    type        = "ssh"
    host        = element(flatten(list(oci_core_instance.instance.*.private_ip)), count.index)
    user        = "opc"                            ##var.bastion_user
    private_key = file("wls-wdt-testkey-priv.txt") ### file("${var.bastion_ssh_private_key}")

    bastion_host        = var.compute.bastion_public_ip
    bastion_user        = var.compute.bastion_user
    bastion_private_key = file("wls-wdt-testkey-priv.txt") ## file(var.bastion_ssh_private_key)
  }

  provisioner "file" {
    source      = "scripts/setup.sh"
    destination = "/tmp/setup.sh"
  }

  provisioner "remote-exec" {
    inline = ["chmod  +x /tmp/setup.sh",
    "/tmp/setup.sh", ]
  }

}

resource "null_resource" "instance_install_node" {
  count = var.compute.install_node == true ? var.compute.instance_count : 0
  ##count      =  var.compute.instance_count  
  depends_on = [null_resource.instance_setup]

  connection {
    type        = "ssh"
    host        = element(flatten(list(oci_core_instance.instance.*.private_ip)), count.index)
    user        = "opc"                            ##var.bastion_user
    private_key = file("wls-wdt-testkey-priv.txt") ### file("${var.bastion_ssh_private_key}")

    bastion_host        = var.compute.bastion_public_ip
    bastion_user        = var.compute.bastion_user
    bastion_private_key = file("wls-wdt-testkey-priv.txt") ## file(var.bastion_ssh_private_key)
  }

  provisioner "file" {
    source      = "scripts/install_node.sh"
    destination = "/tmp/install_node.sh"
  }
  provisioner "remote-exec" {
    inline = ["chmod  +x /tmp/install_node.sh",
    "/tmp/install_node.sh", ]
  }


}


resource "null_resource" "instance_install_nginx" {
  count      = var.compute.install_nginx == true ? var.compute.instance_count : 0
  depends_on = [oci_core_instance.instance]

  connection {
    type        = "ssh"
    host        = element(flatten(list(oci_core_instance.instance.*.private_ip)), count.index)
    user        = "opc"                            ##var.bastion_user
    private_key = file("wls-wdt-testkey-priv.txt") ### file("${var.bastion_ssh_private_key}")

    bastion_host        = var.compute.bastion_public_ip
    bastion_user        = var.compute.bastion_user
    bastion_private_key = file("wls-wdt-testkey-priv.txt") ## file(var.bastion_ssh_private_key)
  }

  provisioner "file" {
    source      = "scripts/install_nginx.sh"
    destination = "/tmp/install_nginx.sh"
  }
  provisioner "remote-exec" {
    inline = ["chmod  +x /install_nginx.sh",
    "/tmp/install_nginx.sh", ]
  }

  provisioner "file" {
    source      = "scripts/nginx_conf"
    destination = "/tmp"
  }

  provisioner "file" {
    source      = "scripts/reconfigure_target.sh"
    destination = "/tmp/reconfigure_target.sh"
  }

  provisioner "remote-exec" {
    inline = ["chmod  +x /tmp/reconfigure_target.sh",
    "/tmp/reconfigure_target.sh", ]
  }

}

