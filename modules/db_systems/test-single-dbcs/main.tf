### main dbcs configuration






resource "oci_database_db_system" "dbcs_system" {
  availability_domain = var.availability_domain.name #"oTOh:EU-FRANKFURT-1-AD-1"
  compartment_id      = var.oci_provider.compartment_ocid
  count               = var.dbcs.instance_count

  cpu_core_count          = var.dbcs.database_cpu_core_count
  data_storage_percentage = var.dbcs.database_data_storage_percentage
  data_storage_size_in_gb = var.dbcs.database_data_storage_size_in_gb
  database_edition        = var.dbcs.database_database_edition #"ENTERPRISE_EDITION"
  db_home {
    database {
      admin_password      = var.dbcs.database_admin_password
      tde_wallet_password = var.dbcs.database_tde_wallet_password
      character_set       = var.dbcs.database_character_set #"AL32UTF8"

      db_backup_config {
        auto_backup_enabled = var.dbcs.db_backup_config_auto_backup_enabled #"false"
        auto_backup_window  = var.dbcs.db_backup_config_auto_backup_window  #""

      }

      db_name      = var.dbcs.database_db_name     #"mydbcs"
      db_workload  = var.dbcs.database_db_workload #"OLTP"
      defined_tags = var.dbcs.database_defined_tags

      ####### -- 	  {
      ####### --         "Oracle-Tags.ResourceAllocation" = "DataSafe-prep"
      ####### --       }

      freeform_tags = var.dbcs.database_freeform_tags

      ####### -- 	  {
      ####### --         "Comment"     = "Bastion setup for omc project"
      ####### --         "Project"     = "omc"
      ####### --         "Responsible" = "put the name here"
      ####### --         "Role"        = "Bastion for omc"
      ####### --         "Version"     = "0.0.0.0"
      ####### --       }

      ncharacter_set = var.dbcs.database_ncharacter_set #"AL16UTF16"
      pdb_name       = var.dbcs.database_pdb_name       #"pdbName"

    }

    db_version = var.dbcs.db_home_db_version #"19.9.0.0"

    display_name  = var.dbcs.db_home_display_name #"mydbcshome"
    freeform_tags = var.dbcs.freeform_tags
    ####### -- 	{
    ####### --     }
  }
  db_system_options {
    storage_management = var.dbcs.db_system_options_storage_management #"LVM"
  }
  defined_tags = var.dbcs.db_system_defined_tags

  ####### --   {
  ####### --     "Oracle-Tags.ResourceAllocation" = "DataSafe-prep"
  ####### --   }


  disk_redundancy = var.dbcs.database_disk_redundancy #"NORMAL"
  display_name    = var.dbcs.database_display_name    #"myoracledb"
  domain          = "lbprivreg.lbvcn1.oraclevcn.com"

  ####### --   fault_domains = [
  ####### --     data.oci_identity_fault_domains.dbcs_fault_domains.fault_domains[1].name,
  ####### --   ]



  freeform_tags = var.dbcs.db_system_freeform_tags

  ####### --   {
  ####### --     "Comment"     = "Bastion setup for omc project"
  ####### --     "Project"     = "omc"
  ####### --     "Responsible" = "put the name here"
  ####### --     "Role"        = "Bastion for omc"
  ####### --     "Version"     = "0.0.0.0"
  ####### --   }

  hostname = var.dbcs.database_hostname #"myoracledb"

  license_model = var.dbcs.database_license_model #"BRING_YOUR_OWN_LICENSE"

  node_count = var.dbcs.database_node_count #"1"
  nsg_ids    = var.dbcs.database_nsg_ids

  shape  = var.dbcs.database_shape  #"VM.Standard2.1"
  source = var.dbcs.database_source #"NONE"

  ssh_public_keys = var.dbcs.database_ssh_public_keys

  subnet_id = var.dbcs.database_subnet_id #
  time_zone = var.dbcs.database_time_zone #"Europe/Helsinki"


  ####### --   lifecycle {
  ####### --     ignore_changes = [ hostname, freeform_tags, defined_tags["Oracle-Tags.CreatedOn"], db_home[0].database[0].admin_password]
  ####### --   }
  ####### --   
  lifecycle {
    ignore_changes = [freeform_tags, defined_tags["Oracle-Tags.CreatedBy"], hostname, reco_storage_size_in_gb]
  }
}

