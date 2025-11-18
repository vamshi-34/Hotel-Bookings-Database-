CREATE TABLE Guests (
    guest_id INTEGER PRIMARY KEY,
    full_name TEXT NOT NULL,
    gender TEXT,
    age INTEGER,
    phone_number TEXT,
    loyalty_status TEXT,
    signup_date TEXT
);

CREATE TABLE Rooms (
    room_id INTEGER PRIMARY KEY,
    room_type TEXT NOT NULL,
    view TEXT,
    capacity INTEGER,
    nightly_rate REAL,
    status TEXT,
    floor INTEGER
);

CREATE TABLE Bookings (
    booking_id INTEGER PRIMARY KEY,
    guest_id INTEGER,
    room_id INTEGER,
    checkin_date TEXT NOT NULL,
    checkout_date TEXT NOT NULL,
    total_price REAL,
    payment_status TEXT,
    rating INTEGER,
    FOREIGN KEY (guest_id) REFERENCES Guests(guest_id),
    FOREIGN KEY (room_id) REFERENCES Rooms(room_id)
);

--1. Preview First Few Rows

SELECT * FROM Guests LIMIT 5;
SELECT * FROM Rooms LIMIT 5;
SELECT * FROM Bookings LIMIT 5;


--2. Missing Value Count Per Column
--Guests Table:

SELECT
  SUM(guest_id IS NULL) AS miss_guest_id,
  SUM(full_name IS NULL) AS miss_full_name,
  SUM(gender IS NULL) AS miss_gender,
  SUM(age IS NULL) AS miss_age,
  SUM(phone_number IS NULL) AS miss_phone_number,
  SUM(loyalty_status IS NULL) AS miss_loyalty_status,
  SUM(signup_date IS NULL) AS miss_signup_date
FROM Guests;

--Rooms Table:

SELECT
  SUM(room_id IS NULL) AS miss_room_id,
  SUM(room_type IS NULL) AS miss_room_type,
  SUM(view IS NULL) AS miss_view,
  SUM(capacity IS NULL) AS miss_capacity,
  SUM(nightly_rate IS NULL) AS miss_nightly_rate,
  SUM(status IS NULL) AS miss_status,
  SUM(floor IS NULL) AS miss_floor
FROM Rooms;

--Bookings Table:

SELECT
  SUM(booking_id IS NULL) AS miss_booking_id,
  SUM(guest_id IS NULL) AS miss_guest_id,
  SUM(room_id IS NULL) AS miss_room_id,
  SUM(checkin_date IS NULL) AS miss_checkin_date,
  SUM(checkout_date IS NULL) AS miss_checkout_date,
  SUM(total_price IS NULL) AS miss_total_price,
  SUM(payment_status IS NULL) AS miss_payment_status,
  SUM(rating IS NULL) AS miss_rating
FROM Bookings;

--3. Preprocessing: Replace NULL Values
--Guests Table:

UPDATE Guests
SET
  gender = COALESCE(gender, 'unknown'),
  phone_number = COALESCE(phone_number, 'unknown'),
  loyalty_status = COALESCE(loyalty_status, 'unknown'),
  signup_date = COALESCE(signup_date, 'unknown'),
  age = COALESCE(age, 0);
 
--Rooms Table:

UPDATE Rooms
SET
  room_type = COALESCE(room_type, 'unknown'),
  view = COALESCE(view, 'unknown'),
  status = COALESCE(status, 'unknown'),
  capacity = COALESCE(capacity, 0),
  nightly_rate = COALESCE(nightly_rate, 0),
  floor = COALESCE(floor, 0);

  --Bookings Table:

UPDATE Bookings
SET
  payment_status = COALESCE(payment_status, 'unknown'),
  checkin_date = COALESCE(checkin_date, 'unknown'),
  checkout_date = COALESCE(checkout_date, 'unknown'),
  total_price = COALESCE(total_price, 0),
  rating = COALESCE(rating, 0);

  
  --4. Check Remaining NULLs
--Bookings Table:

SELECT * FROM Bookings
WHERE payment_status IS NULL OR checkin_date IS NULL OR checkout_date IS NULL OR total_price IS NULL OR rating IS NULL;

--Rooms Table:

SELECT * FROM Rooms
WHERE room_type IS NULL OR view IS NULL OR status IS NULL OR capacity IS NULL OR nightly_rate IS NULL OR floor IS NULL;

--Guests Table:

SELECT * FROM Guests
WHERE full_name IS NULL OR gender IS NULL OR phone_number IS NULL OR loyalty_status IS NULL OR signup_date IS NULL OR age IS NULL;

--5. Data Understanding & Aggregates
--a. Average Total Price Per Guest

SELECT Guests.full_name, AVG(Bookings.total_price) AS avg_spent, COUNT(Bookings.booking_id) AS num_bookings
FROM Bookings
JOIN Guests ON Bookings.guest_id = Guests.guest_id
GROUP BY Guests.guest_id
ORDER BY avg_spent DESC
LIMIT 5;

--b. Rating Distribution for Bookings

SELECT rating, COUNT(*) AS frequency
FROM Bookings
GROUP BY rating
ORDER BY rating;

--c. Most Popular Room Types

SELECT room_type, COUNT(*) AS num_rooms
FROM Rooms
GROUP BY room_type
ORDER BY num_rooms DESC;

--d. Booking Status Distribution

SELECT payment_status, COUNT(*) AS status_count
FROM Bookings
GROUP BY payment_status
ORDER BY status_count DESC;

--e. Guests With Most Bookings

SELECT Guests.full_name, COUNT(Bookings.booking_id) AS total_bookings
FROM Bookings
JOIN Guests ON Bookings.guest_id = Guests.guest_id
GROUP BY Guests.guest_id
ORDER BY total_bookings DESC
LIMIT 10;

