/* Network */

resource "oci_core_vcn" "lbvcn1" {
  cidr_block     = var.network_settings.vnc_cidr_block ###"10.1.0.0/16"
  compartment_id = var.network_settings.compartment_ocid
  display_name   = var.network_settings.vnc_display_name ##"lbvcn1"
  dns_label      = "lbvcn1"
  freeform_tags  = { "Creator" : "eugenesimos@oracle.com", "Testing" : "oci-cert" }
  //defined_tags = {"Mandatory_Tag.SE_email" :"eugenesimos@oracle.com" }
}


resource "oci_core_subnet" "privreg" {
  cidr_block        = var.network_settings.privreg_cidr_block   ##  "10.1.4.0/24"
  display_name      = var.network_settings.privreg_display_name ###"lbprivreg"
  dns_label         = "lbprivreg"
  security_list_ids = [oci_core_vcn.lbvcn1.default_security_list_id]
  compartment_id    = var.network_settings.compartment_ocid
  vcn_id            = oci_core_vcn.lbvcn1.id
  route_table_id    = oci_core_route_table.routenat.id
  dhcp_options_id   = oci_core_vcn.lbvcn1.default_dhcp_options_id
  freeform_tags     = { "Creator" : "eugenesimos@oracle.com", "Testing" : "oci-cert" }

  prohibit_public_ip_on_vnic = "true"
  #######  provisioner "local-exec" {
  #######    command = "sleep 5
  #######  }
}

### oci_core_security_list.dgsecuritylist.id , 
resource "oci_core_subnet" "pubreg" {
  cidr_block        = var.network_settings.pubreg_cidr_block   ## "10.1.1.0/24"
  display_name      = var.network_settings.pubreg_display_name ###"lbpbreg"
  dns_label         = "lbpbreg"
  security_list_ids = [oci_core_security_list.dgsecuritylist.id, oci_core_vcn.lbvcn1.default_security_list_id]
  compartment_id    = var.network_settings.compartment_ocid
  vcn_id            = oci_core_vcn.lbvcn1.id
  route_table_id    = oci_core_route_table.routetable1.id
  dhcp_options_id   = oci_core_vcn.lbvcn1.default_dhcp_options_id
  freeform_tags     = { "Creator" : "eugenesimos@oracle.com", "Testing" : "oci-cert" }

  prohibit_public_ip_on_vnic = "false"
  #######  provisioner "local-exec" {
  #######    command = "sleep 5"
  #######  }
}


resource "oci_core_internet_gateway" "internetgateway1" {
  compartment_id = var.network_settings.compartment_ocid
  display_name   = "internetgateway1"
  vcn_id         = oci_core_vcn.lbvcn1.id
  freeform_tags  = { "Creator" : "eugenesimos@oracle.com", "Testing" : "oci-cert" }
  ##defined_tags = {"Mandatory_Tag.SE_email" :"eugenesimos@oracle.com" }
}


resource "oci_core_nat_gateway" "nat_gateway" {
  #Required
  compartment_id = var.network_settings.compartment_ocid
  vcn_id         = oci_core_vcn.lbvcn1.id
  #Optional
  block_traffic = "false"
  display_name  = "nat_gateway"
  //defined_tags = {"Mandatory_Tag.SE_email" :"eugenesimos@oracle.com" }
}


resource "oci_core_route_table" "routetable1" {
  compartment_id = var.network_settings.compartment_ocid
  vcn_id         = oci_core_vcn.lbvcn1.id
  display_name   = "routetable1"
  freeform_tags  = { "Creator" : "eugenesimos@oracle.com", "Testing" : "oci-cert" }
  //defined_tags = {"Mandatory_Tag.SE_email" :"eugenesimos@oracle.com" }
  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.internetgateway1.id
  }
}


resource "oci_core_route_table" "routenat" {
  compartment_id = var.network_settings.compartment_ocid
  vcn_id         = oci_core_vcn.lbvcn1.id
  display_name   = "routenat"
  freeform_tags  = { "Creator" : "eugenesimos@oracle.com", "Testing" : "oci-cert" }
  // defined_tags = {"Mandatory_Tag.SE_email" :"eugenesimos@oracle.com" }
  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_nat_gateway.nat_gateway.id
  }
}

