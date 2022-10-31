DROP TABLE IF EXISTS spaces; 

-- CREATE TABLE spaces (
--   id SERIAL PRIMARY KEY,
--   name text,
--   description text,
--   price float,
--   availability text
-- );

TRUNCATE TABLE spaces RESTART IDENTITY;

INSERT INTO spaces (name, description, price, availability) VALUES
('Place 1', 'This is place 1', 128, '12/12/2022'),
('Place 2', 'This is place 2', 128, '14/12/2022'),
('Place 3', 'This is place 3', 128, '17/12/2022');
