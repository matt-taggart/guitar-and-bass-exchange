#!/bin/sh

cd -P -- "$(dirname -- "$0")"

# Wait until Postgres is ready
until pg_isready -d ${DATABASE_URL}
do
  echo "$(date) - waiting for database to start"
  sleep 2
done

# Run migrations
./bin/guitar_and_bass_exchange eval "GuitarAndBassExchange.Release.migrate"

# Start the Phoenix app
exec ./bin/guitar_and_bass_exchange start
