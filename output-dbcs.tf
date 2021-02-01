output "dbcs_fault_domains" {
  value = (var.use_dbcs == "true") ? tolist(module.database[0].dbcs_fault_domains[*].name) : tolist([""])

}


output "dbcs_system" {
  value = (var.use_dbcs == "true") ? flatten(module.database[0].dbcs_system.db_systems) : []
  #value =  module.database[0].dbcs_system 
}


output "db_nodes" {
  value = (var.use_dbcs == "true") ? flatten(module.database[0].db_nodes) : []
}

output "db_node_details" {
  value = (var.use_dbcs == "true") ? flatten(module.database[0].db_node_details) : []
}

output "test_vnic" {
  value = (var.use_dbcs == "true") ? flatten(module.database[0].test_vnic) : []
}

output "dbcs_settings" {
  value = (var.use_dbcs == "true") ? module.database[0].dbcs_settings : ""
}

output "dbcs_database" {
  value = (var.use_dbcs == "true") ? module.database[0].dbcs_database : []
}