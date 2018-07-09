#!/usr/bin/env bash

createdb clippify_event_store
psql -c "ALTER DATABASE clippify_event_store SET timezone TO 'UTC'"
psql -d clippify_event_store -f "$(dirname $0)/schema.sql"
