##### dbcs ####

data "oci_identity_availability_domains" "ad_list" {
  compartment_id = var.tenancy_ocid
}


data "oci_identity_availability_domain" "ad1" {
  compartment_id = var.tenancy_ocid
  ad_number      = 1
}

data "oci_identity_availability_domain" "ad2" {
  compartment_id = var.tenancy_ocid
  ad_number      = 2
}

data "oci_identity_availability_domain" "ad3" {
  compartment_id = var.tenancy_ocid
  ad_number      = 3
}

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
