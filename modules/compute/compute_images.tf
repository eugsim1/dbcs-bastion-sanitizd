# get latest Oracle Linux 7.9 image
data "oci_core_images" "oracle" {
  compartment_id           = var.oci_provider.compartment_ocid
  operating_system         = "Oracle Linux"
  operating_system_version = "7.9"
  filter {
    name   = "display_name"
    values = ["^([a-zA-z]+)-([a-zA-z]+)-([\\.0-9]+)-([\\.0-9-]+)$"]
    regex  = true
  }
}

output "oracle_image" {
  value = data.oci_core_images.oracle.images.0.display_name
}

output "oracle_image_id" {
  value = data.oci_core_images.oracle.images.0.id
}