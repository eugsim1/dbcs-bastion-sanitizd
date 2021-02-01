output "pubreg" {
  value = oci_core_subnet.pubreg.id
}


####### --output "pubsb1" {
####### --  value = oci_core_subnet.pubsb1.id
####### --}
####### --

####### --output "pubsb2" {
####### --  value = oci_core_subnet.pubsb2.id
####### --}


output "lbvcn1" {
  value = oci_core_vcn.lbvcn1.id
}


output "privreg" {
  value = oci_core_subnet.privreg.id
}

output "network_security_group" {
  value = oci_core_network_security_group.network_security_group.id
}

output "dbcs_security_group_backup" {
  value = oci_core_network_security_group.dbcs_security_group_backup.id
}

output "privreg_dns_label" {
  value = format("%s", oci_core_subnet.privreg.subnet_domain_name)
}

output "pubreg_dns_label" {
  value = format("%s", oci_core_subnet.pubreg.subnet_domain_name)
} 