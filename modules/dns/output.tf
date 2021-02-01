output "dns_loadbalancer" {
  value = oci_dns_rrset.multi_dns.*
}



data "oci_dns_zones" "all_zones" {
  compartment_id = "ocid1.compartment.oc1..aaaaaaaaoctz26zocbcicfpxxmxbmmzyxa4kbweepqkeg6akuwqjuehw4bta" #var.oci_provider.compartment_ocid
  /*
    #Optional
    name = var.zone_name
    name_contains = var.zone_name_contains
    scope = var.zone_scope
    state = var.zone_state
    time_created_greater_than_or_equal_to = var.zone_time_created_greater_than_or_equal_to
    time_created_less_than = var.zone_time_created_less_than
    view_id = oci_dns_view.test_view.id
    zone_type = var.zone_zone_type
*/
}


output "all_zones" {
  value = data.oci_dns_zones.all_zones
}

