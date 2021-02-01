###
### CloudSecWorkshop ocid1.compartment.oc1..aaaaaaaaoctz26zocbcicfpxxmxbmmzyxa4kbweepqkeg6akuwqjuehw4bta
###
########## CloudSecWorkshop ocid1.compartment.oc1..aaaaaaaaoctz26zocbcicfpxxmxbmmzyxa4kbweepqkeg6akuwqjuehw4bta
########## DataSafeWorkshop ocid1.compartment.oc1..aaaaaaaakflr6popkgcfxehemfvkbuhdjhra67v5rilxiut332jofgzjpclq
########## Workshops ocid1.compartment.oc1..aaaaaaaakjdnf7ik2kejcaj73uwx6tsochnlq5olj3vebgbwcf67bjnab3ya
########## 
########## Workshops
########## oraclecloudpursuitlabs.com ocid1.dns-zone.oc1..83a5c2de2fda43dfb255c99dca23bb1c
########## CloudSecWorkshop
########## mycloudip.tk	Primary	ocid1.dns-zone.oc1..48a33377ffaf44d296d40ef65a2c1267
########## cloudwaaf.tk	Primary	ocid1.dns-zone.oc1..cff9b583010d4f3e827a34fc3a7e52e2	
########## secemeateam.tk	Primary	ocid1.dns-zone.oc1..bf0b2b57fb08472c9b8eda05040faf28
########## nodenginx.tk ocid1.dns-zone.oc1..18af76486b344166b9990be5a25f1bec
########## cloudtestdrive.tk ocid1.dns-zone.oc1..0863788d175445e6a0270705ca13faaa
########## aliascloud.tk ocid1.dns-zone.oc1..e6def584bb3043dc9f19bdcf8f27e58c
########## cloudsec.tk ocid1.dns-zone.oc1..1de56f84ab864981bb8ec9d8a6719f06

#dns_compartment_id= "ocid1.compartment.oc1..aaaaaaaaoctz26zocbcicfpxxmxbmmzyxa4kbweepqkeg6akuwqjuehw4bta"
#dns_domain= "load-balancer.secemeateam.tk"
##dns_rdata= ""
#dns_zone_name_or_id= "ocid1.dns-zone.oc1..cff9b583010d4f3e827a34fc3a7e52e2"


