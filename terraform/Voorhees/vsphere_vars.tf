#Data sources of vSphere infrastructure
#Description of infrastructure

data "vsphere_datacenter" "dc" {
  name = "wayne"
}

data "vsphere_compute_cluster" "cluster" {
  name          = "sierra_cluster"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_host" "esxi03" {
    name = "wayneesx03.wayne.fnx.com"
    datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_datastore" "datastore" {
  name          = "HDS_SAN_datastore01_R"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_datastore" "iso_datastore"{
  name          = "nfs_iso_immages"
  datacenter_id =  "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_network" "network201" {
  name          = "VLAN 201"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_network" "network11" {
  name          = "11 Network"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_virtual_machine" "Sierra_app" {
  name          = "RHEL7.6 Template SierraApp"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_virtual_machine" "Sierra_minimal" {
  name          = "RHEL7 minimal template"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}


