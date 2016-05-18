A geocoding API for UK postcodes, based on the Ordnance Survey codepoint product.

This is a ruby on rails app. See http://rubyonrails.org for more details about developing and deploying rails apps.

## Installation

To download/install:
```
mkdir live_codepoint_api
cd live_codepoint_api
git clone https://github.com/davidmountain/codepoint-geocode-api
cd codepoint-geocode-api
bundle install
```

Create a copy of the 'config/database-template.yml' file called 'config/database.yml' and edit for local environment. Then create/migrate:
```
rake db:create
rake db:migrate
```
The lines above are for the dev and test DBs. Repeat with the suffix RAILS_ENV=production for the production DB.

### Seeding the DB Installation

Acquire codepoint file from http://www.ordnancesurvey.co.uk/oswebsite/products/code-point-open/index.html . Extract and concatenate into a single text file:
```
unzip codepo_gb.zip
cd Data/CSV
cat *.csv > codepointall.csv
```

To seed the DB:

```rake db:seed path=/path/to/codepointall.csv```

Repeat with suffix RAILS_ENV=production for the production DB.


## Usage

Geocode a single postcode

```/postcodes/[postcode] ```

Reverse geocoding: get postcodes near a given lat/lon.

```/postcodes?lat=[lat]&lon=[lon]&n=[n] ```

