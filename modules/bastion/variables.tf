############ bastion variables
############
############

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
}

variable "bastion" {
  type = object({
    vcn_id          = string
    bastion_enabled = bool
    ssh_public_key  = string
    bastion_shape   = string
    nsg_ids         = list(string)
    tags            = map(any)
    defined_tags    = map(any)
    label_prefix    = string
    hostname_label  = string
    shape_config    = map(any)
    bastion_upgrade = string
    timezone        = string
  })
}


# network parameters

variable "availability_domain" {
  description = "the AD to place the bastion host"
  default     = 1
  type        = number
}

variable "bastion_access" {
  description = "CIDR block in the form of a string to which ssh access to the bastion must be restricted to. *_ANYWHERE_* is equivalent to 0.0.0.0/0 and allows ssh access from anywhere."
  default     = "ANYWHERE"
  type        = string

}

variable "ig_route_id" {
  description = "the route id to the internet gateway"
  type        = string
  default     = ""
}


variable "bastion_image_id" {
  description = "Provide a custom image id for the bastion host or leave as Autonomous."
  default     = "Autonomous"
  type        = string

}




variable "ad_names" { default = "" }



# bastion notification

variable "notification_enabled" {
  description = "Whether to enable ONS notification for the bastion host."
  default     = false
  type        = bool
}

variable "notification_endpoint" {
  description = "The subscription notification endpoint. Email address to be notified."
  default     = null
  type        = string
}

variable "notification_protocol" {
  description = "The notification protocol used."
  default     = "EMAIL"
  type        = string
}

variable "notification_topic" {
  description = "The name of the notification topic"
  default     = "bastion"
  type        = string
}

# tagging
variable "tags" {
  description = "Freeform tags for bastion"
  default = {
    department  = "finance"
    environment = "dev"
    role        = "bastion"
  }
  type = map(any)
}




