create database uber;

use uber;

CREATE TABLE Passengers (
    passenger_id INT PRIMARY KEY,
    passenger_name VARCHAR(255),
    signup_date DATE,
    total_rides INT,
    total_spent DECIMAL(10, 2),
    rating DECIMAL(3, 2)
);

CREATE TABLE Drivers (
    driver_id INT PRIMARY KEY,
    driver_name VARCHAR(255),
    join_date DATE,
    rating DECIMAL(3, 2),
    total_rides INT,
    earnings DECIMAL(10, 2)
);

CREATE TABLE Rides (
    ride_id INT PRIMARY KEY,
    driver_id INT,
    passenger_id INT,
    pickup_location VARCHAR(255),
    dropoff_location VARCHAR(255),
    ride_distance DECIMAL(10, 2),
    ride_duration INT, -- Duration in minutes
    ride_timestamp TIMESTAMP,
    fare_amount DECIMAL(10, 2),
    payment_method VARCHAR(50),
    FOREIGN KEY (driver_id) REFERENCES Drivers(driver_id),
    FOREIGN KEY (passenger_id) REFERENCES Passengers(passenger_id)
);

select * from Passengers;
select * from Drivers;
select * from Rides;

-- Basic level

-- 1. What are & how many unique pickup locations are there in the dataset?
SELECT DISTINCT pickup_location FROM Rides;
SELECT COUNT(DISTINCT pickup_location) AS unique_locations_count FROM Rides;

-- 2. What is the total number of rides in the dataset?
SELECT COUNT(*) AS total_rides FROM Rides;

-- 3. Calculate the average ride duration.
SELECT AVG(ride_duration) AS average_duration FROM Rides;

-- 4. List the top 5 drivers based on their total earnings.
SELECT driver_name, earnings FROM Drivers ORDER BY earnings DESC LIMIT 5;

-- 5. Calculate the total number of rides for each payment method.
SELECT payment_method, COUNT(*) AS ride_count FROM Rides GROUP BY payment_method;

-- 6. Retrieve rides with a fare amount greater than 20.
SELECT * FROM Rides WHERE fare_amount > 20;

-- 7. Identify the most common pickup location.
SELECT pickup_location, COUNT(*) AS ride_count 
FROM Rides 
GROUP BY pickup_location 
ORDER BY ride_count DESC 
LIMIT 1;

-- 8. Calculate the average fare amount.
SELECT AVG(fare_amount) AS average_fare FROM Rides;

-- 9. List the top 10 drivers with the highest average ratings.
SELECT driver_name, rating FROM Drivers ORDER BY rating DESC LIMIT 10;

-- 10. Calculate the total earnings for all drivers.
SELECT SUM(earnings) AS total_system_earnings FROM Drivers;

-- 11. How many rides were paid using the "Cash" payment method?
SELECT COUNT(*) FROM Rides WHERE payment_method = 'Cash';

-- 12. Calculate the number of rides & average ride distance for rides originating from 'Dhanbad'.
SELECT COUNT(*) AS ride_count, AVG(ride_distance) AS avg_distance 
FROM Rides 
WHERE pickup_location = 'Dhanbad';

-- 13. Retrieve rides with a ride duration less than 10 minutes.
SELECT * FROM Rides WHERE ride_duration < 10;

-- 14. List the passengers who have taken the most number of rides.
SELECT passenger_name, total_rides FROM Passengers ORDER BY total_rides DESC;

-- 15. Calculate the total number of rides for each driver in descending order.
SELECT driver_name, total_rides FROM Drivers ORDER BY total_rides DESC;

-- 16. Identify the payment methods used by passengers from the 'Gandhinagar' pickup location.
SELECT DISTINCT payment_method FROM Rides WHERE pickup_location = 'Gandhinagar';

-- 17. Calculate the average fare amount for rides with a ride distance greater than 10.
SELECT AVG(fare_amount) AS average_fare FROM Rides WHERE ride_distance > 10;

-- 18. List the drivers in descending order according to their total number of rides.
SELECT driver_name, total_rides FROM Drivers ORDER BY total_rides DESC;

