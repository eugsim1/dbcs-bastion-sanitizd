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

variable "availability_domain" { default = "" }






variable "instance_ocpus" { default = "" }
variable "instance_memory_in_gbs" { default = "" }

variable "ip_adress_backend" { default = "" }
variable "bastion_private_ip" { default = "" }




#variable "opc_key" { default =""}

#variable "oracle_key" { default ="" }


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




variable "compute" {
  type = object({
    subnet_id               = string
    ssh_public_key          = string
    instance_shape          = string
    instance_count          = string
    display_name            = string
    tags                    = map(any)
    need_provisioning       = bool
    label_prefix            = string
    install_node            = bool
    install_nginx           = bool
    bastion_public_ip       = string
    bastion_user            = string
    bastion_ssh_private_key = string
    hostname_label          = string
    shape_config            = map(any)
  })
  description = "bastion settings"
  default = {
    subnet_id      = ""
    ssh_public_key = ""
    instance_shape = ""
    instance_count = ""
    display_name   = ""
    tags = {
      environment = "dev"
      role        = "bastion"
    }
    need_provisioning       = true
    hostname_label          = ""
    label_prefix            = ""
    install_node            = false
    install_nginx           = false
    bastion_public_ip       = ""
    bastion_user            = ""
    bastion_ssh_private_key = ""
    shape_config = {
      memory_in_gbs = "4"
      ocpus         = "1"
    }
  }
}