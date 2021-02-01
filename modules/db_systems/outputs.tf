/*
output "oci_core_vcn_test_vcn" {
  value = data.oci_core_vcn.test_vcn
}


output "pub_subnets" {
  value = data.oci_core_subnets.pub_subnets.subnets[0].id
}

output "priv_subnets" {
  value = data.oci_core_subnets.priv_subnets.subnets[0].id
}

output "test_subnets" {
  value = data.oci_core_subnets.test_subnets.*
}
*/


output "dbcs_fault_domains" {
  value = data.oci_identity_fault_domains.dbcs_fault_domains.fault_domains
}

output "dbcs_system" {
  value = data.oci_database_db_systems.db_systems
}


output "db_nodes" {
  value = data.oci_database_db_nodes.db_nodes.*
}

output "db_node_details" {
  value = data.oci_database_db_node.db_node_details.*
}

output "test_vnic" {
  value = data.oci_core_vnic.test_vnic.*
}

output "dbcs_settings" {
  value = join(" ", [
    format("create_data_guard:%s\n", var.dbcs.create_data_guard),
    format("create_dbcs_backup:%s\n", var.dbcs.create_dbcs_backup),
    format("Availabilty domain:%s\n", var.availability_domain.name),
    format("dbcs.is_dbcs_public:%s\n", var.dbcs.is_dbcs_public),
    format("dbcs.database_fault_domains:%s\n", var.dbcs.database_fault_domains[0])
  ])

}


output "dbcs_database" {
  value = data.oci_database_database.dbcs_database
}