-- 19. Calculate the percentage distribution of rides for each pickup location.
SELECT pickup_location, 
       (COUNT(*) * 100.0 / (SELECT COUNT(*) FROM Rides)) AS percentage_distribution
FROM Rides 
GROUP BY pickup_location;

-- 20. Retrieve rides where both pickup and dropoff locations are the same.
SELECT * FROM Rides WHERE pickup_location = dropoff_location;



-- Intermediate Level

-- 1. Passengers who have taken rides from at least 300 different pickup locations
SELECT p.passenger_name 
FROM Passengers p
JOIN Rides r ON p.passenger_id = r.passenger_id
GROUP BY p.passenger_id, p.passenger_name
HAVING COUNT(DISTINCT r.pickup_location) >= 300;

-- 2. Average fare amount for rides taken on weekdays (Mon-Fri)
SELECT AVG(fare_amount) AS avg_weekday_fare
FROM Rides 
WHERE DAYOFWEEK(ride_timestamp) BETWEEN 2 AND 6;

-- 3. Drivers who have taken rides with distances greater than 19
SELECT DISTINCT d.driver_name 
FROM Drivers d
JOIN Rides r ON d.driver_id = r.driver_id
WHERE r.ride_distance > 19;

-- 4. Total earnings for drivers who have completed more than 100 rides
SELECT SUM(earnings) AS total_high_volume_earnings 
FROM Drivers 
WHERE total_rides > 100;

-- 5. Rides where the fare amount is less than the average fare amount
SELECT * FROM Rides 
WHERE fare_amount < (SELECT AVG(fare_amount) FROM Rides);

-- 6. Average rating of drivers who have used both 'Credit Card' and 'Cash' payment methods
SELECT AVG(rating) 
FROM Drivers 
WHERE driver_id IN (SELECT driver_id FROM Rides WHERE payment_method = 'Credit Card')
  AND driver_id IN (SELECT driver_id FROM Rides WHERE payment_method = 'Cash');

-- 7. Top 3 passengers with the highest total spending
SELECT passenger_name, total_spent 
FROM Passengers 
ORDER BY total_spent DESC 
LIMIT 3;

-- 8. Average fare amount for rides taken during different months of the year
SELECT MONTH(ride_timestamp) AS ride_month, AVG(fare_amount) AS avg_fare
FROM Rides 
GROUP BY MONTH(ride_timestamp)
ORDER BY ride_month;

-- 9. Most common pair of pickup and dropoff locations
SELECT pickup_location, dropoff_location, COUNT(*) AS pair_count
FROM Rides 
GROUP BY pickup_location, dropoff_location
ORDER BY pair_count DESC 
LIMIT 1;

-- 10. Total earnings for each driver ordered by earnings descending
SELECT driver_name, earnings 
FROM Drivers 
ORDER BY earnings DESC;

-- 11. Passengers who have taken rides on their signup date
SELECT DISTINCT p.passenger_name 
FROM Passengers p
JOIN Rides r ON p.passenger_id = r.passenger_id
WHERE DATE(p.signup_date) = DATE(r.ride_timestamp);

-- 12. Average earnings per ride for each driver ordered by earnings descending
SELECT driver_name, (earnings / total_rides) AS avg_earnings_per_ride
FROM Drivers 
WHERE total_rides > 0
ORDER BY earnings DESC;

-- 13. Rides with distances less than the average ride distance
SELECT * FROM Rides 
WHERE ride_distance < (SELECT AVG(ride_distance) FROM Rides);

-- 14. Drivers who have completed the least number of rides
SELECT driver_name, total_rides 
FROM Drivers 
ORDER BY total_rides ASC;

-- 15. Average fare for rides taken by passengers with at least 20 rides
SELECT AVG(r.fare_amount) 
FROM Rides r
JOIN Passengers p ON r.passenger_id = p.passenger_id
WHERE p.total_rides >= 20;

-- 16. Pickup location with the highest average fare amount
SELECT pickup_location, AVG(fare_amount) AS avg_fare
FROM Rides 
GROUP BY pickup_location 
ORDER BY avg_fare DESC 
LIMIT 1;

