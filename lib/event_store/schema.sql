CREATE TABLE events (
  sequence_id bigserial primary key,
  id uuid unique not null,
  aggregate_id uuid not null,
  type varchar not null,
  body json not null,
  created_at timestamptz not null default (now())
);
