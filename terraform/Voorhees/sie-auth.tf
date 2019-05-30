#Authentication server first IaaS example

resource "vsphere_virtual_machine" "vm" {
  name             = "sie-auth"
#  resource_pool_id = "${data.vsphere_compute_cluster.cluster.resource_pool_id}"
  resource_pool_id = "${data.vsphere_host.esxi03.resource_pool_id}"
  datastore_id     = "${data.vsphere_datastore.datastore.id}"

  folder = "Sierra servers"
  wait_for_guest_net_timeout = false
  annotation = "Authentication server IdP and Keycloak runnig on it"
  num_cpus = 2
  memory   = 8192
  guest_id = "${data.vsphere_virtual_machine.Sierra_app.guest_id}"
#  guest_id = "rhel7Guest"

  disk {
    label            = "disk0"
    size             = "${data.vsphere_virtual_machine.Sierra_app.disks.0.size}"
#    size             = 60
    eagerly_scrub    = "${data.vsphere_virtual_machine.Sierra_app.disks.0.eagerly_scrub}"
    thin_provisioned = "${data.vsphere_virtual_machine.Sierra_app.disks.0.thin_provisioned}"
  }
  network_interface {
    network_id   = "${data.vsphere_network.network201.id}"
    adapter_type = "${data.vsphere_virtual_machine.Sierra_app.network_interface_types[0]}"
  }

  network_interface {
    network_id   = "${data.vsphere_network.network11.id}"
    adapter_type = "${data.vsphere_virtual_machine.Sierra_app.network_interface_types[0]}"
  }

  clone {
    template_uuid = "${data.vsphere_virtual_machine.Sierra_app.id}"
    customize {

    linux_options {
      host_name = "sie-auth"
      domain = "internal.sungard.corp"
    }

    dns_server_list = ["192.168.11.214","168.162.128.165"]
    dns_suffix_list = ["internal.sungard.corp","wayne.fnx.com"]

    network_interface {
      ipv4_address = "10.238.201.12"
      ipv4_netmask = 25
      }

    network_interface {
      ipv4_address = "192.168.11.113"
      ipv4_netmask = 24
      }
    }
  }
}