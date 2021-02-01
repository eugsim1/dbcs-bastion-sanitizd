########## dbcs vars ##############

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


variable "dbcs" {
  type = object({
    #availability_domain  = string
    instance_count          = string
    database_admin_password = string
    #Optional
    database_backup_id                  = string
    database_backup_tde_password        = string
    database_character_set              = string
    database_database_id                = string
    database_database_software_image_id = string
    #Optional
    db_backup_config_auto_backup_enabled = string
    db_backup_config_auto_backup_window  = string
    #Optional
    backup_destination_details_id                  = string
    backup_destination_details_type                = string
    db_backup_config_recovery_window_in_days       = string
    database_db_domain                             = string
    database_db_name                               = string
    database_db_workload                           = string
    database_defined_tags                          = map(any)
    database_freeform_tags                         = map(any)
    database_ncharacter_set                        = string
    database_pdb_name                              = string
    database_tde_wallet_password                   = string
    database_time_stamp_for_point_in_time_recovery = string
    #Optional
    db_home_database_software_image_id = string
    db_home_db_version                 = string
    db_home_defined_tags               = map(any)
    db_home_display_name               = string
    freeform_tags                      = map(any)
    database_hostname                  = string
    database_shape                     = string
    database_ssh_public_keys           = list(string)
    database_subnet_id                 = string
    #Optional
    database_backup_network_nsg_ids  = list(string)
    database_backup_subnet_id        = string
    database_cluster_name            = string
    database_cpu_core_count          = string
    database_data_storage_percentage = string
    database_data_storage_size_in_gb = string
    database_database_edition        = string
    #Optional
    db_system_options_storage_management = string
    db_system_defined_tags               = map(any)
    database_disk_redundancy             = string
    database_display_name                = string
    database_domain                      = string
    database_fault_domains               = list(string)
    db_system_freeform_tags              = map(any) ### {"Department"= "Finance"}
    database_kms_key_id                  = string
    database_kms_key_version_id          = string
    database_license_model               = string
    #Optional
    maintenance_window_details_days_of_week_name  = string
    maintenance_window_details_hours_of_day       = list(string)
    maintenance_window_details_lead_time_in_weeks = string
    #Optional
    maintenance_window_details_months_name    = string
    maintenance_window_details_preference     = string
    maintenance_window_details_weeks_of_month = list(string)

    database_node_count          = string
    database_nsg_ids             = list(string)
    database_private_ip          = string
    database_source              = string
    database_source_db_system_id = string
    database_sparse_diskgroup    = string
    database_time_zone           = string
  })
}


variable "opc_key" {
  type = map(any)
  ## opc_key.public_key_openssh
  ## opc_key.private_key_pem  
}

variable "oracle_key" {
  type = map(any)
  ## oracle_key.public_key_openssh
  ## oracle_key.private_key_pem

}


variable "availability_domain" { default = "" }

variable "compartment_id" { default = "" }


# provider identity parameters
variable "fingerprint" { default = "" }

variable "private_key_path" { default = "" }

variable "region" {
  type = string
}

variable "tenancy_id" { default = "" }

variable "user_ocid" { default = "" }

variable "tenancy_ocid" {
  default = ""
}



variable "compartment_ocid" {
  default = ""
}

variable "instance_count" {
  default = ""
}


variable "instance_name" {
  default = ""
}


variable "instance_state" {
  default = ""
}


variable "subnet_id" {
  default = ""
}

variable "source_id" {
  default = ""
}


variable "fault_domain" {
  default = ""
}


variable "ssh_authorized_keys" {
  default = ""
}

variable "private_key" {
  default = ""
}

variable "domain_name" {
  default = ""
}

variable "db_admin_password" {
  default = ""
}
variable "db_name" {
  default = ""
}
variable "db_character_set" {
  default = ""
}
variable "db_ncharacter_set" {
  default = ""
}
variable "db_workload" {
  default = ""
}
variable "db_pdb_name" {
  default = ""
}
variable "db_version" {
  default = ""
}
variable "db_system_options_storage_management" {
  default = ""
}
variable "db_disk_redundancy" {
  default = ""
}
variable "db_system_shape" {
  default = ""
}
variable "db_ssh_public_key" {
  default = ""
}
variable "db_data_storage_size_in_gb" {
  default = ""
}
variable "db_license_model" {
  default = ""
}
variable "db_label_prefix" {
  default = ""
}
variable "db_time_zone" {
  default = ""
}

variable "label_prefix" {
  default = ""
}

variable "vcn_id" {
  default = ""
}

variable "ig_route_id" {
  default = ""
}

#variable "db_edition" {}
#variable "db_home_display_name" {}
#variable "hostname" {}
#variable "db_system_display_name" {}

####### -- variable "project_defined_tags" {
####### --   type = map
####### -- }



variable "db_tags" {
  type = map(any)
  default = {
    "Project"     = "omc"
    "Role"        = "Bastion for omc"
    "Comment"     = "Bastion setup for omc project"
    "Version"     = "0.0.0.0"
    "Responsible" = "put the name here"
  }
}

