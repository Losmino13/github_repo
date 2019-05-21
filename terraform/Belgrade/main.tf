provider "vsphere" {
  user           = "${var.vsphere_user}"
  password       = "${var.vsphere_password}"
  vsphere_server = "${var.vsphere_server}"

  # if you have a self-signed cert
  allow_unverified_ssl = true
}

data "vsphere_datacenter" "dc" {
  name = "Belgrade"
}

data "vsphere_datastore" "datastore" {
  name          = "SAN05"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_compute_cluster" "cluster" {
  name          = "BGD Cluster"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_network" "network" {
  name          = "ServerVLAN"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_virtual_machine" "template" {
  name          = "CentOS74template"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

# resource "vsphere_virtual_machine" "vm" {
#   name             = "TestTerraform"
#   resource_pool_id = "${data.vsphere_compute_cluster.cluster.resource_pool_id}"
#   datastore_id     = "${data.vsphere_datastore.datastore.id}"

#   wait_for_guest_net_timeout = false
#   num_cpus = 2
#   memory   = 1024
#   guest_id = "${data.vsphere_virtual_machine.template.guest_id}"

#   disk {
#     label            = "disk0"
#     size             = "${data.vsphere_virtual_machine.template.disks.0.size}"
#     eagerly_scrub    = "${data.vsphere_virtual_machine.template.disks.0.eagerly_scrub}"
#     thin_provisioned = "${data.vsphere_virtual_machine.template.disks.0.thin_provisioned}"
#   }
#   network_interface {
#     network_id   = "${data.vsphere_network.network.id}"
#     adapter_type = "${data.vsphere_virtual_machine.template.network_interface_types[0]}"
#   }

#  clone {
#     template_uuid = "${data.vsphere_virtual_machine.template.id}"
#     customize {

#     linux_options {
#       host_name = "TFtest"
#       domain = "TFtest"
#     }

#     network_interface {
#       ipv4_address = "192.168.1.11"
#       ipv4_netmask = 24

#       }
#     }
#   }


# }
