
resource "local_file" "ansible_hosts" {
  count      = var.dbcs.is_dbcs_public == "true" ? 1 : 0
  depends_on = [oci_database_db_system.dbcs_system]
  content = "[servers]${join(
    "    ",
    formatlist(
      "\n %s %s",
      data.oci_core_vnic.test_vnic.*.public_ip_address,
    " ansible_user=opc ansible_ssh_private_key_file=priv.txt"),
  )}"
  filename = "config/hosts"
}

locals {
  instance_count = var.dbcs.is_dbcs_public == "true" ? var.dbcs.instance_count : 0
  ip_list        = (local.instance_count > 0) ? flatten(list(data.oci_core_vnic.test_vnic.*.public_ip_address)) : [""]
}

resource "local_file" "ssh_priv_key" {
  depends_on      = [oci_database_db_system.dbcs_system]
  count           = local.instance_count             #var.dbcs.is_dbcs_public == "true" ? var.dbcs.instance_count : 0
  content         = file("wls-wdt-testkey-priv.txt") ##file("priv.txt")
  file_permission = "0700"
  ##filename        = "config/${element(flatten(list(data.oci_core_vnic.test_vnic.*.public_ip_address)), count.index)}/priv.txt"
  filename = "config/${element(local.ip_list, count.index)}/priv.txt"
}

resource "local_file" "ssh_dbcs_url" {
  depends_on = [oci_database_db_system.dbcs_system]
  count      = local.instance_count #var.dbcs.is_dbcs_public == "true" ? var.dbcs.instance_count : 0 
  content    = <<EOT
  # file created by dbcs-module
  ssh -i priv.txt   opc@${element(local.ip_list, count.index)} ##
  EOT

  ##filename   = "config/${element(flatten(list(data.oci_core_vnic.test_vnic.*.public_ip_address)), count.index)}/${element(flatten(list(data.oci_core_vnic.test_vnic.*.public_ip_address)), count.index)}-ssh-dbcs_server.sh"
  filename = "config/${element(local.ip_list, count.index)}/${element(local.ip_list, count.index)}-ssh-dbcs_server.sh"
}

resource "local_file" "sql_dbcs_url" {
  depends_on = [oci_database_db_system.dbcs_system]
  count      = local.instance_count #var.dbcs.is_dbcs_public == "true" ? var.dbcs.instance_count : 0 
  content    = <<EOT
  # file created by dbcs-module
  sqlplus sys/${var.dbcs.database_admin_password}@${element(local.ip_list, count.index)}:1521/${oci_database_db_system.dbcs_system[count.index].db_home[0].database[0].db_unique_name}.${oci_database_db_system.dbcs_system[count.index].domain}  as sysdba
  EOT
  ##filename   = "config/${element(flatten(list(data.oci_core_vnic.test_vnic.*.public_ip_address)), count.index)}/${element(flatten(list(data.oci_core_vnic.test_vnic.*.public_ip_address)), count.index)}-sql-dbcs_server.sh"
  filename = "config/${element(local.ip_list, count.index)}/${element(local.ip_list, count.index)}-sql-dbcs_server.sh"
}

/*
resource "local_file" "sql_datasafe_url" {
  depends_on = [oci_database_db_system.dbcs_system]
  count      = local.instance_count  #var.dbcs.is_dbcs_public == "true" ? var.dbcs.instance_count : 0
  content    = <<EOT
  # file created by dbcs-module
  sqlplus DATASAFE_ADMIN/'WElcome1412#!'@${element(local.ip_list, count.index)}:1521/${oci_database_db_system.dbcs_system[count.index].db_unique_name}.${oci_database_db_system.dbcs_system[count.index].domain}
  EOT
  filename   = "config/${element(flatten(list(data.oci_core_vnic.test_vnic.*.public_ip_address)), count.index)}/${element(flatten(list(data.oci_core_vnic.test_vnic.*.public_ip_address)), count.index)}-sql-DATASAFE_ADMIN_server.sh"
}
*/
resource "local_file" "sql_oe_url" {
  depends_on = [oci_database_db_system.dbcs_system]
  count      = local.instance_count #var.dbcs.is_dbcs_public == "true" ? var.dbcs.instance_count : 0
  content    = <<EOT
  # file created by dbcs-module
  sqlplus oe/'WElcome1412#!'@${element(local.ip_list, count.index)}:1521/${var.dbcs.database_pdb_name}.${oci_database_db_system.dbcs_system[count.index].domain}
  EOT
  filename   = "config/${element(local.ip_list, count.index)}/${element(local.ip_list, count.index)}-sql-oe_server.sh"
}




resource "local_file" "sql_hr_url" {
  depends_on = [oci_database_db_system.dbcs_system]
  count      = local.instance_count #var.dbcs.is_dbcs_public == "true" ? var.dbcs.instance_count : 0
  content    = <<EOT
  # file created by dbcs-module
  sqlplus hr/'WElcome1412#!'@${element(local.ip_list, count.index)}:1521/${var.dbcs.database_pdb_name}.${oci_database_db_system.dbcs_system[count.index].domain}
  EOT
  filename   = "config/${element(local.ip_list, count.index)}/${element(local.ip_list, count.index)}-sql-hr_server.sh"
}