-- 17. Average rating of drivers who completed at least 100 rides
SELECT AVG(rating) 
FROM Drivers 
WHERE total_rides >= 100;

-- 18. Passengers who have taken rides from at least 5 different pickup locations
SELECT p.passenger_name
FROM Passengers p
JOIN Rides r ON p.passenger_id = r.passenger_id
GROUP BY p.passenger_id, p.passenger_name
HAVING COUNT(DISTINCT r.pickup_location) >= 5;

-- 19. Average fare amount for rides taken by passengers with ratings above 4
SELECT AVG(r.fare_amount) 
FROM Rides r
JOIN Passengers p ON r.passenger_id = p.passenger_id
WHERE p.rating > 4;

-- 20. Rides with the shortest ride duration in each pickup location
SELECT r1.* FROM Rides r1
JOIN (
    SELECT pickup_location, MIN(ride_duration) AS min_duration 
    FROM Rides 
    GROUP BY pickup_location
) r2 ON r1.pickup_location = r2.pickup_location AND r1.ride_duration = r2.min_duration;



-- Advanced Level

-- 1. Drivers who have driven rides in all unique pickup locations
SELECT d.driver_name
FROM Drivers d
JOIN Rides r ON d.driver_id = r.driver_id
GROUP BY d.driver_id, d.driver_name
HAVING COUNT(DISTINCT r.pickup_location) = (SELECT COUNT(DISTINCT pickup_location) FROM Rides);

-- 2. Average fare amount for rides taken by passengers who spent more than 300 total
SELECT AVG(r.fare_amount) AS avg_fare
FROM Rides r
JOIN Passengers p ON r.passenger_id = p.passenger_id
WHERE p.total_spent > 300;

-- 3. Bottom 5 drivers based on their average earnings (Earnings divided by total rides)
SELECT driver_name, (earnings / total_rides) AS avg_earnings
FROM Drivers
WHERE total_rides > 0
ORDER BY avg_earnings ASC
LIMIT 5;

-- 4. Sum fare amount for rides taken by passengers who have used multiple payment methods
SELECT SUM(fare_amount) 
FROM Rides 
WHERE passenger_id IN (
    SELECT passenger_id 
    FROM Rides 
    GROUP BY passenger_id 
    HAVING COUNT(DISTINCT payment_method) > 1
);

-- 5. Retrieve rides where the fare amount is significantly above average (using 2 Standard Deviations)
SELECT * FROM Rides 
WHERE fare_amount > (
    SELECT AVG(fare_amount) + (2 * STDDEV(fare_amount)) FROM Rides
);

-- 6. Drivers who completed rides on the same day they joined
SELECT DISTINCT d.driver_name
FROM Drivers d
JOIN Rides r ON d.driver_id = r.driver_id
WHERE DATE(d.join_date) = DATE(r.ride_timestamp);

-- 7. Average fare amount for rides taken by passengers using different payment methods
SELECT AVG(fare_amount) 
FROM Rides 
WHERE passenger_id IN (
    SELECT passenger_id 
    FROM Rides 
    GROUP BY passenger_id 
    HAVING COUNT(DISTINCT payment_method) > 1
);

-- 8. Pickup location with highest percentage increase in avg fare compared to overall avg
SELECT pickup_location, 
       ((AVG(fare_amount) - (SELECT AVG(fare_amount) FROM Rides)) / (SELECT AVG(fare_amount) FROM Rides) * 100) AS pct_increase
FROM Rides
GROUP BY pickup_location
ORDER BY pct_increase DESC
LIMIT 1;

-- 9. Retrieve rides where the dropoff location is the same as the pickup location
SELECT * FROM Rides 
WHERE pickup_location = dropoff_location;

-- 10. Average rating of drivers who have driven rides in at least 10 different pickup locations
SELECT AVG(rating) 
FROM Drivers 
WHERE driver_id IN (
    SELECT driver_id 
    FROM Rides 
    GROUP BY driver_id 
    HAVING COUNT(DISTINCT pickup_location) >= 10
);
