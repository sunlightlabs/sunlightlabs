# Sfcom

The www.sunlightfoundation.com website that handles a number of things including representing Sunlight online, 
the blog, API keys and analytics,

## Metadata

### Basic

- **Creator(s):** Many, but chiefly [Jeremy Carbaugh](https://github.com/jcarbaugh)
- **Production Domain:** [http://sunlightfoundation.com/](http://sunlightfoundation.com/)
- **Source Repository:** [https://github.com/sunlightlabs/sfcom](https://github.com/sunlightlabs/sfcom) private repo
- **Type:** Web Application
- **Languages:** Python 2, HTML5
- **Major Dependencies:** Django, MySQL, Celery, Gunicorn

### SSH Config

- **User:** ubuntu
- **Hostname:** ec2-23-20-190-156.compute-1.amazonaws.com
- **IdentityFile:** id_rsa-aws.pem

## Overview

The website is deployed on AWS with the database on the same machine. As with most Sunlight projects, the source 
code can be found at `/project/foundation` with a user that you should su into with `sudo su - foundation`. Doing this
will activate the virtual environment for the project and change directories to the afore mentioned source directory. 
You can deploy the project with a script `deploy` in this directory.

The website is nearly ten years old and its code base has become a quite a hodgepodge of moving pieces. Below are some major points
to take note of.

- Some of the HTML in pages are contained in the databases (editable in the Django admin page) and others are [files in the source code](https://github.com/sunlightlabs/sfcom/tree/master/sfcom/templates).
- The [blog is powered by Wordpress](http://write.sunlightfoundation.com/wp-admin/) with [custom Django models](https://github.com/sunlightlabs/django-wordpress) for storing and interacting with the data.
- The system for issuing API keys and tracking analytics is integrated with the site as a [Django app called Locksmith](https://github.com/sunlightlabs/django-locksmith).
    - The analytics web dashboard for Locksmith [can be found here](http://sunlightfoundation.com/api/analytics/). You must be logged in to see this data.
    - [The hub app](https://github.com/sunlightlabs/django-locksmith/tree/master/locksmith/hub) stores the analytic data.
    - Most Sunlight API properties send their logs on a cron job by parsing their webserver request log using [this script](https://github.com/sunlightlabs/django-locksmith/blob/master/locksmith/logparse/report.py).