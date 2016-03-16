# Provisioning Production

If you're reading this then you're trying to deploy and provision this project to a production server. This has
been designed to be as painless as possible. If you've already cloned this repository then you're already nearly
halfway there.

We use [ansible](http://docs.ansible.com/) to provision our production servers. At the time of this writing, 
Email Congress has complete and working provision files so provisioning a machine should be incredibly simple. Follow
the steps below and watch the magic unfold.

## Steps

1. Copy `ansible/ansible.cfg.example` over to `ansible/ansible.cfg`
2. In `ansible/ansible.cfg`, edit the example paths in `roles_path` and `private_key_file` to point the 
   provisioning directory of the Email Congress on your local machine and to the SSH key necessary to access 
   the server addresses defined in `ansible/hosts` file.
3. Run `run-this.sh` in the directory of this README.
4. ??????? (just kidding, all the magic should happen without error. If there are errors, contact project creator
   or maintainer.)
5. Profit