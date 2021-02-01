

data "oci_core_images" "bastion_images" {
  compartment_id           = var.oci_provider.compartment_ocid
  operating_system         = "Oracle Linux"
  operating_system_version = "7.9"
  sort_by                  = "TIMECREATED"
  /*
  shape                    = var.bastion_shape
  
  */
}

