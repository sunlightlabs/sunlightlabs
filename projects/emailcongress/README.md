# Email Congress

Lightweight web app to courier email messages to [phantom-of-the-capitol](https://github.com/EFForg/phantom-of-the-capitol) 
using [Postmark](https://postmarkapp.com/).

## Metadata

### Basic

- **Creator(s):** [Clayton Dunwell](https://github.com/crdunwel), [Olivia Cheng](https://github.com/heyitsolivia)
- **Production Domain:** [https://emailcongress.us](htts://emailcongress.us)
- **Source Repository:** [https://github.com/sunlightlabs/emailcongress](https://github.com/sunlightlabs/emailcongress)
- **Type:** Web Application
- **Languages:** Python 3, HTML5
- **Major Dependencies:** Django, PostgreSQL, Celery, PhantomJS

### SSH Config

**Web server**

- User: ubuntu
- Hostname: ec2-54-85-72-76.compute-1.amazonaws.com
- IdentityFile: id_rsa-aws.pem

**Taskqueue and database**

- User: ubuntu
- Hostname: ec2-52-23-244-182.compute-1.amazonaws.com
- IdentityFile: id_rsa-aws.pem

## Overview

This project is a spiritual continuation of a popular feature once found on OpenCongress. It essentially works by 
receiving emails from users, mapping addresses to a member of congress, and Phantom of the Capitol submitting the 
message via a headless browser. Emails initially go to a Gmail account which has a filter to forward to Postmark which 
in turn submit to an endpoint on emailcongress.us.

As with most projects, you can `sudo su - emailcongress` on the server to enter the project source directory and activate
the virtual environment.  You can restart the webserver with `sudo service uwsgi restart`. The celery task handles kicking
off phantom of the capitol to submit messages. It can be restart with `sudo service celery-emailcongress restart` on the
taskqueue machine. The admin username / password for the [django admin interface](https://emailcongress.us/admin) can be
found on CommonKey.