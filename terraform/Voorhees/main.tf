provider "vsphere" {
  user           = "${var.vsphere_user}"
  password       = "${var.vsphere_password}"
  vsphere_server = "${var.vsphere_server}"

  # if you have a self-signed cert
  allow_unverified_ssl = true
}


resource "vsphere_virtual_machine" "SierraIsolatedVM" {
    
    name = "sie-test1"
    resource_pool_id = "${data.vsphere_compute_cluster.cluster.resource_pool_id}"
    datastore_id = "${data.vsphere_datastore.datastore.id}"
    folder = "Support Servers"
    host_system_id = "${data.vsphere_host.esxi03.id}"
    guest_id = "${data.vsphere_virtual_machine.Sierra_minimal.guest_id}"
    num_cpus = 2
    memory = 4096
    wait_for_guest_net_routable = "false"


    annotation = "Sierra minimal isolated server"


    disk {
        label = "disk0"
        size = "${data.vsphere_virtual_machine.Sierra_minimal.disks.0.size}"
        thin_provisioned = "${data.vsphere_virtual_machine.Sierra_minimal.disks.0.thin_provisioned}"
    }

    network_interface {
        network_id = "${data.vsphere_network.network11.id}"
        adapter_type = "${data.vsphere_virtual_machine.Sierra_minimal.network_interface_types[0]}"
    }
    
    cdrom {
        datastore_id = "${data.vsphere_datastore.iso_datastore.id}"
        path         = "rhel-server-7.6-x86_64-dvd.iso"
    }

    clone {
        template_uuid = "${data.vsphere_virtual_machine.Sierra_minimal.id}"
        customize {

            linux_options {
                host_name = "sie-test1"
                domain = "wayne.fnx.com"
            }

            network_interface {
                ipv4_address = "192.168.11.115"
                ipv4_netmask = 24 
            }
            
            dns_server_list = ["192.168.11.214","168.162.128.165"]
            dns_suffix_list = ["wayne.fnx.com","internal.sungard.corp"]
            ipv4_gateway = "192.168.11.1"

            
        }
    }

}
