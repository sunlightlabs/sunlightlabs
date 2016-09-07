# Transparency Camp

The site that hosts the Transparency Camp website.

## Metadata

### Basic

- **Creator(s):** ?
- **Production Domain:** [https://transparencycamp.org/](https://transparencycamp.org/)
- **Source Repository:** [https://github.com/sunlightlabs/tcamp](https://github.com/sunlightlabs/tcamp)
- **Type:** Web Application
- **Languages:** Python 2, HTML5
- **Major Dependencies:** Django, MySQL, Gunicorn

### SSH Config

- **User:** ubuntu
- **Hostname:** ec2-54-204-249-97.compute-1.amazonaws.com
- **IdentityFile:** id_rsa-aws.pem

## Overview

This is a relatively straightforward Django app. Much of the content and management of the site can be done via the Django
admin interface so there should be relatively minimal interaction with the source code. You can create an admin user for yourself by SSHing
into the server, `sudo su - tcamp`, `cd src/current`, and `python manage.py createsuperuser`.
 
The project is deployed using the fabfile configuration included in the source code i.e running `fab deploy` on your 
local machine should deploy the project remotely. You may need to manually restart the web server at the end of deploy 
by SSHing, becoming tcamp user, and running `~/bin/stop` and `nohup ~/bin/run &`.
