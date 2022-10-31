-- DROP TABLE IF EXISTS spaces; 

CREATE TABLE spaces (
  id SERIAL PRIMARY KEY,
  name text,
  description text,
  price float,
  availability text
);
