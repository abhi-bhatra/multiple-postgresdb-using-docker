#!/bin/bash

set -e
set -u

function create_user_and_database() {
	local database=$1
	local dbSchema=$2
	local dbUser=$3
	local dbPassword=$4
	echo "Creating database '$database'"
	sudo -u postgres createuser -s $dbUser; createdb $database
	psql -v ON_ERROR_STOP=1 --username="$dbUser" --dbname=$database <<-EOSQL
		ALTER DATABASE $database OWNER TO $dbUser;
	    GRANT ALL PRIVILEGES ON DATABASE $database TO $dbUser;
	    CREATE SCHEMA $dbSchema;
		GRANT USAGE, CREATE ON SCHEMA $dbSchema TO $dbUser;
		GRANT SELECT, INSERT, UPDATE, DELETE, REFERENCES ON ALL tables IN SCHEMA $dbSchema TO $dbUser;
		ALTER DEFAULT privileges IN SCHEMA $dbSchema GRANT SELECT, INSERT, UPDATE, DELETE, REFERENCES ON tables TO $dbUser;
		GRANT USAGE, SELECT ON ALL sequences IN SCHEMA $dbSchema TO $dbUser;
		ALTER DEFAULT privileges IN SCHEMA $dbSchema GRANT USAGE, SELECT ON sequences TO $dbUser;
		ALTER ROLE $dbUser SET search_path = $dbSchema;
		CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA $dbSchema; 
EOSQL
}

if [ -n "$POSTGRES_MULTIPLE_DATABASES" ]; then
	echo "Multiple database creation requested: $POSTGRES_MULTIPLE_DATABASES"
	for db in $(echo $POSTGRES_MULTIPLE_DATABASES | tr ',' ' '); do
		create_user_and_database "${db}db" "${db}schema" "${db}user" "${db}pass"
	done
	echo "Multiple databases created"
fi
