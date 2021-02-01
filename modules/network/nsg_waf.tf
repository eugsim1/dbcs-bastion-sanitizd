variable "waf_entry_points" {
  description = "i want to create the nsg firewall for the waaf lists"
  type        = list(string)
  default = [
    "129.146.12.128/25",
    "129.146.13.128/25",
    "129.146.14.128/25",
    "129.213.0.128/25",
    "129.213.2.128/25",
    "129.213.4.128/25",
    "130.35.0.0/20",
    "130.35.112.0/22",
    "130.35.116.0/25",
    "130.35.120.0/21",
    "130.35.128.0/20",
    "130.35.144.0/20",
    "130.35.16.0/20",
    "130.35.176.0/20",
    "130.35.192.0/19",
    "130.35.224.0/22",
    "130.35.232.0/21",
    "130.35.240.0/20",
    "130.35.48.0/20",
    "130.35.64.0/19",
    "130.35.96.0/20",
    "132.145.0.128/25",
    "132.145.2.128/25",
    "132.145.4.128/25",
    "134.70.16.0/22",
    "134.70.24.0/21",
    "134.70.32.0/22",
    "134.70.56.0/21",
    "134.70.64.0/22",
    "134.70.72.0/22",
    "134.70.76.0/22",
    "134.70.8.0/21",
    "134.70.80.0/22",
    "134.70.84.0/22",
    "134.70.88.0/22",
    "134.70.92.0/22",
    "134.70.96.0/22",
    "138.1.0.0/20",
    "138.1.104.0/22",
    "138.1.128.0/19",
    "138.1.16.0/20",
    "138.1.160.0/19",
    "138.1.192.0/20",
    "138.1.208.0/20",
    "138.1.224.0/19",
    "138.1.32.0/21",
    "138.1.40.0/21",
    "138.1.48.0/21",
    "138.1.64.0/20",
    "138.1.80.0/20",
    "138.1.96.0/21",
    "140.204.0.128/25",
    "140.204.12.128/25",
    "140.204.16.128/25",
    "140.204.20.128/25",
    "140.204.24.128/25",
    "140.204.4.128/25",
    "140.204.8.128/25",
    "140.91.10.0/23",
    "140.91.12.0/22",
    "140.91.22.0/23",
    "140.91.24.0/22",
    "140.91.28.0/23",
    "140.91.30.0/23",
    "140.91.32.0/23",
    "140.91.34.0/23",
    "140.91.36.0/23",
    "140.91.38.0/23",
    "140.91.4.0/22",
    "140.91.40.0/23",
    "140.91.8.0/23",
    "147.154.0.0/18",
    "147.154.128.0/18",
    "147.154.192.0/20",
    "147.154.208.0/21",
    "147.154.224.0/19",
    "147.154.64.0/20",
    "147.154.80.0/21",
    "147.154.96.0/19",
    "192.157.18.0/24",
    "192.157.19.0/24",
    "192.29.0.0/20",
    "192.29.128.0/21",
    "192.29.138.0/23",
    "192.29.144.0/21",
    "192.29.152.0/22",
    "192.29.16.0/20",
    "205.147.88.0/21"
  ]
}

######"192.29.160.0/21",
######"192.29.168.0/22",
######"192.29.172.0/25",
######"192.29.178.0/25",
######"192.29.180.0/22",
######"192.29.32.0/21",
######"192.29.40.0/22",
######"192.29.44.0/25",
######"192.29.48.0/21",
######"192.29.56.0/21",
######"192.29.60.0/23",
######"192.29.64.0/20",
######"192.29.96.0/20",
######"192.69.118.0/23",
######"198.181.48.0/21",
######"199.195.6.0/23",


locals {
  all_protocols = "all"
  anywhere      = "0.0.0.0/0"
  tcp_protocol  = 6
}

variable "apollovcn_id" { default = "ocid1.vcn.oc1.eu-frankfurt-1.amaaaaaapvsuo5qa6cueyr2hwz3hxxnov2lf6echirlagnrllqpfok5gbgra" }
variable "apollo-netwrok-security-group_id" { default = "ocid1.networksecuritygroup.oc1.eu-frankfurt-1.aaaaaaaarpzp3v4ultsg64ypu2xs7j3tdz2nqg4n2vk6h6e6fxg5qngdsgxq" }
variable "default-vcn" { default = "ocid1.securitylist.oc1.eu-frankfurt-1.aaaaaaaa5wm5ivh46d3tm2vuh6jxcf36hk5liipaiyjxaqpffllvixe6gu3a" }

/*
resource oci_core_network_security_group_security_rule nsg_security_rules {
  count = length(var.waf_entry_points)
  description = "ingress  waf nsg"
  network_security_group_id = var.apollo-netwrok-security-group_id
  direction                 = "INGRESS"
  protocol                  = "6"  
  destination_type          = ""
  source                    = var.waf_entry_points[count.index]
  source_type               = "CIDR_BLOCK"
  stateless                 = "false"

}
*/







