variable "dns_compartment_id" { default = "" }
variable "dns_domain" { default = "" }
variable "dns_rdata" { default = "" }
variable "dns_zone_name_or_id" { default = "" }



variable "oci_provider" {
  type = object({
    fingerprint      = string
    private_key_path = string
    region           = string
    tenancy_id       = string
    user_id          = string
    compartment_ocid = string
  })
  description = "oci settings"
  default = {
    fingerprint      = ""
    private_key_path = ""
    region           = ""
    tenancy_id       = ""
    user_id          = ""
    compartment_ocid = ""
  }
}
