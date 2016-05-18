Introduction

The Open States project consists of the data scrapers for all fifty states plus Puerto Rico and the District of
Columbia.  Each state is considered a module and implements its own scrapers for any supported data type that can be
scraped (e.g. legislator, committee, bill, or event data).  While it would be ideal for each type of data to have its
own scraper, scrapers are sometimes combined for convenience and/or efficiency.

## Repositories

-   [billy](https://github.com/sunlightlabs/billy): Billy is the framework that the Open States scrapers are written on.
The `billy` repository also contains a number of command-line utilities, the Billy admin interface, the Open States
API, and part of the front-end website code.  The Billy official documentation can be found
[here](https://billy.readthedocs.org/en/latest/).

    The Open States API was built using [Django Piston](https://bitbucket.org/jespern/django-piston/wiki/Home).

-   [openstates](https://github.com/sunlightlabs/openstates): This repository houses all the scraper implementations as
well as utility libraries.

-   [openstates.org](https://github.com/sunlightlabs/openstates.org): The front-facing Open States website, which
operates on Django.  While the front-end is split between this repository and Billy, some of the more Sunlight-specific
elements of the site are housed here.

-   [moxie](https://github.com/paultag/moxie): A Docker orchestration tool that manages Open States scrapers and
utilities - written by Paul Tagliamonte.

## Getting Started

### Prerequisites

Make sure to have [virtualenv](https://virtualenv.readthedocs.org/en/latest/) installed, if not [virtualenvwrapper](
https://virtualenvwrapper.readthedocs.org/en/latest/), as well as [pip](https://pip.readthedocs.org/en/latest/).

You will also need a local [MongoDB](https://www.mongodb.org/downloads) instance.  By default, the Open States project
looks for a database called `fiftystates`.

### Setup

Create your virtualenv for Open States (i.e. `mkvirtualenv openstates`) and run `pip install -r requirements.txt`.

### Running Scrapers

From the root directory of the project, run `billy-update [state abbreviation]` to run all scrapers in the module.
Each scraped entity will be cached to the `data` directory as a JSON file.  After the **scraping** step, `billy-update`
runs the **import** step by default, which loads the JSON files into MongoDB.

To run specific scraper types, you can use the following flags:

-   `--legislators`
-   `--committees`
-   `--bills`
-   `--votes`
-   `--events`
-   `--speeches`

Some other common options:

-   `--fast`: Uses the local cached file instead of scraping live data if possible.  It is best to use this extensively
    during testing.
-   `--scrape`: Only runs the scraping step and skips importing.  Useful for testing.
-   `--import`: Skips the scraping step and imports cached data into the database.
-  `--lower` or `--upper`: Choose a specific legislative chamber to scrape.

For example, if you wanted to grab only senators for Massachusetts, you would use `billy-update --legislators --upper
ma`.

## Running a Copy of openstates.org Locally

This should be done whenever testing database editing scripts that you plan to run in production - sometimes Mongo won't
complain but openstates.org will.

-   Have an instance of MongoDB you can access for testing purposes, either remotely or locally.  Refer to or modify the
MongoDB configuration in `billy_settings.py` as necessary.
-   You'll need the `openstates` repository to sync with the latest production data dump.  To copy the most recent
production data to your configured database, navigate to the `openstates` repo root directory and run:
`bash openstates/scripts/preload-mongo`
-   Navigate to the `openstates.org` directory.
-   Invoke the `openstates` virtualenv (i.e. old Django and Python 2).
-   Create a `billy_local.py` file in the top level directory.  In that file, set the `SECRET_KEY` environment variable
to anything, it just can't be blank.
-   Run `python manage.py runserver —-settings openstates.settings.dev`.
-   Access the local application at `localhost:8000`.

## Testing Database Scripts

1.   Copy the most recent production data to your configured database: `bash openstates/scripts/preload-mongo`.
1.   Run your one-off scripts against your test database.
1.   Run `openstates.org` with the updated database.

## Running Database Scripts Against Production Data

*Note*: This document assumes that you have your machine configured to connect with the machine serving openstates.org via SSH.

1.   Copy your script to the production server: `scp [your script path] openstates:~`.
1.   Log onto the production machine via SSH: `ssh openstates`.
1.   Navigate into the same directory as `billy_local.py`: `cd /projects/openstates/src/openstates`.
1.   Activate the Open Source virtualenv: `source /projects/openstates/virt/bin/activate`.
1.   Run the script: `python ~/[your script filename]`.

## Troubleshooting, Random Pointers, and Pro Tips

-   If you need to test scrapers repeatedly while developing locally, use the `--fast` option with `billy-update` to use the
data cached on your filesystem from previous scrapes.
-   If you absolutely have to, remove cached data by deleting the relevant files from the `cache` and `data` directories.
-   If you need to reduce the request rate during a scrape, use the `-r` option (provided by scrapelib) with `billy-update` to
specify the rate in requests per minute (evenly spaced).
-   Web machine acting up? Try restarting uWSGI by running `sudo service uwsgi restart`.
-   Pushed new changes not appearing? Make sure neither the hard drive nor memory are full. We've had problems where changes
don't get pulled from Github and we don't receive any kind of error; for example, Docker leaked memory and eventually choked up
Moxie so that it was returning 500 on its web views and not updating its `openstates` Docker image.
-   If the importers are successful, but new data aren't being reflected in the API/website, check for locked fields!
-   If you update the volume paths in the Dockerfile, remember to update the relevant paths in the Moxie job configurations.
-   The meat of the scrapers is implemented in Billy in the `scrape` directory.
-   Most of the code that shapes the data into its final form before entering the database should be located within the Billy
`importers` directory.
-   Billy's name parsing is done with [name_tools](https://github.com/jamesturk/name_tools).  Potentially needs some love.
