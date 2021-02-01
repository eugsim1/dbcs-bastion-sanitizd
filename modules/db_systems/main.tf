### main dbcs configuration

/* only to be used if i have to add generated keys ... from the keygen module
locals {
  public_keys = format("%s\n%s%s", file(var.dbcs.database_ssh_public_keys),
    var.opc_key.public_key_openssh,
  var.oracle_key.public_key_openssh)
}
*/
data "local_file" "ssh_file" {
  filename = var.dbcs.database_ssh_public_keys[0]
}


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

      db_name      = var.dbcs.database_db_name      #"mydbcs"
      db_workload  = var.dbcs.database_db_workload  #"OLTP"
      defined_tags = var.dbcs.database_defined_tags #   	  { "Oracle-Tags.ResourceAllocation" = "DataSafe-prep" }

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
  domain          = var.dbcs.database_domain          ##
  fault_domains   = var.dbcs.database_fault_domains

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

  ssh_public_keys = [data.local_file.ssh_file.content] ###var.dbcs.database_ssh_public_keys 

  subnet_id = var.dbcs.database_subnet_id #
  time_zone = var.dbcs.database_time_zone #"Europe/Helsinki"


  lifecycle {
    ignore_changes = [defined_tags, db_home["db_version"],
      fault_domains,
      freeform_tags,
      hostname,
      reco_storage_size_in_gb,
      time_created
    ]
  }
}


resource "oci_database_backup" "dbcs_backup" {
  depends_on   = [oci_database_db_system.dbcs_system]
  count        = var.dbcs.create_dbcs_backup == "true" ? var.dbcs.instance_count : 0
  database_id  = oci_database_db_system.dbcs_system[count.index].db_home[0].database[0].id
  display_name = "${var.dbcs.db_home_display_name}-backup"
}





####### --  to be written    https://docs.oracle.com/en-us/iaas/api/#/en/database/20160918/datatypes/CreateDataGuardAssociationWithNewDbSystemDetails
resource "oci_database_data_guard_association" "dbcs_guard_association" {
  depends_on = [oci_database_db_system.dbcs_system]
  count      = var.dbcs.create_data_guard == "true" ? var.dbcs.instance_count : 0
  #Required
  creation_type           = "NewDbSystem" # The configuration details for creating a Data Guard association for a virtual machine DB system database. For this type of DB system database, the creationType should be NewDbSystem
  database_admin_password = var.dbcs.database_admin_password
  database_id             = oci_database_db_system.dbcs_system[count.index].db_home[0].database[0].id

  delete_standby_db_home_on_delete = "true"
  protection_mode                  = "MAXIMUM_PERFORMANCE" # MAXIMUM_PERFORMANCE MAXIMUM_PROTECTION
  transport_type                   = "ASYNC"

  #Optional
  availability_domain = var.availability_domain.name
  ###backup_network_nsg_ids = var.dbcs.database_nsg_ids #var.data_guard_association_backup_network_nsg_ids
  ## database_software_image_id = "" # oci_database_database_software_image.test_database_software_image.id
  display_name = "dg${var.dbcs.database_display_name}" #var.data_guard_association_display_name
  hostname     = "dg${var.dbcs.database_hostname}"     #var.data_guard_association_hostname
  nsg_ids      = var.dbcs.database_nsg_ids
  ## peer_db_home_id = "" #oci_database_db_home.test_db_home.id
  ## peer_db_system_id ="" # oci_database_db_system.test_db_system.id
  ## peer_vm_cluster_id ="" # oci_database_vm_cluster.test_vm_cluster.id
  shape     = var.dbcs.database_shape     #"VM.Standard2.1" #var.data_guard_association_shape
  subnet_id = var.dbcs.database_subnet_id #oci_core_subnet.test_subnet.id
}


resource "local_file" "sql_dbcs_export" {
  depends_on = [oci_database_db_system.dbcs_system]
  count      = local.instance_count
  content    = <<EOT
  # file created by dbcs-module
  export SYSADMINSQL='sqlplus sys/${var.dbcs.database_admin_password}@${element(local.ip_list, count.index)}:1521/${var.dbcs.database_pdb_name}.${oci_database_db_system.dbcs_system[count.index].domain} as sysdba'
  export HRUSER='sqlplus hr/${var.dbcs.database_user_password}@${element(local.ip_list, count.index)}:1521/${var.dbcs.database_pdb_name}.${oci_database_db_system.dbcs_system[count.index].domain}'
  export HRUSER_PASSWRD='${var.dbcs.database_user_password}'
  export PDBString='${element(local.ip_list, count.index)}:1521/${var.dbcs.database_pdb_name}.${oci_database_db_system.dbcs_system[count.index].domain}'
  EOT
  ##filename   = "config/${element(flatten(list(data.oci_core_vnic.test_vnic.*.public_ip_address)), count.index)}/${element(flatten(list(data.oci_core_vnic.test_vnic.*.public_ip_address)), count.index)}-sql-dbcs_server.sh"
  filename = "config/${element(local.ip_list, count.index)}/${element(local.ip_list, count.index)}-EXPORT"
}


resource "null_resource" "copy-update_oracle_user" {
  depends_on = [oci_database_db_system.dbcs_system]
  count      = local.instance_count
  connection {
    type        = "ssh"
    host        = element(flatten(list(data.oci_core_vnic.test_vnic.*.public_ip_address)), count.index)
    user        = "opc"
    private_key = file("${var.dbcs.bastion_ssh_private_key}") #var.dbcs.database_ssh_public_keys
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

resource "null_resource" "create_hr_data" {
  depends_on = [null_resource.copy-update_oracle_user, local_file.sql_dbcs_export]
  count      = local.instance_count
  connection {
    type        = "ssh"
    host        = element(flatten(list(data.oci_core_vnic.test_vnic.*.public_ip_address)), count.index)
    user        = "oracle"
    private_key = file("${var.dbcs.bastion_ssh_private_key}") #var.dbcs.database_ssh_public_keys
  }

  provisioner "file" {
    source      = "config/${element(local.ip_list, count.index)}/${element(local.ip_list, count.index)}-EXPORT"
    destination = "/home/oracle/EXPORT-env"
  }

  provisioner "file" {
    source      = "${path.module}/scripts/hr.sql"
    destination = "/home/oracle/hr_sql.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /home/oracle/hr_sql.sh",
      "/home/oracle/hr_sql.sh",
    ]
  }

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

 