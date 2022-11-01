-- DROP TABLE IF EXISTS spaces; 

CREATE TABLE bookings (
  id SERIAL PRIMARY KEY,
  username text,
  start_date date,
  end_date date,
    space_id int,
  constraint fk_space foreign key(space_id)
    references spaces(id)
    on delete cascade
);
