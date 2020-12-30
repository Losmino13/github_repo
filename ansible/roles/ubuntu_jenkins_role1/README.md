Role Name
=========

This role configures Jenkins Toolers build agents for WebEx client project.

Requirements
------------

Make sure to configure SSH access through vSphere Client before being able to launch this Ansible role.

Role Variables
--------------

Please consult jenkins/agents/toolers/vars/main.yml file to configure any variables befoer running the role. Particularly, you'll be interested in checking all variables with prefix jenkins_build_agent*, jenkins_build_agent_name and jenkins_server_url.

Dependencies
------------

This role has no dependencies.

Example Playbook
----------------

Make sure to position yourself first into jenkins/agents/ folder before running "ansible-playbook -i inventory.ini -c setup-toolers.yml" which will target toolers VMs defined in inventory.ini file (make sure you have configured host aliases inside of your ~/.ssh/config file and that those aliases match the names of the hosts in inventory.ini file).

Conetent of jenkins/agents/setup-toolers.yml file:
    - hosts: all
      remote_user: root
      roles:
         - { role: toolers,
             jenkins_server_url: http://jenkins_master,
             jenkins_build_agent_secret: secret,
             jenkins_build_agent_name: galway-tool-slave-10 }

Vagrantfile inside of jenkins/agents/toolers/tests/ directory is a good example on how to use this role:

    export jenkins_server_url=https://sqbu-jenkins.wbx2.com/client
    export jenkins_build_agent_secret=secret-string
    cd jenkins/agents/toolers/tests/
    vagrant up

License
-------

BSD

Author Information
------------------

An optional section for the role authors to include contact information, or a website (HTML is not allowed).
