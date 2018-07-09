DROP TABLE IF EXISTS shifts;
CREATE TABLE shifts (
  id uuid primary key,
  start_time timestamptz not null,
  end_time timestamptz
);
