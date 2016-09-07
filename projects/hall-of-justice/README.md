# Hall of Justice

Project to inventory criminal justice datasets from across all fifty states of the US.

## Metadata

### Basic

- **Creator(s):** [Damian Dortellado](https://github.com/daortellado), [Becca James](https://github.com/beccasjames), [Daniel Cloud](https://github.com/crdunwel), [Clayton Dunwell](https://github.com/crdunwel)
- **Production Domain:** [http://hallofjustice.sunlightfoundation.com/](http://hallofjustice.sunlightfoundation.com/)
- **Source Repository:** [https://github.com/sunlightlabs/hall-of-justice](https://github.com/sunlightlabs/hall-of-justice)
- **Type:** Web Application
- **Languages:** Python 3, HTML5
- **Major Dependencies:** Django, PostgreSQL, Celery


## Overview

The website is currently deployed on Sunlight's Heroku account, PostgreSQL database on AWS RDS, and Elastic Search on Bonsai starter plan.
Specific documentation on setup and development can be found on the GitHub page for the project. 
Interaction with the remote database (such as updating the data) was being done by pointing to it in local dev environment. **You
can find these production variables in Config Variables in Settings on Heroku**. 

The source data was originally manually collected by Damian Dortellado Becca James in 2014-2015. The data can be found and should be
edited on [this Google spreadsheet](https://docs.google.com/spreadsheets/d/1e4VMZ2zySEW4PK049WBlaJQJT8Y4KCZpBZK_8xDQ9Ng). 
Since links change, some of the data may need updating from time time. Check out the [crawler documentation](https://github.com/sunlightlabs/hall-of-justice#crawler) for how to identify broken links. 
Updating the data involves downloading this spreadsheet as an .xls file and [following the instruction on the GitHub page for the project](https://github.com/sunlightlabs/hall-of-justice#setup).
Again, [modify the settings locally](https://github.com/sunlightlabs/hall-of-justice/blob/master/hallofjustice/settings.py#L93) to point to the remote database to update the data on the production site.