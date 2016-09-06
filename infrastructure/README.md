# Sunlight Labs Infrastucture Automation Documentation

## Configuration Management and Automated Server Provisioning
----

### Ansible

#### Using Ansible

You may run Ansible through any host machine (controlling machine) against any
target machines (nodes), as long as Ansible has SSH access to the nodes via the
controlling machine, so a centralized provisioning server is unnecessary.

Target nodes should be managed via [inventories](https://docs.ansible.com/
ansible/intro_inventory.html).

#### Testing Your Ansible Scripts

The easiest way to have an isolated, repeatable testing environment for your
Ansible scripts is to use [Vagrant](https://www.vagrantup.com/). One caveat is
that many of the boxes available through [Atlas](https://atlas.hashicorp.com/
boxes/search) may not be suitable for a particular application due to resource
configurations, so you may have to hack around constraints through your
[Vagrantfile](https://www.vagrantup.com/docs/vagrantfile/index.html), or build
your own box for testing.

Once you have selected a box that's suitable for testing however, create a
Vagrantfile using something similar to the following configuration block for
the provisioning solution:

```
# Enable provisioning with Ansible.
config.vm.provision "ansible" do |ansible|
  ansible.verbose = "vvvvv"
  ansible.playbook = "path_to_ansible_playbook/playbook.yml"
end
```

As an example, what I usually end up doing is creating a dedicated directory
that houses only a Vagrantfile and a shortcut to the Ansible plays to be tested
(simply named `ansible`). I then use the following configuration block in my
Vagrantfile:

```
# Enable provisioning with Ansible.
config.vm.provision "ansible" do |ansible|
  ansible.verbose = "vvvvv"
  ansible.playbook = "ansible/site.yml"
end
```

To be certain I have a clean environment, I halt and destroy any existing VM
created by the Vagrantfile using the following command in the same directory as
the Vagrantfile:

```
vagrant -f destroy; vagrant up
```

This should obliterate any previous environment and spin up a clean one before
calling the Ansible plays against the new environment.

## Continuous Integration, Delivery, and Deployment
-----

### Jenkins

#### Our Pipeline and Operating Procedures

We run a [Jenkins](https://jenkins.io/index.html) server on an AWS EC2 instance
that should be accessible at http://ci.jenkins.sunlightfoundation.com:8080/.
The credentials should be accessible via CommonKey. If you do not have access,
please contact your supervisor.

Every project should have separate, dedicated jobs for creating versioned
testing and production builds, uploading those build to AWS S3, and
automatically deploying the latest builds to the proper staging or production
environments.

In the interest of robust failure recovery, jobs solely for deployment to
specific environments where the deployed build version can be configured should
be implemented. This is so that if an uncaught issue enters production, the
last working build of the application can be quickly redeployed to restore
functionality.
