# Varnish

Timball's single point of failure routing and caching server for all of our properties.

## Metadata

### Basic

- **Creator(s):** Timball
- **Production Domain:** none
- **Source Repository:** [https://github.com/sunlightlabs/varnish](https://github.com/sunlightlabs/varnish)
- **Type:** Web accelerator
- **Languages:** VCL
- **Major Dependencies:** 

### SSH Config

- **User:** ubuntu
- **Hostname:** 184.73.176.218
- **IdentityFile:** id_rsa-aws.pem
- **Port:** 42

## Overview

All of the varnish related files can be found in `/etc/varnish` with the actual routing done by `default.vcl`. There
are a number of scripts for interacting with varnish such as pulling from git, purging, reloading, etc. Most projects
point to this varnish server in their A record on Namecheap. [Pound](http://www.apsis.ch/pound/) is also running on the 
same AWS instance which handles HTTPS routing and files can be found at `/etc/pound`. 