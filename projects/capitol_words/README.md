#Capitol Words

Hi!  If you're reading this that means that you are trying to do work on the [Capitol Words](http://capitolwords.org/) site or API.  This project has seen many developer hands with very little documentation. 

This document is an attempt of my brain dump regarding things I have learned about this project from working on it. 

---

###Basic Workflow
Capitol Words downloads congressional records from [gpo.gov](http://www.gpo.gov/fdsys/browse/collection.action?collectionCode=CREC) on a daily basis every morning at 8am.  It then runs a parser script on the records, and then populates a solr instance.

This daily process can be found in the `daily_update.sh` script

The project path is `/projects/capwords/src/Capitol-Words` on Sunlight's southwest server (54.160.47.236)

###Solr & MySql
This project uses both a Solr database and MySql database.  All queries occur in the API and will call either the Solr DB or MySql DB depending on the endpoint.

Data that exists in the MySql database gets populated by different shell scripts. The `get_date_counts` and `calculate_ngram_tfidf` commands get called by the `daily_update.sh` script that help populate fields in the Ngrams model.
Additionially, `calculate_ngram_tfidf` and `calculate_distance` gets called in the `monthly_update.sh` script that populates ngram fields for speakers and speaker states.

####Database Maintenance tasks
When a new congress gets sworn in new bioguide and bioguide roles need to be updated manually by running `import_bioguide.py <congress number>` and `import_roles.py` scripts. (Additionally, the congress select list will need to be updated on the [legislators page](http://capitolwords.org/legislator/)).

Sometimes a legislator's phrase list on their [legislator page](http://capitolwords.org/legislator/P000603-rand-paul/) will register with no words.  It also almost always happens when a reporter is looking for a certain legislator to write about and will inevitably contact us to complain.  When this occurs I manually run the `calculate_ngram_tfidf` command and pass it the field speaker_bioguide and the actual bioguide_id as a value.

The command looks something like this:

`python manage.py calculate_ngram_tfidf --field=speaker_bioguide --values=C001098`. 

^ This will populate Ted Cruz's legislator page. 

This gets run from the project working directroy (i.e. `/projects/capwords/src/Capitol-Words/cwod_site`).
  
  For more field and value options look over the `cwod_site/ngrams/management/commands/calculate_ngram_tfidf.py` file.

### Re-running the scraper
Probably most common is that a transcription is posted late and our scraper misses it and needs to be re-run. To double check this I cross reference http://www.gpo.gov/fdsys/browse/collection.action?collectionCode=CREC with the calendar dates on the http://capitolwords.org.  

If it appears that the fdsys collection has a date that the website is missing, the scraper needs to be re-ran.  In order to this there are a few steps:

1. ssh to server and open /opt/data/log/scraper.log in your editor of choice
2. scroll to the date that is missing (it should say nosession next to it)
3. delete that entire line, save, and exit the text editor
4. cd /projects/capwords/src/Capitol-Words/
5. run the `ingest_outdated.sh` with the following command `DAYS=<#days> ./ingest_outdated.sh <date>` where date is in YYYY-MM-DD format and DAYS is the number of days it has been since the date. 

Ex: 

*Today is May 21 2015 and we need to scrape for May 12 2015*

`DAYS=9 ./ingest_outdated.sh 2015-05-12`

___

Good luck!

**This documentation was originally written by [Corey Speisman](https://github.com/orgs/sunlightlabs/people/Cspeisman)**.
