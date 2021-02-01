output "pubreg" {
  value = module.network.pubreg
}


####### --output "pubsb1" {
####### --  value = module.network.pubsb1
####### --}
####### --
####### --output "pubsb2" {
####### --  value = module.network.pubsb2
####### --}
####### --

output "lbvcn1" {
  value = module.network.lbvcn1
}


output "privreg" {
  value = module.network.privreg
}


output "privreg_dns_label" {
  value = module.network.privreg_dns_label
}

output "pubreg_dns_label" {
  value = module.network.pubreg_dns_label
} 