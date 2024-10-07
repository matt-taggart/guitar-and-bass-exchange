#!/bin/sh

cd -P -- "$(dirname -- "$0")"

# Wait until Postgres is ready
until pg_isready -U ${POSTGRES_USERNAME} -h ${POSTGRES_HOST} -p ${POSTGRES_PORT}
do
  echo "$(date) - waiting for database to start"
  sleep 2
done

# Run migrations
./bin/guitar_and_bass_exchange eval "GuitarAndBassExchangeWeb.Release.migrate"

# Start the Phoenix app
exec ./bin/server
