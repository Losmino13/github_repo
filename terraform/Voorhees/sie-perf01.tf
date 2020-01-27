resource "vsphere_virtual_machine" "sie-perf01" {

    name = "sie-perf01"
 #   resource_pool_id = "${data.vsphere_compute_cluster.cluster.resource_pool_id}"
    resource_pool_id = "${data.vsphere_host.esxi03.resource_pool_id}"
    datastore_id = "${data.vsphere_datastore.datastore.id}"
    folder = "Sierra servers"
    host_system_id = "${data.vsphere_host.esxi03.id}"
    guest_id = "${data.vsphere_virtual_machine.Sierra_minimal.guest_id}"
    annotation = "Performance server \nCurrently it is RHEL 7.6. Date created 27.01.2020"
    num_cpus = 4
    memory = 12288
    wait_for_guest_net_routable = "false"
    #ignored_guest_ips = ["192.168.11.115"]

    disk {
        datastore_id = "${data.vsphere_datastore.datastore.id}"
        label = "disk0"
        size = "60"
        unit_number = 0
        #size = "${data.vsphere_virtual_machine.Sierra_minimal.disks.0.size}"
        thin_provisioned = "${data.vsphere_virtual_machine.Sierra_minimal.disks.0.thin_provisioned}"
    }
/*
    disk {
        datastore_id = "${data.vsphere_datastore.datastore.id}"
        label = "disk1"
        size = "100"
        unit_number  = 1
    }
*/
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
                host_name = "sie-perf01"
                domain = "wayne.fnx.com"
            }

            network_interface {
                ipv4_address = "192.168.11.124"
                ipv4_netmask = 24
            }

            dns_server_list = ["192.168.11.214","168.162.128.165"]
            dns_suffix_list = ["wayne.fnx.com","internal.sungard.corp"]
            ipv4_gateway = "192.168.11.1"

        }
    }

}
