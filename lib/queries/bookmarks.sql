DROP TABLE IF EXISTS bookmarks;
CREATE TABLE bookmarks (
  projector varchar unique not null,
  bookmark integer not null
);
