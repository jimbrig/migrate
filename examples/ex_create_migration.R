# declare the "up" SQL:
sql_up <- "
  CREATE TABLE users (
    id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    email TEXT UNIQUE NOT NULL
  );
"

# declare the "down" SQL:
sql_down <- "
  DROP TABLE IF EXISTS users;
"

# create database migration
create_migration(
  name = "add_users_table",
  sql_up = sql_up,
  sql_down = sql_down
)
