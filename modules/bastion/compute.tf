# Get latest Oracle Linux image
data "oci_core_images" "InstanceImageOCID" {
  compartment_id           = var.oci_provider.tenancy_id
  operating_system         = "Oracle Linux"
  operating_system_version = "7.9"
  filter {
    name   = "display_name"
    values = ["^.*Oracle[^G]*$"]
    regex  = true
  }
}

data "local_file" "ssh_file" {
    filename = "${var.bastion.ssh_public_key}"
}




resource "oci_core_instance" "bastion" {
depends_on =[ data.local_file.ssh_file]
  count               = var.bastion.bastion_enabled == true ? 1 : 0
  availability_domain = var.ad_names
  compartment_id      = var.oci_provider.compartment_ocid
  freeform_tags       = var.bastion.tags

  create_vnic_details {
    assign_public_ip = true
    display_name     = var.bastion.hostname_label
    hostname_label   = var.bastion.hostname_label
    subnet_id        = var.bastion.vcn_id ###oci_core_subnet.bastion[0].id
    nsg_ids          = var.bastion.nsg_ids
  }

  display_name = var.bastion.hostname_label
  defined_tags = var.bastion.defined_tags

  # prevent the bastion from destroying and recreating itself if the image ocid changes 
  lifecycle {
    ignore_changes = [source_details[0].source_id, freeform_tags, defined_tags]
  }

  metadata = {
    ssh_authorized_keys =   file("${var.bastion.ssh_public_key}")
    ##user_data           = data.template_cloudinit_config.bastion[0].rendered
  }

  shape = var.bastion.bastion_shape


  shape_config {
    memory_in_gbs = "4"
    ocpus         = "1"
  }

  source_details {
    source_type = "image"
    source_id   = data.oci_core_images.InstanceImageOCID.images.0.id ##local.bastion_image_id
  }

  timeouts {
    create = "60m"
  }


}

