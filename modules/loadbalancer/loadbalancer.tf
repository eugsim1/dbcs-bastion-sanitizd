/* Load Balancer */
## https://registry.terraform.io/providers/hashicorp/oci/latest/docs/resources/load_balancer_load_balancer

resource "oci_load_balancer" "load_balancer" {
  shape          = var.loadbalancer.shape ###  
  compartment_id = var.loadbalancer.compartment_ocid
  subnet_ids     = var.loadbalancer.subnet_ids
  display_name   = var.loadbalancer.display_name ##"load_balancer"
  ip_mode        = var.loadbalancer.ip_mode      ##"IPV4"
  is_private     = var.loadbalancer.private      ###"true"
  shape_details {
    maximum_bandwidth_in_mbps = var.loadbalancer.maximum_bandwidth_in_mbps ## var.load_balancer_shape_details_maximum_bandwidth_in_mbps
    minimum_bandwidth_in_mbps = var.loadbalancer.minimum_bandwidth_in_mbps ## er_shape_details_minimum_bandwidth_in_mbps
  }
}

variable "oci_load_balancer_hostname" {
  description = "load balancer hostname"
  type        = map(any)
  default = {
    hostname-1 = {
      hostname = "*.oraclecloudpursuitlabs.com",
      name     = "oraclecloudpursuitlabs",
      domain   = "oraclecloudpursuitlabs.com"
    },
    hostname-2 = {
      hostname = "*.mycloudip.tk",
      name     = "mycloudip",
      domain   = "mycloudip.tk"
    },
    hostname-3 = {
      hostname = "*.cloudwaaf.tk",
      name     = "cloudwaaf",
      domain   = "cloudwaaf.tk"
    },
    hostname-4 = {
      hostname = "*.secemeateam.tk",
      name     = "secemeateam",
      domain   = "secemeateam.tk"
    },
    hostname-5 = {
      hostname = "*.cloudsec.tk",
      name     = "cloudsec",
      domain   = "cloudsec.tk"
    },
    hostname-6 = {
      hostname = "*.aliascloud.tk",
      name     = "aliascloud",
      domain   = "aliascloud.tk"
    },
    hostname-7 = {
      hostname = "*.cloudtestdrive.tk",
      name     = "cloudtestdrive",
      domain   = "cloudtestdrive.tk"
    },
    hostname-8 = {
      hostname = "*.nodenginx.tk",
      name     = "nodenginx",
      domain   = "nodenginx.tk"
    }
  }



}

### https://docs.oracle.com/en-us/iaas/Content/Balance/Tasks/managingrequest.htm
resource "oci_load_balancer_hostname" "hostname_lb" {
  for_each = var.oci_load_balancer_hostname

  hostname         = each.value.hostname ###var.hostname_hostname
  load_balancer_id = oci_load_balancer.load_balancer.id
  name             = each.value.name ###var.hostname_name

  lifecycle {
    create_before_destroy = true
  }
}

resource "oci_load_balancer_backend_set" "load_balancer_backend_set" {
  count            = var.instance_count
  load_balancer_id = oci_load_balancer.load_balancer.id
  name             = "lb-backend_set-${count.index}"
  policy           = "ROUND_ROBIN"
  health_checker {
    interval_ms         = "10000"
    port                = "0"
    protocol            = "HTTP" ###var.lb_protocol ##"HTTP"
    response_body_regex = ""
    retries             = "3"
    return_code         = "200"
    timeout_in_millis   = "3000"
    url_path            = "/"
  }

  lb_cookie_session_persistence_configuration {
    cookie_name = "LB_COOKIE"
    #disable_fallback = <<Optional value not found in discovery>>
    #domain = <<Optional value not found in discovery>>
    is_http_only = "true"
    is_secure    = "false" ###"true"
    #max_age_in_seconds = <<Optional value not found in discovery>>
    path = "/"
  }

}

locals {
  name_lb = values(oci_load_balancer_hostname.hostname_lb)[*].name
}

resource "oci_load_balancer_listener" "lb-httpslistener" {
  depends_on = [oci_load_balancer_certificate.all_certificates]
  count      = length(local.name_lb)
  ##  for_each = var.oci_load_balancer_hostname
  default_backend_set_name = oci_load_balancer_backend_set.load_balancer_backend_set[0].name
  load_balancer_id         = oci_load_balancer.load_balancer.id
  name                     = format("%s_%s", element(local.name_lb, count.index), "_HTTPS")

  hostname_names = [element(local.name_lb, count.index)]
  port           = 443 #var.lbhttplisterner_port ##80
  protocol       = "HTTP"

  connection_configuration {
    idle_timeout_in_seconds = "2"
  }
  ssl_configuration {
    #Required
    certificate_name        = element(local.name_lb, count.index)
    verify_peer_certificate = false
  }
}



