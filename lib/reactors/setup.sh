#!/usr/bin/env bash
createdb clippify_reactors
psql -c "ALTER DATABASE clippify_reactors SET timezone TO 'UTC'"
psql -d clippify_reactors -f "$(dirname $0)/bookmarks.sql"
# psql -d clippify_query -f "$(dirname $0)/shifts/schema.sql"