/*
resource "oci_database_backup" "dbcs_backup" {
    count               = var.dbcs.instance_count
    database_id = oci_database_db_system.dbcs_system[count.index].db_home[0].database[0].id
    display_name = "${var.dbcs.db_home_display_name}-backup"
}
*/


####### --  to be written    resource "oci_database_data_guard_association" "dbcs_guard_association" {
####### --  to be written        #Required
####### --  to be written        creation_type = var.data_guard_association_creation_type
####### --  to be written        database_admin_password = var.data_guard_association_database_admin_password
####### --  to be written        database_id = oci_database_database.test_database.id
####### --  to be written        delete_standby_db_home_on_delete = var.data_guard_association_delete_standby_db_home_on_delete
####### --  to be written        protection_mode = var.data_guard_association_protection_mode
####### --  to be written        transport_type = var.data_guard_association_transport_type
####### --  to be written    
####### --  to be written        #Optional
####### --  to be written        availability_domain = var.data_guard_association_availability_domain
####### --  to be written        backup_network_nsg_ids = var.data_guard_association_backup_network_nsg_ids
####### --  to be written        database_software_image_id = oci_database_database_software_image.test_database_software_image.id
####### --  to be written        display_name = var.data_guard_association_display_name
####### --  to be written        hostname = var.data_guard_association_hostname
####### --  to be written        nsg_ids = var.data_guard_association_nsg_ids
####### --  to be written        peer_db_home_id = oci_database_db_home.test_db_home.id
####### --  to be written        peer_db_system_id = oci_database_db_system.test_db_system.id
####### --  to be written        peer_vm_cluster_id = oci_database_vm_cluster.test_vm_cluster.id
####### --  to be written        shape = var.data_guard_association_shape
####### --  to be written        subnet_id = oci_core_subnet.test_subnet.id
####### --  to be written    }

#########################

resource "null_resource" "copy-file-bastion" {
  depends_on = [data.oci_core_vnic.test_vnic]
  count      = var.dbcs.instance_count
  connection {
    type        = "ssh"
    host        = element(flatten(list(data.oci_core_vnic.test_vnic.*.public_ip_address)), count.index)
    user        = "opc"
    private_key = file(var.dbcs.database_ssh_public_keys[0]) #var.dbcs.database_ssh_public_keys
  }

  provisioner "file" {
    source      = "${path.module}/scripts/update_oracle_user.sh"
    destination = "/home/opc/update_oracle_user.sh"
  }


  provisioner "remote-exec" {
    inline = [
      "chmod +x /home/opc/update_oracle_user.sh",
      "/home/opc/update_oracle_user.sh",
    ]
  }


}


# Get DB node list
data "oci_database_db_nodes" "db_nodes" {
  count          = var.dbcs.instance_count
  compartment_id = var.compartment_id
  db_system_id   = oci_database_db_system.dbcs_system[count.index].id ### every instance dbcs_system[count.index]
}

output "db_nodes" {
  value = data.oci_database_db_nodes.db_nodes.*
}


# Get DB node details
data "oci_database_db_node" "db_node_details" {
  count      = var.dbcs.instance_count
  db_node_id = lookup(data.oci_database_db_nodes.db_nodes[count.index].db_nodes[0], "id")
}

output "db_node_details" {
  value = data.oci_database_db_node.db_node_details.*
}


data "oci_core_vnic" "test_vnic" {
  count   = var.dbcs.instance_count
  vnic_id = data.oci_database_db_node.db_node_details[count.index].vnic_id
}



output "test_vnic" {
  value = data.oci_core_vnic.test_vnic.*
}


resource "local_file" "ansible_hosts" {
  depends_on = [oci_database_db_system.dbcs_system]
  content = "[servers]${join(
    "    ",
    formatlist(
      "\n %s %s",
      data.oci_core_vnic.test_vnic.*.public_ip_address,
    " ansible_user=opc ansible_ssh_private_key_file=priv.txt"),
  )}"
  filename = "hosts"
}


resource "local_file" "ssh_priv_key" {
  depends_on      = [oci_database_db_system.dbcs_system]
  count           = var.dbcs.instance_count
  content         = file("wls-wdt-testkey-priv.txt") ##file("priv.txt")
  file_permission = "0700"
  filename        = "config/${element(flatten(list(data.oci_core_vnic.test_vnic.*.public_ip_address)), count.index)}/priv.txt"
}


