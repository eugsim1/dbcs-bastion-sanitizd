/* Instances */

/*
resource "oci_core_instance_console_connection" "test_instance_console_connection" {
    #Required
    instance_id = "${oci_core_instance.bastion.id}"
    public_key = file(var.ssh_public_key)
    #Optional
	//defined_tags = {"Mandatory_Tag.SE_email" :"eugenesimos@oracle.com" }
}
*/

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


/*
resource "null_resource" "bastion_reconfig" {
  depends_on = [ oci_core_instance.bastion]
  connection {
    type        = "ssh"
    host        = "${element( flatten(list(oci_core_instance.bastion.*.public_ip)) , count.index)}"
    user        = "opc"
    private_key = file("${var.bastion_ssh_private_key}")
  }  

    provisioner "file" {
    source      = "bastionconfig"
    destination = "/home/opc/.ssh/config"
    }  
    
    provisioner "file" {
    source      = "priv.txt"
    destination = "/home/opc/.ssh/priv.txt"
    }   

  provisioner "remote-exec" {
    inline = [
      "chmod go-rw /home/opc/.ssh/priv.txt"   ]
   }      
        
    provisioner "file" {
    source      = "rename-config.sh"
    destination = "/tmp/rename-config.sh"
    }  
    
	provisioner "file" {
    source      = "instance1-ssh.sh"
    destination = "instance1-ssh.sh"
    }  
    
	provisioner "file" {
    source      = "instance2-ssh.sh"
    destination = "instance2-ssh.sh"
    }  
    

    provisioner "file" {
    source      = "init.sh"
    destination = "/tmp/init.sh"
    }  
    provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/init.sh",      "/tmp/init.sh",
    ]
  }  
  
    provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/rename-config.sh",      "/tmp/rename-config.sh",
    ]
   }      

    
}
*/








/*
resource "local_file" "ssh_bastion_url" {
##  depends_on = [ "oci_dns_record.record-a-ebs" ]
  count = var.instance_count
  content = "ssh -i priv.txt oracle@${element(flatten([oci_core_instance.bastion.*.public_ip]), count.index, )}"
  filename = "bastion${count.index}-ssh.sh"
}

resource "local_file" "instance1" {
##  depends_on = [ "oci_dns_record.record-a-ebs" ]
  content = "ssh -i priv.txt opc@${oci_core_instance.instance1.private_ip}"
  filename = "instance1-ssh.sh"
}

resource "local_file" "instance2" {
##  depends_on = [ "oci_dns_record.record-a-ebs" ]
  content = "ssh -i priv.txt opc@${oci_core_instance.instance2.private_ip}"
  filename = "instance2-ssh.sh"
}
*/

/*
variable "user-data" {
  default = <<EOF
#!/bin/bash -x
echo '################### webserver userdata begins #####################'
touch ~opc/userdata.`date +%s`.start

# echo '########## yum update all ###############'
# yum update -y

echo '########## basic webserver ##############'
yum install -y httpd
systemctl enable  httpd.service
systemctl start  httpd.service
echo '<html><head></head><body><pre><code>' > /var/www/html/index.html
hostname >> /var/www/html/index.html
echo '' >> /var/www/html/index.html
cat /etc/os-release >> /var/www/html/index.html
echo '</code></pre></body></html>' >> /var/www/html/index.html
firewall-offline-cmd --add-service=http
##systemctl enable  firewalld
##systemctl restart  firewalld

touch ~opc/userdata.`date +%s`.finish
echo '################### webserver userdata ends #######################'
EOF

}
*/


/*
resource "null_resource" "instance_reconfig_publicip" {
  count = var.instance_count
  depends_on = [ oci_core_instance.instance ]
  connection {
    type        = "ssh"
    host        = "${element( flatten(list(oci_core_instance.instance.*.public_ip)) , count.index)}"
    user        = "opc"
    private_key = file("${var.bastion_ssh_private_key}")
  } 
  }  
*/