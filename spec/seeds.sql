
TRUNCATE TABLE bookings, unavailable_dates, spaces, users RESTART IDENTITY CASCADE;

INSERT INTO users (name, username, email, password) VALUES
('User 1', 'user_one', 'user_one@email.com', '1234');

INSERT INTO spaces (name, description, price, user_id) VALUES
('Place 1', 'This is place 1', 228, 1),
('Place 2', 'This is place 2', 128, 1),
('Place 3', 'This is place 3', 159, 1);


INSERT INTO unavailable_dates (unavailable_date, space_id) VALUES
('12/12/2022', 1),
('12/13/2022', 1);


INSERT INTO bookings (start_date, end_date, confirmed, space_id, user_id) VALUES
('12/12/2022', '12/13/2022', null, 1, 1);
