##### dbcs ####

/*
# Get list of Availability Domains
data "oci_identity_availability_domains" "ADs" {
  compartment_id = var.tenancy_id
}


### correct the var.AD
# Get name of Availability Domains
data "template_file" "deployment_ad" {
  count    = length(data.oci_identity_availability_domains.ADs.availability_domains)
  template = "${lookup(data.oci_identity_availability_domains.ADs.availability_domains[count.index], "name")}"
}
*/

data "oci_identity_fault_domains" "dbcs_fault_domains" {
  #Required
  availability_domain = var.availability_domain.name
  compartment_id      = var.oci_provider.compartment_ocid
}


data "oci_database_db_systems" "db_systems" {
  #Required
  compartment_id = var.oci_provider.compartment_ocid
  state          = "AVAILABLE"
}

# Get DB node list
data "oci_database_db_nodes" "db_nodes" {
  count          = var.dbcs.instance_count
  compartment_id = var.oci_provider.compartment_ocid
  db_system_id   = oci_database_db_system.dbcs_system[count.index].id ### every instance dbcs_system[count.index]
}


# Get DB node details
data "oci_database_db_node" "db_node_details" {
  count      = var.dbcs.instance_count
  db_node_id = lookup(data.oci_database_db_nodes.db_nodes[count.index].db_nodes[0], "id")
}


data "oci_core_vnic" "test_vnic" {
  count   = var.dbcs.instance_count
  vnic_id = data.oci_database_db_node.db_node_details[count.index].vnic_id
}


data "oci_database_database" "dbcs_database" {
  depends_on = [oci_database_db_system.dbcs_system]
  count      = var.dbcs.instance_count
  #Required
  database_id = oci_database_db_system.dbcs_system[count.index].db_home[0].database[0].id
}
