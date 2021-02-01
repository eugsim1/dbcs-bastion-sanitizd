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


### network module

variable "fingerprint" {
  description = "Fingerprint of oci api private key."
  default     = ""
}

variable "private_key_path" {
  description = "The path to oci api private key."
  default     = ""
}

variable "region" {
  # List of regions: https://docs.cloud.oracle.com/iaas/Content/General/Concepts/regions.htm#ServiceAvailabilityAcrossRegions
  description = "The oci region where resources will be created."
  default     = ""
}

variable "tenancy_ocid" {
  description = "The tenancy id in which to create the sources."
  default     = ""
}

variable "user_ocid" {
  description = "The id of the user that terraform will use to create the resources."
  default     = ""
}


variable "compartment_ocid" { default = "" }
variable "ad" { default = "" }



variable "network_settings" {
  type = object({
    vnc_display_name     = string
    vnc_cidr_block       = string
    privreg_cidr_block   = string
    pubsb2_cidr_block    = string
    lb_pub_cidr_block    = string
    privreg_display_name = string
    pubreg_display_name  = string
    compartment_ocid     = string
    pubreg_cidr_block    = string
    pubsb1_cidr_block    = string

  })
  description = "network module settings"
  default = {
    vnc_display_name     = ""
    vnc_cidr_block       = ""
    privreg_cidr_block   = ""
    pubsb2_cidr_block    = ""
    lb_pub_cidr_block    = ""
    privreg_display_name = ""
    pubreg_display_name  = ""
    compartment_ocid     = ""
    pubreg_cidr_block    = ""
    pubsb1_cidr_block    = ""
  }
}


/*
variable "oci_base_provider" {
  type = object({
    api_fingerprint      = string
    api_private_key_path = string
    region               = string
    tenancy_id           = string
    user_id              = string
  })
  description = "oci provider parameters"
}


variable  oci_base_general  {
    type = object({
    compartment_id        = string
    root_compartment_id   = string
	})
  }



# networking parameters

variable "oci_base_vcn" {
  type = object({
    internet_gateway_enabled = bool
    nat_gateway_enabled      = bool
    service_gateway_enabled  = bool
    tags                     = map(any)
    vcn_cidr                 = string
    vcn_dns_label            = string
    vcn_name                 = string
	vcn_display_name         = string
	priv_name                = string
	pub_name                 = string
	
  })
  description = "VCN parameters"
  default = {
    internet_gateway_enabled = true
    nat_gateway_enabled      = true
    service_gateway_enabled  = true
    tags                     = null
    vcn_cidr                 = "10.0.0.0/16"
    vcn_dns_label            = ""
    vcn_name                 = ""
	vcn_display_name         = ""
	priv_name                = ""
	pub_name                 = ""
	
  }
}


*/