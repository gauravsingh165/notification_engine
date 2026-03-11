#!/bin/bash
set -e

echo "Waiting for Postgres..."

until pg_isready -h db -p 5432 -U postgres
do
  sleep 2
done

echo "Postgres is ready."

if [ "$RUN_MIGRATIONS" = "true" ]; then
  echo "Running database setup..."
  bundle exec rails db:prepare
fi

exec "$@"