resource "local_file" "ssh_dbcs_url" {
  depends_on = [oci_database_db_system.dbcs_system]
  count      = var.dbcs.instance_count
  content    = "ssh -i priv.txt   opc@${element(flatten(list(data.oci_core_vnic.test_vnic.*.public_ip_address)), count.index)} ##"
  filename   = "config/${element(flatten(list(data.oci_core_vnic.test_vnic.*.public_ip_address)), count.index)}/${element(flatten(list(data.oci_core_vnic.test_vnic.*.public_ip_address)), count.index)}-ssh-dbcs_server.sh"
}


resource "local_file" "sql_dbcs_url" {
  depends_on = [oci_database_db_system.dbcs_system]
  count      = var.dbcs.instance_count
  content    = "sqlplus sys/${var.db_admin_password}@${element(flatten(list(data.oci_core_vnic.test_vnic.*.public_ip_address)), count.index)}:1521/${oci_database_db_system.dbcs_system[count.index].db_home[0].database[0].db_unique_name}.${oci_database_db_system.dbcs_system[count.index].domain}  as sysdba"
  filename   = "config/${element(flatten(list(data.oci_core_vnic.test_vnic.*.public_ip_address)), count.index)}/${element(flatten(list(data.oci_core_vnic.test_vnic.*.public_ip_address)), count.index)}-sql-dbcs_server.sh"
}

#################################################


/***********************************************

resource "local_file" "sql_datasafe_url" {
  depends_on = [oci_database_db_system.dbcs_system]
  count      = var.dbcs.instance_count
  content    = "sqlplus DATASAFE_ADMIN/'WElcome1412#!'@${element(flatten(list(data.oci_core_vnic.test_vnic.*.public_ip_address)), count.index)}:1521/${oci_database_db_system.dbcs_system[count.index].db_unique_name}.${oci_database_db_system.dbcs_system[count.index].domain}"
  filename   = "config/${element(flatten(list(data.oci_core_vnic.test_vnic.*.public_ip_address)), count.index)}/${element(flatten(list(data.oci_core_vnic.test_vnic.*.public_ip_address)), count.index)}-sql-DATASAFE_ADMIN_server.sh"
}

resource "local_file" "sql_oe_url" {
  depends_on = [oci_database_db_system.dbcs_system]
  count      = var.dbcs.instance_count
  content    = "sqlplus oe/'WElcome1412#!'@${element(flatten(list(data.oci_core_vnic.test_vnic.*.public_ip_address)), count.index)}:1521/${var.db_pdb_name}.${oci_database_db_system.dbcs_system[count.index].domain}"
  filename   = "config/${element(flatten(list(data.oci_core_vnic.test_vnic.*.public_ip_address)), count.index)}/${element(flatten(list(data.oci_core_vnic.test_vnic.*.public_ip_address)), count.index)}-sql-oe_server.sh"
}


data "oci_database_database" "test_database" {
depends_on = [oci_database_db_system.dbcs_system]
     count           = var.dbcs.instance_count
    #Required
    database_id = oci_database_db_system.dbcs_system[count.index].id
}

resource "local_file" "sql_hr_url" {
  depends_on = [oci_database_db_system.dbcs_system]
  count      = var.dbcs.instance_count
  content    = "sqlplus hr/'WElcome1412#!'@${element(flatten(list(data.oci_core_vnic.test_vnic.*.public_ip_address)), count.index)}:1521/${var.db_pdb_name}.${oci_database_db_system.dbcs_system[count.index].domain}"
  filename   = "config/${element(flatten(list(data.oci_core_vnic.test_vnic.*.public_ip_address)), count.index)}/${element(flatten(list(data.oci_core_vnic.test_vnic.*.public_ip_address)), count.index)}-sql-hr_server.sh"
}

/*
resource "oci_objectstorage_object" "test_object" {
    #Required
    bucket = "${var.object_bucket}"
    content = "${var.object_content}"
    namespace = "${var.object_namespace}"
    object = "${var.object_object}"

    #Optional
    cache_control = "${var.object_cache_control}"
    content_disposition = "${var.object_content_disposition}"
    content_encoding = "${var.object_content_encoding}"
    content_language = "${var.object_content_language}"
    content_type = "${var.object_content_type}"
    delete_all_object_versions = "${var.object_delete_all_object_versions}"
    metadata = "${var.object_metadata}"
}
*/

 