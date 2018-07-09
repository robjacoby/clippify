#!/usr/bin/env bash
createdb clippify_query
psql -c "ALTER DATABASE clippify_query SET timezone TO 'UTC'"
psql -d clippify_query -f "$(dirname $0)/bookmarks.sql"
psql -d clippify_query -f "$(dirname $0)/shifts/schema.sql"
