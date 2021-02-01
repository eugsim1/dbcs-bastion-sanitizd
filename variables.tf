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




####### --variable "loadbalancer" {
####### --  type              = object({
####### --    display_name    = string,
####### --    compartment_ocid  = string,
####### --    shape           = string,
####### --    subnet_ids      = list(string),
####### --    private         = bool,
####### --	ip_mode         = string,
####### --    nsg_ids         = list(string),
####### --	maximum_bandwidth_in_mbps = string,
####### --	minimum_bandwidth_in_mbps = string,
####### --    defined_tags    = map(string),
####### --    freeform_tags   = map(string)
####### --  })
####### --  description       = "Parameters for customizing the LB."
####### --  default           = {
####### --    display_name    = null
####### --    compartment_ocid  = null
####### --    shape           = null
####### --    subnet_ids      = null
####### --    private         = null
####### --    nsg_ids         = null
####### --    defined_tags    = null
####### --    freeform_tags   = null
####### --	ip_mode        = null
####### --	maximum_bandwidth_in_mbps = null
####### --	minimum_bandwidth_in_mbps = null
####### --  }
####### --}


#### general variables 

# Identity and access parameters
variable "fingerprint" {
  description = "Fingerprint of oci api private key."
  type        = string
}

variable "private_key_path" {
  description = "The path to oci api private key."
  type        = string
}

variable "region" {
  # List of regions: https://docs.cloud.oracle.com/iaas/Content/General/Concepts/regions.htm#ServiceAvailabilityAcrossRegions
  description = "The oci region where resources will be created."
  type        = string
}

variable "tenancy_ocid" {
  description = "The tenancy id in which to create the sources."
  type        = string
}

variable "user_ocid" {
  description = "The id of the user that terraform will use to create the resources."
  type        = string
}


variable "vnc_display_name" { default = "" }
variable "privreg_display_name" { default = "" }
variable "pubreg_display_name" { default = "" }

variable "vnc_cidr_block" { default = "" }
variable "pubreg_pubreg" { default = "" }
variable "pubreg_cidr_block" { default = "" }
variable "pubsb1_cidr_block" { default = "" }

variable "compartment_ocid" { default = "" }


variable "ad" { default = "" }
variable "ssh_public_key" {}
variable "bastion_shape" {}
variable "use_compute" { default = "" }



variable "instance_count" {}
variable "display_name" {}
variable "need_provisioning" {}
variable "instance_ocpus" { default = "" }
variable "instance_memory_in_gbs" { default = "" }
variable "ip_adress_backend" { default = "" }
variable "bastion_user" { default = "" }
variable "bastion_ssh_private_key" { default = "" }
variable "bastion_hostname_label" { default = "" }
variable "bastion_timezone" { default = "" }
variable "bastion_upgrade" {}
variable "use_bastion" {}

variable "use_lb" { default = false }
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


variable "dns_compartment_id" { default = "" }
variable "dns_domain" { default = "" }
variable "dns_rdata" { default = "" }
variable "dns_zone_name_or_id" { default = "" }



variable "use_dbcs" { default = "" }
variable "dbcs_instance_count" { default = "" }
variable "is_dbcs_public" { default = "" }
variable "create_dbcs_backup" { default = "" }
variable "create_data_guard" { default = "" }
variable "database_database_edition" { default = "" }
variable "database_admin_password" { default = "" }
variable "database_user_password" { default = "" }
variable "database_backup_tde_password" { default = "" }
variable "database_character_set" { default = "" }
variable "db_backup_config_auto_backup_enabled" { default = "" }
variable "db_backup_config_auto_backup_window" { default = "" }
variable "database_db_name" { default = "" }
variable "database_db_workload" { default = "" }
variable "database_ncharacter_set" { default = "" }
variable "database_pdb_name" { default = "" }
variable "database_tde_wallet_password" { default = "" }
variable "db_home_db_version" { default = "" }
variable "database_hostname" { default = "" }
variable "database_shape" { default = "" }
variable "database_cpu_core_count" { default = "" }
variable "database_data_storage_percentage" { default = "" }
variable "database_data_storage_size_in_gb" { default = "" }
variable "db_system_options_storage_management" { default = "" }
variable "database_time_zone" { default = "" }
variable "database_sparse_diskgroup" { default = "" }
variable "database_source" { default = "" }