resource "oci_core_network_security_group" "network_security_group" {
  compartment_id = oci_core_vcn.lbvcn1.compartment_id
  vcn_id         = oci_core_vcn.lbvcn1.id
  display_name   = "NetWorkSecGroup"
}


resource "oci_core_network_security_group" "dbcs_security_group_backup" {
  compartment_id = oci_core_vcn.lbvcn1.compartment_id
  vcn_id         = oci_core_vcn.lbvcn1.id
  display_name   = "DBCSSecGroup"
}


resource "oci_core_network_security_group_security_rule" "egrees_network_security_group" {
  network_security_group_id = oci_core_network_security_group.network_security_group.id
  destination               = "0.0.0.0/0"
  direction                 = "EGRESS"
  protocol                  = "ALL"
  stateless                 = true
}

resource "oci_core_network_security_group_security_rule" "INGRESS_network_security_group_22" {
  network_security_group_id = oci_core_network_security_group.network_security_group.id
  protocol                  = "6"
  direction                 = "INGRESS"
  source                    = "0.0.0.0/0"
  stateless                 = true

  tcp_options {
    destination_port_range {
      min = 22
      max = 22
    }
  }
}

resource "oci_core_network_security_group_security_rule" "INGRESS_network_security_group_dg" {
  network_security_group_id = oci_core_network_security_group.network_security_group.id
  protocol                  = "6"
  direction                 = "INGRESS"
  source                    = "0.0.0.0/0"
  stateless                 = true
  tcp_options {
    destination_port_range {
      min = 1521
      max = 1523
    }
  }
}



resource "oci_core_network_security_group_security_rule" "EGRESS_dbcs_security_group" {
  network_security_group_id = oci_core_network_security_group.dbcs_security_group_backup.id
  destination               = "0.0.0.0/0"
  direction                 = "EGRESS"
  protocol                  = "ALL"
  stateless                 = true
}

resource "oci_core_network_security_group_security_rule" "INGRESS_dbcs_security_group_22" {
  network_security_group_id = oci_core_network_security_group.dbcs_security_group_backup.id
  protocol                  = "6"
  direction                 = "INGRESS"
  source                    = "0.0.0.0/0"
  stateless                 = true

  tcp_options {
    destination_port_range {
      min = 22
      max = 22
    }
  }
}

resource "oci_core_network_security_group_security_rule" "INGRESS_dbcs_security_group_dg" {
  network_security_group_id = oci_core_network_security_group.dbcs_security_group_backup.id
  protocol                  = "6"
  direction                 = "INGRESS"
  source                    = "0.0.0.0/0"
  stateless                 = true
  tcp_options {
    destination_port_range {
      min = 1521
      max = 1523
    }
  }
}





resource "oci_core_security_list" "waf" {
  ##  count = length(var.waf_entry_points)
  compartment_id = oci_core_vcn.lbvcn1.compartment_id
  vcn_id         = oci_core_vcn.lbvcn1.id
  display_name   = "waf_sec_list"

  lifecycle {
    ignore_changes = [defined_tags, freeform_tags]
  }
  egress_security_rules {
    protocol    = local.all_protocols
    destination = local.anywhere
  }

  dynamic "ingress_security_rules" {
    for_each = var.waf_entry_points
    content {
      ### port 80
      protocol  = local.tcp_protocol
      source    = ingress_security_rules.value
      stateless = false

      tcp_options {
        min = 80 ### 
        max = 80 #### 
      }
    }
  }

  dynamic "ingress_security_rules" {
    for_each = var.waf_entry_points
    content {
      ### port 443
      protocol  = local.tcp_protocol
      source    = ingress_security_rules.value
      stateless = false

      tcp_options {
        min = 443 ## 
        max = 443 ## 
      }
    }
  }
}

