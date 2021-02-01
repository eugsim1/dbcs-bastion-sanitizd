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


variable "loadbalancer" {
  type = object({
    display_name              = string,
    compartment_ocid          = string,
    shape                     = string,
    subnet_ids                = list(string),
    private                   = bool,
    ip_mode                   = string,
    nsg_ids                   = list(string),
    maximum_bandwidth_in_mbps = string,
    minimum_bandwidth_in_mbps = string,
    defined_tags              = map(string),
    freeform_tags             = map(string)
  })
  description = "Parameters for customizing the LB."
  default = {
    display_name              = null
    compartment_ocid          = null
    shape                     = null
    subnet_ids                = null
    private                   = null
    nsg_ids                   = null
    defined_tags              = null
    freeform_tags             = null
    ip_mode                   = null
    maximum_bandwidth_in_mbps = null
    minimum_bandwidth_in_mbps = null
  }
}

variable "availability_domain" { default = "" }

variable "subnet_id" { default = "" }
variable "ip_adress_backend" { default = "" }

variable "instance_count" { default = "" }


variable "lb_shape" { default = "" }
variable "lb_display_name" { default = "" }
variable "is_lb_private" { default = "" }
variable "lb_name_bakend_set" { default = "" }
variable "lb_policy" { default = "" }
variable "lb_health_port" { default = "" }
variable "lb_protocol" { default = "" }



variable "lb_ca_certificate" { default = "" }
variable "lb_certificate_name" { default = "" }
variable "lb_certificate_priv_key" { default = "" }
variable "lb_public_certificate" { default = "" }

variable "lb_httplistener" { default = "" }
variable "lbhttplisterner_port" { default = "" }

variable "lb_httpslistener" { default = "" }