resource "oci_load_balancer_listener" "lb-httplistener" {
  for_each                 = var.oci_load_balancer_hostname
  load_balancer_id         = oci_load_balancer.load_balancer.id
  name                     = format("%s_%s", each.value.name, "_HTTP")
  default_backend_set_name = oci_load_balancer_backend_set.load_balancer_backend_set[0].name
  hostname_names           = [each.value.name]
  port                     = 80 #var.lbhttplisterner_port ##80
  protocol                 = "HTTP"
  //rule_set_names           = [oci_load_balancer_rule_set.test_rule_set.name]
  connection_configuration {
    idle_timeout_in_seconds = "2"
  }
}


resource "oci_load_balancer_certificate" "all_certificates" {
  for_each           = var.oci_load_balancer_hostname
  load_balancer_id   = oci_load_balancer.load_balancer.id
  certificate_name   = each.value.name
  ca_certificate     = file(format("%s%s%s", "certificates/", each.value.domain, "/fullchain1.pem"))
  private_key        = file(format("%s%s%s", "certificates/", each.value.domain, "/privkey1.pem"))
  public_certificate = file(format("%s%s%s", "certificates/", each.value.domain, "/fullchain1.pem"))
  lifecycle {
    create_before_destroy = true
  }
}



/*
resource "oci_load_balancer_path_route_set" "test_path_route_set" {
  #Required
  load_balancer_id = oci_load_balancer.load_balancer.id
  name             = "pr-set1"
  path_routes {
    #Required
    backend_set_name = oci_load_balancer_backend_set.lb-bes1.name
    path             = "/example/video/123"
    path_match_type {
      #Required
      match_type = "EXACT_MATCH"
    }
  }
}
*/






### Adds a backend server to a backend set.
## https://registry.terraform.io/providers/hashicorp/oci/latest/docs/resources/load_balancer_backend
resource "oci_load_balancer_backend" "lb-be1" {
  count            = var.instance_count
  load_balancer_id = oci_load_balancer.load_balancer.id
  backendset_name  = oci_load_balancer_backend_set.load_balancer_backend_set[count.index].name
  ip_address       = var.ip_adress_backend[count.index]
  port             = 80
  backup           = false
  drain            = false
  offline          = false
  weight           = 1
}



/*
resource "oci_load_balancer_backend" "lb-be2" {
  load_balancer_id = oci_load_balancer.load_balancer.id
  backendset_name  = oci_load_balancer_backend_set.lb-bes1.name
  ip_address       = var.ip_adress_backend[1]
  port             = 80
  backup           = false
  drain            = false
  offline          = false
  weight           = 1
}
*/

/*

resource "oci_load_balancer_rule_set" "test_rule_set" {
  items {
    action = "ADD_HTTP_REQUEST_HEADER"
    header = "example_header_name"
    value  = "example_header_value"
  }

  items {
    action          = "CONTROL_ACCESS_USING_HTTP_METHODS"
    allowed_methods = ["GET", "POST"]
    status_code     = "405"
  }

  items {
    action      = "ALLOW"
    description = "example vcn ACL"

    conditions {
      attribute_name  = "SOURCE_VCN_ID"
      attribute_value = oci_core_vcn.lbvcn1.id
    }

    conditions {
      attribute_name  = "SOURCE_VCN_IP_ADDRESS"
      attribute_value = "10.10.1.0/24"
    }
  }

  items {
    action = "REDIRECT"

    conditions {
      attribute_name  = "PATH"
      attribute_value = "/example"
      operator        = "FORCE_LONGEST_PREFIX_MATCH"
    }

    redirect_uri {
      protocol = "{protocol}"
      host     = "in{host}"
      port     = 8081
      path     = "{path}/video"
      query    = "?lang=en"
    }

    response_code = 302
  }

  load_balancer_id = oci_load_balancer.load_balancer.id
  name             = "example_rule_set_name"
}
*/



/*
resource "oci_core_security_list" "lbsecuritylist" {
  freeform_tags = { "Creator" : "eugenesimos@oracle.com", "Testing" :"oci-cert" }  
  display_name   = "lbsecuritylist"
  compartment_id = oci_core_vcn.lbvcn1.compartment_id
  vcn_id         = oci_core_vcn.lbvcn1.id

  egress_security_rules {
    protocol    = "all"
    destination = "0.0.0.0/0"
  }

  ingress_security_rules {
    protocol = "6"
    source   = "0.0.0.0/0"

    tcp_options {
      min = 80
      max = 80
    }
  }

  ingress_security_rules {
    protocol = "6"
    source   = "0.0.0.0/0"

    tcp_options {
      min = 443
      max = 443
    }
  }
}
*/


