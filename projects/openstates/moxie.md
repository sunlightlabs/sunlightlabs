# Moxie

## Overview

[Moxie](https://github.com/paultag/moxie) is our tool for running scrapers. It is fully dockerized (i.e. every component from
services to scrapers runs in its own Docker container).

Moxie is not a Sunlight project; it is maintained by [Paul Tagliomonte](https://github.com/paultag), and he is welcoming to
pull requests if you pester him (and your code is adequately esoteric).

## Primary Docker Containers

1.  **Postgres** - _This container provides the PostgreSQL service that Moxie depends on. The PostgreSQL server lives in this
container._
1.  **Moxie** - _This container provides the Moxie service itself._
1.  **Nginx** - _This container houses the Nginx server that serves the web interface._

## Web Interface

You can monitor jobs through the [Moxie web interface](http://moxie.sunlightlabs.com/).  The credentials to log in are:

```
Username: moxie

Password: timsucks
```

Although there is currently no method of navigating to individual container views for the state scrapers through the web
interface, you can directly navigate to `http://moxie.sunlightlabs.com/container/<container-name>`
(e.g. `http://moxie.sunlightlabs.com/container/openstates-al`) in order to monitor the progress of currently running jobs.

## Scripts

### Utility Scripts

There should be some basic utility scripts under the `admin` user's `home` directory. You should read through them yourself to understand what they do since they're already small and fairly simple to understand. They mostly have to deal with updating portions of the Moxie system.

### Environment Variables

The environment variables passed into the Moxie service container itself should be under `/etc/docker/moxie.sh`.

### Systemd Services

The system services that manage the containers ... that run the services ... should be under `/etc/systemd/system`. There should be unit files for the following services:

-   Moxie
-   PostgreSQL (which Moxie uses to store data)
-   RawDNS (I'm not sure exactly how necessary this is anymore)
-   Nginx (Serves the Moxie web interface)

Managing the services should be as easy as `systemctl start/stop/restart <service_name>`.

## How To

### Create/Edit Jobs, Users, and Configurations in Moxie

-   `clone` the `moxie-jobs` repo from the Sunlight Labs Gitlab.
-   To add an SSH user, edit `moxie-jobs/users.yaml`.
-   To add or change an Open States scraper, edit `moxie-jobs/projects/openstates/openstates.yaml`.
-   The `crontab` field indicates when/how often the job will run, using [crontab syntax](https://en.wikipedia.org/wiki/Cron).
-   To enable/disable automatic scraper runs based on the `crontab`, set the `manual` field to `true`/`false`.
-   If any specific environment variables are needed, add them to `env-sets` at the bottom of that file. You should also ensure
that each scraper you want to run with a specific environment has its `env` property set correctly in `openstates.yaml`.
-   `ssh moxie.sunlightlabs.com` (if you don't have keys to the box, get Andy to add you)
-   `bash ~/bin/update.sh` pulls the latest commit of `moxie-jobs` and then immediately places your terminal inside the Docker 
container running Moxie.
-   From within the Moxie container, run `moxie-load [path/to/updated/yaml]`. In this example, it would be `moxie-load
moxie-jobs/projects/openstates/openstates.yaml`.
-   If for any reason you need to manually alter the database, such as deleting a `job` or `user`, it's on the Moxie server
itself running in a Docker container (not on an RDS or otherwise external service).

### Deploy a New Version of Moxie

-   If you're making your own change, send a pull request to the Moxie repo.
-   Once it's merged, a Docker build will be triggered. Keep an eye on [Moxie's docker builds page]
(https://hub.docker.com/r/paultag/moxie/builds/) to make sure it succeeds.
-   `ssh moxie.sunlightlabs.com`
-   `bash ~/bin/pull.sh` (You may want to double check the configured repository to make sure it's pulling the correct image)

### Run a Moxie Job Via Slack

-   To manually run a specific Moxie job: `@moxie run <job-name>` (e.g. `@moxie: run openstates-al`)
-   To manually run all Open States scrapers (don't do this unless you have to): `@moxie run openstates`
-   Jobs with `manual: true` in their YAML configuration will need to be kicked off manually this way; otherwise, scheduled
jobs will run at their own configurated time(s) (but can also be manually run as well).

### Use the Moxie SSH Interface

*Note*: This document assumes that you are configured to connect to the machine running Moxie via SSH.

-   Ensure that you have a user configured in the `moxie-jobs/users.yaml` file in the `moxie-jobs` repo with a SHA-224
fingerprint of your public key.
-   Connect to the Moxie SSH interface: `ssh moxie -p 2222`.

## Moxie Won't Work

### Composing Docker Container Runs Manually

-   You can compose and run Docker containers manually through a command resembling the following:
    ```
    docker run -d -i -t -v /srv/moxie/openstates/:/billy/ \
    --name openstates-in --env INDIANA_API_KEY="<insert_api_key_here>" \
    sunlightlabs/openstates in
    ```
-   If you need to double-check how a Docker container is composed, please refer to the configurations in the `Moxie Jobs` 
respository in the [Sunlight Labs GitLab](https://https://gitlab.sunlightlabs.com/).

### Issues Encountered Before

-   Moxie would continue to bounce repeatedly and then cease to work. This was caused by a problem with the underlying
Butterfield library driving the Slack integration. The websocket would go bad, generating an uncaught exception. The uncaught
exception is still a risk, but the core issue should be addressed in [this commit]
(https://github.com/jcarbaugh/butterfield/commit/854da33ccab3f8df6134e244b523bf29e32a5987).
-   Moxie would cease to create new containers and for the most part fail silently. The underlying issue here was that the
system Docker was updated due to Docker Hub deprecating support for the version of Docker that Moxie was written on, but some
API parameter formats changed, rendering the existing API calls incorrect. In this case, RTFM and make the appropriate API call
updates.
