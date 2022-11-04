DROP TABLE IF EXISTS bookings;
DROP TABLE IF EXISTS spaces;
DROP TABLE IF EXISTS users;

CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  username text,
  name text,
  email text,
  password text
);

CREATE TABLE spaces (
  id SERIAL PRIMARY KEY,
  name text,
  description text,
  price float,
  availability text,
  user_id int,
  constraint fk_user foreign key(user_id)
    references users(id)
    on delete cascade
);

CREATE TABLE bookings (
  id SERIAL PRIMARY KEY,
  start_date date,
  end_date date,
  space_id int,
  constraint fk_space foreign key(space_id)
  references spaces(id)
  on delete cascade,
  user_id int,
  constraint fk_user foreign key(user_id)
    references users(id)
    on delete cascade
);

CREATE TABLE unavailable_dates (
  id SERIAL PRIMARY KEY,
  unavailable_date date,
  space_id int,
  constraint fk_space foreign key(space_id)
    references spaces(id)
    on delete cascade
);
