


variable "dns_server_config" {
  description = "load balancer hostname"
  type        = map(any)
  default = {
    hostname-1 = {
      compartment_id  = " ",
      domain          = "load-balancer.secemeateam.tk"
      zone_name_or_id = ""
    },
    hostname-2 = {
      compartment_id  = "",
      domain          = "load-balancer.cloudwaaf.tk"
      zone_name_or_id = """
    },
    hostname-3 = {
      compartment_id  = "",
      domain          = "load-balancer.mycloudip.tk"
      zone_name_or_id = ""
    },
    hostname-4 = {
      compartment_id  = "",
      domain          = "load-balancer.oraclecloudpursuitlabs.com"
      zone_name_or_id = ""
    },
    hostname-5 = {
      compartment_id  = "",
      domain          = "load-balancer.nodenginx.tk"
      zone_name_or_id = ""
    },
    hostname-6 = {
      compartment_id  = "",
      domain          = "load-balancer.cloudtestdrive.tk"
      zone_name_or_id = ""
    },
    hostname-7 = {
      compartment_id  = "",
      domain          = "load-balancer.aliascloud.tk"
      zone_name_or_id = ""
    },
    hostname-8 = {
      compartment_id  = "",
      domain          = "load-balancer.cloudsec.tk"
      zone_name_or_id = ""
    }
  }

}

resource "oci_dns_rrset" "multi_dns" {
  for_each       = var.dns_server_config
  compartment_id = each.value.compartment_id
  domain         = each.value.domain
  rtype          = "A"
  items {
    domain = each.value.domain
    rdata  = var.dns_rdata ###"193.122.12.61"
    rtype  = "A"
    ttl    = 30
  }

  #scope = <<Optional value not found in discovery>>
  #view_id = <<Optional value not found in discovery>>
  zone_name_or_id = each.value.zone_name_or_id
}