variable "dns_server_config" {
  description = "load balancer hostname"
  type        = map(any)
  default = {
    hostname-1 = {
      compartment_id  = "ocid1.compartment.oc1..aaaaaaaaoctz26zocbcicfpxxmxbmmzyxa4kbweepqkeg6akuwqjuehw4bta",
      domain          = "load-balancer.secemeateam.tk"
      zone_name_or_id = "ocid1.dns-zone.oc1..bf0b2b57fb08472c9b8eda05040faf28"
    },
    hostname-2 = {
      compartment_id  = "ocid1.compartment.oc1..aaaaaaaaoctz26zocbcicfpxxmxbmmzyxa4kbweepqkeg6akuwqjuehw4bta",
      domain          = "load-balancer.cloudwaaf.tk"
      zone_name_or_id = "ocid1.dns-zone.oc1..cff9b583010d4f3e827a34fc3a7e52e2"
    },
    hostname-3 = {
      compartment_id  = "ocid1.compartment.oc1..aaaaaaaaoctz26zocbcicfpxxmxbmmzyxa4kbweepqkeg6akuwqjuehw4bta",
      domain          = "load-balancer.mycloudip.tk"
      zone_name_or_id = "ocid1.dns-zone.oc1..48a33377ffaf44d296d40ef65a2c1267"
    },
    hostname-4 = {
      compartment_id  = "ocid1.compartment.oc1..aaaaaaaakjdnf7ik2kejcaj73uwx6tsochnlq5olj3vebgbwcf67bjnab3ya",
      domain          = "load-balancer.oraclecloudpursuitlabs.com"
      zone_name_or_id = "ocid1.dns-zone.oc1..83a5c2de2fda43dfb255c99dca23bb1c"
    },
    hostname-5 = {
      compartment_id  = "ocid1.compartment.oc1..aaaaaaaaoctz26zocbcicfpxxmxbmmzyxa4kbweepqkeg6akuwqjuehw4bta",
      domain          = "load-balancer.nodenginx.tk"
      zone_name_or_id = "ocid1.dns-zone.oc1..18af76486b344166b9990be5a25f1bec"
    },
    hostname-6 = {
      compartment_id  = "ocid1.compartment.oc1..aaaaaaaaoctz26zocbcicfpxxmxbmmzyxa4kbweepqkeg6akuwqjuehw4bta",
      domain          = "load-balancer.cloudtestdrive.tk"
      zone_name_or_id = "ocid1.dns-zone.oc1..0863788d175445e6a0270705ca13faaa"
    },
    hostname-7 = {
      compartment_id  = "ocid1.compartment.oc1..aaaaaaaaoctz26zocbcicfpxxmxbmmzyxa4kbweepqkeg6akuwqjuehw4bta",
      domain          = "load-balancer.aliascloud.tk"
      zone_name_or_id = "ocid1.dns-zone.oc1..e6def584bb3043dc9f19bdcf8f27e58c"
    },
    hostname-8 = {
      compartment_id  = "ocid1.compartment.oc1..aaaaaaaaoctz26zocbcicfpxxmxbmmzyxa4kbweepqkeg6akuwqjuehw4bta",
      domain          = "load-balancer.cloudsec.tk"
      zone_name_or_id = "ocid1.dns-zone.oc1..1de56f84ab864981bb8ec9d8a6719f06"
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


/*
resource oci_dns_rrset "lb" {
  compartment_id = "ocid1.compartment.oc1..aaaaaaaaoctz26zocbcicfpxxmxbmmzyxa4kbweepqkeg6akuwqjuehw4bta" ### var.dns_compartment_id
  domain =     "load-balancer.secemeateam.tk" ###  var.dns_domain   ###
  rtype = "A"  
  items {
    domain =  "load-balancer.secemeateam.tk" ###  var.dns_domain   ###
    rdata = var.dns_rdata ###"193.122.12.61"
    rtype = "A"
    ttl = 30	
  }

  #scope = <<Optional value not found in discovery>>
  #view_id = <<Optional value not found in discovery>>
  zone_name_or_id = "ocid1.dns-zone.oc1..bf0b2b57fb08472c9b8eda05040faf28" ### var.dns_zone_name_or_id ###"ocid1.dns-zone.oc1..83a5c2de2fda43dfb255c99dca23bb1c" ##oci_dns_zone.oraclecloudpursuitlabs.com
}

resource oci_dns_rrset "lb_oraclecloudpursuitlabs" {
  compartment_id = "ocid1.compartment.oc1..aaaaaaaakjdnf7ik2kejcaj73uwx6tsochnlq5olj3vebgbwcf67bjnab3ya" ### var.dns_compartment_id
  domain =     "load-balancer.oraclecloudpursuitlabs.com" ###  var.dns_domain   ###
  rtype = "A"  
  items {
    domain =  "load-balancer.oraclecloudpursuitlabs.com" ###  var.dns_domain   ###
    rdata = var.dns_rdata ###"193.122.12.61"
    rtype = "A"
    ttl = 30	
  }

  #scope = <<Optional value not found in discovery>>
  #view_id = <<Optional value not found in discovery>>
  zone_name_or_id = ocid1.dns-zone.oc1..83a5c2de2fda43dfb255c99dca23bb1c ### var.dns_zone_name_or_id ###"ocid1.dns-zone.oc1..83a5c2de2fda43dfb255c99dca23bb1c" ##oci_dns_zone.oraclecloudpursuitlabs.com
}


resource "oci_dns_rrset" "test_rrset" {
     depends_on = [ oci_waas_waas_policy.waf_policy ]
	 count      = var.instance_count ######
    #Required
    domain = "student${count.index}-waf.${var.labs_domain}"
    rtype = "CNAME"
    zone_name_or_id = var.labs_domain

    #Optional
    compartment_id = var.dns_compartment_id ### compartement Workshop
    items {
        #Required
        domain = "student${count.index}-waf.${var.labs_domain}"
        rdata = element(flatten(list(oci_waas_waas_policy.waf_policy.*.cname)), count.index)
        rtype = "CNAME"
        ttl = 30
    }
    ##scope = var.rrset_scope
    ##view_id = oci_dns_view.test_view.id
}
*/