/*
resource "oci_core_subnet" "pubsb1" {
  availability_domain        = var.ad.name
  cidr_block                 = var.network_settings.pubsb1_cidr_block ###"10.1.2.0/24"
  display_name               = "subnet1"
  dns_label                  = "subnet1"
  security_list_ids          = [oci_core_security_list.securitylist1.id, oci_core_vcn.lbvcn1.default_security_list_id]
  compartment_id             = var.network_settings.compartment_ocid
  vcn_id                     = oci_core_vcn.lbvcn1.id
  route_table_id             = oci_core_route_table.routetable1.id
  dhcp_options_id            = oci_core_vcn.lbvcn1.default_dhcp_options_id
  freeform_tags              = { "Creator" : "eugenesimos@oracle.com", "Testing" : "oci-cert" }
  prohibit_public_ip_on_vnic = "false"
  #######  provisioner "local-exec" {
  #######    command = "sleep 5"
  #######  }
}



resource "oci_core_subnet" "pubsb2" {
  availability_domain        = var.ad.name
  cidr_block                 = var.network_settings.pubsb2_cidr_block ###"10.1.3.0/24"
  display_name               = "subnet2"
  dns_label                  = "subnet2"
  security_list_ids          = [oci_core_security_list.securitylist1.id, oci_core_vcn.lbvcn1.default_security_list_id]
  compartment_id             = var.network_settings.compartment_ocid
  vcn_id                     = oci_core_vcn.lbvcn1.id
  route_table_id             = oci_core_route_table.routetable1.id
  dhcp_options_id            = oci_core_vcn.lbvcn1.default_dhcp_options_id
  freeform_tags              = { "Creator" : "eugenesimos@oracle.com", "Testing" : "oci-cert" }
  prohibit_public_ip_on_vnic = "false"
  #######  provisioner "local-exec" {
  #######    command = "sleep 5"
  #######  }
}




resource "oci_core_subnet" "lb_pub" {
  availability_domain        = var.ad.name
  cidr_block                 = var.network_settings.lb_pub_cidr_block ###"10.1.3.0/24"
  display_name               = "lbpubsub"
  dns_label                  = "lbpubsub"
  security_list_ids          = [oci_core_security_list.securitylist1.id, oci_core_vcn.lbvcn1.default_security_list_id, oci_core_security_list.waf.id]
  compartment_id             = var.network_settings.compartment_ocid
  vcn_id                     = oci_core_vcn.lbvcn1.id
  route_table_id             = oci_core_route_table.routetable1.id
  dhcp_options_id            = oci_core_vcn.lbvcn1.default_dhcp_options_id
  freeform_tags              = { "Creator" : "eugenesimos@oracle.com", "Testing" : "oci-cert" }
  prohibit_public_ip_on_vnic = "false"
  #######  provisioner "local-exec" {
  #######    command = "sleep 5"
  #######  }
}

*/


resource "oci_core_security_list" "dgsecuritylist" {

  display_name   = "dgseclist"
  compartment_id = oci_core_vcn.lbvcn1.compartment_id
  vcn_id         = oci_core_vcn.lbvcn1.id

  egress_security_rules {
    protocol    = "all"
    destination = "0.0.0.0/0"
  }

  ingress_security_rules {
    protocol = "6"
    source   = "0.0.0.0/0"
  }

}


####### --resource "oci_core_security_list" "dgsecuritylist" {
####### --
####### --  display_name   = "dgseclist"
####### --  compartment_id = oci_core_vcn.lbvcn1.compartment_id
####### --  vcn_id         = oci_core_vcn.lbvcn1.id
####### --
####### --  egress_security_rules {
####### --    protocol    = "all"
####### --    destination = "0.0.0.0/0"
####### --  }
####### --
####### --  ingress_security_rules {
####### --    protocol = "6"
####### --    source   = "0.0.0.0/0"
####### --    tcp_options {
####### --      min = 80
####### --      max = 80
####### --    }
####### --  }
####### --
####### --  ingress_security_rules {
####### --    protocol = "6"
####### --    source   = "0.0.0.0/0"
####### --    tcp_options {
####### --      min = 443
####### --      max = 443
####### --    }
####### --  }
####### --
####### --  ingress_security_rules {
####### --    protocol = "6"
####### --    source   = "0.0.0.0/0"
####### --    tcp_options {
####### --      min = 22
####### --      max = 22
####### --    }
####### --  }
####### --
####### --  ingress_security_rules {
####### --    protocol = "6"
####### --    source   = "0.0.0.0/0"
####### --
####### --    tcp_options {
####### --      min = 1521
####### --      max = 1523
####### --    }
####### --  }
####### --}
####### --
####### --
####### --