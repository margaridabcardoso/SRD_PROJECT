DROP DATABASE school_transport_service;
CREATE DATABASE IF NOT EXISTS school_transport_service;
USE school_transport_service;

-- CREATE TABLES AND RELATIONS

CREATE TABLE IF NOT EXISTS `children`(
    `child_id` VARCHAR(10) NOT NULL, 
    `child_name` VARCHAR(50) NOT NULL,
    `child_age` TINYINT NOT NULL,
    PRIMARY KEY(`child_id`)
);

CREATE TABLE IF NOT EXISTS `parents` (
    `parent_id` VARCHAR(10) NOT NULL, 
    `parents_name` VARCHAR(50) NOT NULL, 
    `parents_email` VARCHAR(100) NOT NULL, 	
    `house_address` VARCHAR(100) NOT NULL,
    `parents_phone` VARCHAR(15) NOT NULL,
    PRIMARY KEY(`parent_id`)
);

CREATE TABLE IF NOT EXISTS `routes`(
	`route_id` VARCHAR(10) NOT NULL,
    `start_location` VARCHAR(100) NOT NULL,
    `end_location` VARCHAR(100) NOT NULL,
    `distance_km` TINYINT NOT NULL,
    `price` DECIMAL(5, 2) NOT NULL DEFAULT 10,
    `time_minutes` TINYINT NOT NULL DEFAULT 15,
    PRIMARY KEY(`route_id`)
);

CREATE TABLE IF NOT EXISTS `vehicles`(
	`vehicle_id` VARCHAR(10) NOT NULL,
    `vehicle_type` VARCHAR(10) NOT NULL,
    `license_plate` VARCHAR(20) NOT NULL,
    `capacity` TINYINT NOT NULL,
    PRIMARY KEY (`vehicle_id`)
);

CREATE TABLE IF NOT EXISTS `drivers`(
	`drivers_id` VARCHAR(10) NOT NULL,
	`drivers_name` VARCHAR(50) NOT NULL,
    `license_number` VARCHAR(20) NOT NULL,
    `drivers_phone`VARCHAR(15) NOT NULL,
    PRIMARY KEY(`drivers_id`)
);

CREATE TABLE IF NOT EXISTS `school`(
	`school_id` VARCHAR(10) NOT NULL, 
    `school_name` VARCHAR(50) NOT NULL,
    `school_address`VARCHAR(100) NOT NULL,
    `school_phone` VARCHAR(15) NOT NULL,
    `principal_name` VARCHAR(50) NOT NULL,
    PRIMARY KEY(`school_id`)
);
	
CREATE TABLE IF NOT EXISTS `payments` (
    `payment_id` VARCHAR(10) NOT NULL ,
    `amount` DECIMAL(6, 2) NOT NULL,
    `payment_date` DATE NOT NULL,
    `payment_method` VARCHAR(40) NOT NULL,
	`rating` ENUM('1', '2', '3', '4', '5'),
    `comments` VARCHAR(300),
	PRIMARY KEY (`payment_id`)
);


# a child can only have one parent. a parent can have multiple children
ALTER TABLE `children`
ADD COLUMN `parent_id` VARCHAR(10) NOT NULL,
ADD CONSTRAINT `fk_parents` 
    FOREIGN KEY (`parent_id`) 
    REFERENCES `parents`(`parent_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE;
    
# a child can only have one school. a school can have multiple children    
ALTER TABLE `children`
ADD COLUMN `school_id` VARCHAR(10) NOT NULL,
ADD CONSTRAINT `fk_school` 
    FOREIGN KEY (`school_id`) 
    REFERENCES `school`(`school_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE;

# a payment can only be done by one person. a person can do multiple payments
ALTER TABLE `payments`
ADD COLUMN `parent_id` VARCHAR(10),
ADD CONSTRAINT `fk_payments_parents`
	FOREIGN KEY(`parent_id`)
    REFERENCES `parents`(`parent_id`)
	ON DELETE SET NULL
    ON UPDATE CASCADE;


CREATE TABLE IF NOT EXISTS `trips` (
    `trip_id` INT AUTO_INCREMENT,    
    `driver_id` VARCHAR(10),            
    `vehicle_id` VARCHAR(10),           
    `route_id` VARCHAR(10),             
    `start_time` DATETIME NOT NULL,             
    `end_time` DATETIME NOT NULL,
    PRIMARY KEY (`trip_id`)
	);

# many to many relation between trips and children - relational database
CREATE TABLE IF NOT EXISTS `trip_children` (
    `trip_id` INT NOT NULL,                    
    `child_id` VARCHAR(10) NOT NULL,           
    `is_paid`TINYINT(1) NOT NULL DEFAULT 0,
    PRIMARY KEY (`trip_id`, `child_id`)
    );

# a trip can only have one driver, one vehicle and one route, but drivers, vehicles and routes can do more than one trip
ALTER TABLE `trips`
ADD CONSTRAINT `fk_trips_driver`
	FOREIGN KEY (`driver_id`) REFERENCES `drivers`(`drivers_id`)
	ON DELETE SET NULL
	ON UPDATE CASCADE,
ADD CONSTRAINT `fk_trips_vehicle`
	FOREIGN KEY (`vehicle_id`) REFERENCES `vehicles`(`vehicle_id`)
	ON DELETE SET NULL
	ON UPDATE CASCADE,
ADD CONSTRAINT `fk_trips_routes`
    FOREIGN KEY (`route_id`) REFERENCES `routes`(`route_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE;

# many to many relation between children and trips
ALTER TABLE `trip_children`
ADD CONSTRAINT `fk_trip_children_trip`
	FOREIGN KEY (`trip_id`) REFERENCES `trips`(`trip_id`)
	ON DELETE CASCADE
	ON UPDATE CASCADE,
ADD CONSTRAINT `fk_trip_children_child`
	FOREIGN KEY (`child_id`) REFERENCES `children`(`child_id`)
	ON DELETE CASCADE
	ON UPDATE CASCADE;
    
# no foreign key - keep track of routes along time
CREATE TABLE IF NOT EXISTS `routes_log` (
    `log_id` INT AUTO_INCREMENT,              
    `route_id` VARCHAR(10) NOT NULL,          
    `column_changed` VARCHAR(20) NOT NULL,   
    `old_value` VARCHAR(100) NOT NULL,   
    `new_value` VARCHAR(100) NOT NULL,   
    `change_timestamp` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `changed_by` VARCHAR(50) DEFAULT NULL,   
    PRIMARY KEY (`log_id`)
);


-- INSERT DATA INTO THE DATABASE BEING MINDFULL OF THE ORTHER WE CHOSE TO ADD THE DATA
	
INSERT INTO `parents` (`parent_id`, `parents_name`, `parents_email`, `house_address`, `parents_phone`)
VALUES
('P1', 'Alice Johnson', 'alice.johnson@example.com', '123 Flower Street', '1234567890'),
('P2', 'Michael Smith', 'michael.smith@example.com', '456 Sun Avenue', '2345678901'),
('P3', 'Emma Brown', 'emma.brown@example.com', '789 Oak Lane', '3456789012'),
('P4', 'John Davis', 'john.davis@example.com', '321 Pine Road', '4567890123'),
('P5', 'Sophia Miller', 'sophia.miller@example.com', '654 Maple Blvd', '5678901234'),
('P6', 'James Wilson', 'james.wilson@example.com', '987 Elm Street', '6789012345'),
('P7', 'Isabella Moore', 'isabella.moore@example.com', '159 Birch Way', '7890123456'),
('P8', 'Oliver Taylor', 'oliver.taylor@example.com', '753 Cedar Ave', '8901234567'),
('P9', 'Mia Anderson', 'mia.anderson@example.com', '951 Walnut St', '9012345678'),
('P10', 'William Thomas', 'william.thomas@example.com', '852 Ash Drive', '0123456789');

INSERT INTO `school` (`school_id`, `school_name`, `school_address`, `school_phone`, `principal_name`)
VALUES
('S1', 'Greenfield Elementary', '101 Greenfield Rd', '1234567890', 'Dr. Emily Clark'),
('S2', 'Riverdale Middle School', '202 Riverdale St', '2345678901', 'Mr. David Hall'),
('S3', 'Hilltop Primary School', '303 Hilltop Ave', '3456789012', 'Mrs. Sarah Lee'),
('S4', 'Lakeside High School', '404 Lakeside Blvd', '4567890123', 'Dr. Michael Johnson');

INSERT INTO `children` (`child_id`, `child_name`, `child_age`, `parent_id`, `school_id`)
VALUES
('C1', 'Ethan Johnson', 8, 'P1', 'S1'),
('C2', 'Ava Smith', 7, 'P2', 'S2'),
('C3', 'Liam Brown', 6, 'P3', 'S3'),
('C4', 'Sophia Davis', 9, 'P4', 'S1'),
('C5', 'Noah Miller', 10, 'P5', 'S2'),
('C6', 'Emma Wilson', 7, 'P6', 'S3'),
('C7', 'Olivia Moore', 8, 'P7', 'S1'),
('C8', 'Lucas Taylor', 6, 'P8', 'S2'),
('C9', 'Charlotte Anderson', 10, 'P9', 'S3'),
('C10', 'Mason Thomas', 8, 'P10', 'S1'),
('C11', 'Amelia Johnson', 9, 'P1', 'S1'),
('C12', 'Harper Smith', 7, 'P2', 'S2'),
('C13', 'Jack Brown', 6, 'P3', 'S3'),
('C14', 'Ella Davis', 8, 'P4', 'S1'),
('C15', 'Henry Miller', 10, 'P5', 'S2');

INSERT INTO `routes` (`route_id`, `start_location`, `end_location`, `distance_km`, `price`, `time_minutes`)
VALUES
('R1', '123 Flower Street', 'Greenfield Area', 5, 15.00, 20),
('R2', '456 Sun Avenue', 'Riverdale District', 7, 20.00, 30),
('R3', '789 Oak Lane', 'Hilltop Community Center', 10, 25.00, 35),
('R4', '951 Walnut St', 'Lakeside Region', 12, 30.00, 40),
('R5', '852 Ash Drive', 'Greenfield Elementary', 6, 18.00, 25);


INSERT INTO `drivers` (`drivers_id`, `drivers_name`, `license_number`, `drivers_phone`)
VALUES
('D1', 'Robert Garcia', 'DL123456', '3216549870'),
('D2', 'Maria Hernandez', 'DL234567', '4327650981'),
('D3', 'David Martinez', 'DL345678', '5438761092'),
('D4', 'Jessica Lee', 'DL456789', '6549873210'),
('D5', 'Thomas Brown', 'DL567890', '7650984321');


INSERT INTO `vehicles` (`vehicle_id`, `vehicle_type`, `license_plate`, `capacity`)
VALUES
('V1', 'Van', 'ABC1234', 10),
('V2', 'Bus', 'DEF5678', 20),
('V3', 'Van', 'GHI9101', 12),
('V4', 'Bus', 'JKL2345', 25),
('V5', 'Van', 'MNO6789', 15);


INSERT INTO `trips` (`trip_id`, `driver_id`, `vehicle_id`, `route_id`, `start_time`, `end_time`)
VALUES
(1, 'D4', 'V1', 'R2', '2023-11-06 06:00:00', '2023-11-06 06:45:00'),
(2, 'D2', 'V5', 'R1', '2023-11-06 06:00:00', '2023-11-06 06:30:00'),
(3, 'D5', 'V2', 'R4', '2023-11-07 06:00:00', '2023-11-07 06:45:00'),
(4, 'D3', 'V2', 'R4', '2023-11-13 06:00:00', '2023-11-13 06:45:00'),
(5, 'D2', 'V5', 'R5', '2023-11-13 06:00:00', '2023-11-13 06:25:00'),
(6, 'D4', 'V3', 'R3', '2023-11-15 06:00:00', '2023-11-15 06:35:00'),
(7, 'D5', 'V1', 'R3', '2023-11-16 06:00:00', '2023-11-16 06:40:00'),
(8, 'D1', 'V3', 'R1', '2023-11-24 06:00:00', '2023-11-24 06:30:00'),
(9, 'D3', 'V3', 'R2', '2023-11-27 06:00:00', '2023-11-27 06:45:00'),
(10, 'D1', 'V3', 'R3', '2023-12-01 06:00:00', '2023-12-01 06:35:00'),
(11, 'D2', 'V4', 'R5', '2023-12-06 06:00:00', '2023-12-06 06:25:00'),
(12, 'D4', 'V3', 'R4', '2023-12-08 06:00:00', '2023-12-08 06:50:00'),
(13, 'D5', 'V4', 'R4', '2023-12-09 06:00:00', '2023-12-09 07:05:00'),
(14, 'D1', 'V2', 'R1', '2023-12-12 06:00:00', '2023-12-12 06:40:00'),
(15, 'D1', 'V5', 'R1', '2023-12-14 06:00:00', '2023-12-14 06:30:00'),
(16, 'D3', 'V1', 'R3', '2023-12-15 06:00:00', '2023-12-15 06:35:00'),
(17, 'D1', 'V2', 'R4', '2023-12-17 06:00:00', '2023-12-17 06:55:00'),
(18, 'D5', 'V4', 'R2', '2023-12-21 06:00:00', '2023-12-21 06:50:00'),
(19, 'D1', 'V3', 'R3', '2023-12-23 06:00:00', '2023-12-23 06:35:00'),
(20, 'D3', 'V3', 'R5', '2024-01-04 06:00:00', '2024-01-04 06:25:00'),
(21, 'D4', 'V2', 'R3', '2024-01-05 06:00:00', '2024-01-05 06:45:00'),
(22, 'D3', 'V5', 'R2', '2024-01-10 06:00:00', '2024-01-10 06:50:00'),
(23, 'D3', 'V4', 'R1', '2024-01-12 06:00:00', '2024-01-12 06:30:00'),
(24, 'D2', 'V3', 'R4', '2024-01-18 06:00:00', '2024-01-18 06:45:00'),
(25, 'D4', 'V1', 'R4', '2024-01-23 06:00:00', '2024-01-23 06:55:00'),
(26, 'D4', 'V2', 'R3', '2024-01-24 06:00:00', '2024-01-24 06:55:00'),
(27, 'D1', 'V5', 'R4', '2024-01-24 06:00:00', '2024-01-24 07:00:00'),
(28, 'D2', 'V5', 'R1', '2024-01-29 06:00:00', '2024-01-29 06:30:00'),
(29, 'D4', 'V5', 'R5', '2024-02-01 06:00:00', '2024-02-01 06:25:00'),
(30, 'D4', 'V1', 'R5', '2024-02-03 06:00:00', '2024-02-03 06:25:00'),
(31, 'D1', 'V2', 'R5', '2024-02-07 06:00:00', '2024-02-07 06:25:00'),
(32, 'D5', 'V2', 'R1', '2024-02-07 06:00:00', '2024-02-07 06:35:00'),
(33, 'D2', 'V1', 'R2', '2024-02-09 06:00:00', '2024-02-09 06:40:00'),
(34, 'D3', 'V2', 'R4', '2024-02-14 06:00:00', '2024-02-14 07:05:00'),
(35, 'D2', 'V5', 'R2', '2024-02-16 06:00:00', '2024-02-16 06:45:00'),
(36, 'D5', 'V2', 'R5', '2024-02-16 06:00:00', '2024-02-16 06:25:00'),
(37, 'D1', 'V4', 'R5', '2024-02-22 06:00:00', '2024-02-22 06:25:00'),
(38, 'D5', 'V1', 'R2', '2024-02-23 06:00:00', '2024-02-23 06:40:00'),
(39, 'D2', 'V1', 'R5', '2024-02-23 06:00:00', '2024-02-23 06:30:00'),
(40, 'D5', 'V2', 'R5', '2024-02-24 06:00:00', '2024-02-24 06:30:00'),
(41, 'D2', 'V4', 'R4', '2024-02-25 06:00:00', '2024-02-25 06:45:00'),
(42, 'D3', 'V4', 'R2', '2024-02-28 06:00:00', '2024-02-28 06:45:00'),
(43, 'D4', 'V3', 'R5', '2024-03-02 06:00:00', '2024-03-02 06:25:00'),
(44, 'D4', 'V3', 'R2', '2024-03-04 06:00:00', '2024-03-04 06:45:00'),
(45, 'D2', 'V4', 'R4', '2024-03-06 06:00:00', '2024-03-06 06:50:00'),
(46, 'D5', 'V3', 'R1', '2024-03-10 06:00:00', '2024-03-10 06:30:00'),
(47, 'D3', 'V3', 'R4', '2024-03-15 06:00:00', '2024-03-15 06:45:00'),
(48, 'D4', 'V4', 'R5', '2024-03-19 06:00:00', '2024-03-19 06:30:00'),
(49, 'D2', 'V4', 'R2', '2024-03-29 06:00:00', '2024-03-29 06:40:00'),
(50, 'D2', 'V4', 'R5', '2024-03-31 06:00:00', '2024-03-31 06:25:00');


INSERT INTO `trip_children` (`trip_id`, `child_id`, `is_paid`)
VALUES
(1, 'C7', 1), (1, 'C4', 1), (1, 'C6', 1), (1, 'C8', 1),
(2, 'C9', 1), (2, 'C4', 1), (2, 'C8', 1), (2, 'C6', 1),
(3, 'C5', 1), (3, 'C4', 1), (3, 'C3', 1),
(4, 'C3', 1), (4, 'C1', 1), (4, 'C5', 1), (4, 'C11', 1),
(5, 'C8', 1), (5, 'C5', 1), (5, 'C6', 1), (5, 'C3', 1),
(6, 'C5', 1), (6, 'C10', 1), (6, 'C1', 1),
(7, 'C7', 1), (7, 'C1', 1), (7, 'C2', 1), (7, 'C3', 1), (7, 'C4', 1),
(8, 'C2', 1), (8, 'C8', 1), (8, 'C4', 1),
(9, 'C6', 1), (9, 'C2', 1), (9, 'C3', 1), (9, 'C5', 1),
(10, 'C3', 1), (10, 'C4', 1), (10, 'C1', 1), (10, 'C6', 1),
(11, 'C5', 1), (11, 'C4', 1), (11, 'C6', 1), (11, 'C7', 1), (11, 'C8', 1),
(12, 'C3', 1), (12, 'C2', 1), (12, 'C5', 1),
(13, 'C3', 1), (13, 'C9', 1), (13, 'C6', 1), (13, 'C1', 1),
(14, 'C4', 1), (14, 'C6', 1), (14, 'C8', 1),
(15, 'C9', 1), (15, 'C2', 1), (15, 'C7', 1),
(16, 'C1', 1), (16, 'C3', 1), (16, 'C8', 1),
(17, 'C6', 1), (17, 'C12', 1), (17, 'C4', 1),
(18, 'C7', 1), (18, 'C4', 1), (18, 'C6', 1),
(19, 'C10', 1), (19, 'C1', 1), (19, 'C7', 1),
(20, 'C1', 1), (20, 'C3', 1), (20, 'C8', 1), (20, 'C9', 1),
(21, 'C7', 1), (21, 'C4', 1), (21, 'C6', 1), (21, 'C5', 1),
(22, 'C13', 1), (22, 'C9', 1), (22, 'C10', 1),
(23, 'C4', 1), (23, 'C3', 1),
(24, 'C4', 1), (24, 'C6', 1), (24, 'C2', 1),
(25, 'C4', 1), (25, 'C5', 1), (25, 'C8', 1),
(26, 'C4', 1), (26, 'C3', 1), (26, 'C7', 1),
(27, 'C7', 1), (27, 'C3', 1), (27, 'C2', 1),
(28, 'C7', 1), (28, 'C8', 1),
(29, 'C6', 1), (29, 'C7', 1), (29, 'C9', 1),
(30, 'C7', 1), (30, 'C5', 1), (30, 'C4', 1),
(31, 'C1', 1), (31, 'C9', 1), (31, 'C5', 1),
(32, 'C3', 1), (32, 'C6', 1),
(33, 'C1', 1), (33, 'C2', 1), (33, 'C3', 1),
(34, 'C5', 1), (34, 'C2', 1), (34, 'C7', 1),
(35, 'C10', 1), (35, 'C3', 1),
(36, 'C5', 1), (36, 'C6', 1), (36, 'C8', 1),
(37, 'C9', 1), (37, 'C6', 1), (37, 'C2', 1), (37, 'C7', 1),
(38, 'C6', 1), (38, 'C5', 1), (38, 'C2', 1),
(39, 'C8', 1), (39, 'C1', 1), (39, 'C14', 1),
(40, 'C5', 1), (40, 'C2', 1), (40, 'C9', 1),
(41, 'C1', 1), (41, 'C8', 1), (41, 'C7', 1), (41, 'C4', 1),
(42, 'C2', 1), (42, 'C5', 1), (42, 'C4', 1), (42, 'C15', 1),
(43, 'C5', 0), (43, 'C1', 0), (43, 'C8', 0),
(44, 'C6', 0), (44, 'C8', 0), (44, 'C9', 0),
(45, 'C6', 0), (45, 'C7', 0), (45, 'C2', 0),
(46, 'C8', 0), (46, 'C10', 0), (46, 'C7', 0),
(47, 'C6', 0), (47, 'C4', 0), (47, 'C9', 0),
(48, 'C4', 0), (48, 'C9', 0), (48, 'C5', 0),
(49, 'C7', 0), (49, 'C3', 0), (49, 'C6', 0), (49, 'C2', 0),
(50, 'C8', 0), (50, 'C9', 0), (50, 'C10', 0), (50, 'C11', 0);


INSERT INTO `payments` (`payment_id`, `amount`, `payment_date`, `payment_method`, `rating`, `comments`, `parent_id`)
SELECT
    CONCAT('PAY', LPAD(ROW_NUMBER() OVER (ORDER BY parents.parent_id), 4, '0')) AS payment_id,
    SUM(routes.price) AS amount,
    LAST_DAY(trips.start_time) AS payment_date,
    CASE FLOOR(1 + (RAND() * 4))
        WHEN 1 THEN 'Credit Card'
        WHEN 2 THEN 'Bank Transfer'
        WHEN 3 THEN 'PayPal'
        WHEN 4 THEN 'Cash'
    END AS payment_method,
    FLOOR(1 + (RAND() * 5)) AS rating,
    ELT(FLOOR(1 + (RAND() * 5)),
        'On time',
        'Satisfied.',
        'Could be better.',
        'Ok!',
        'Driver was friendly.'
    ) AS comments,
    parents.parent_id
FROM
    trip_children tc
JOIN
    trips ON tc.trip_id = trips.trip_id
JOIN
    routes ON trips.route_id = routes.route_id 
JOIN
    children ON tc.child_id = children.child_id
JOIN
    parents ON children.parent_id = parents.parent_id
WHERE
    tc.is_paid = 1
    AND MONTH(trips.start_time) IN (11, 12, 1, 2) 
GROUP BY
    parents.parent_id, LAST_DAY(trips.start_time);
    
-- TRIGGERS

# DROP TRIGGER IF EXISTS track_routes_changes;
# DROP TRIGGER IF EXISTS mark_trips_as_paid;


-- TRIGGER FOR THE ROUTES LOG TABLE (EVERYTIME INFORMATION ABOUT A ROUTE IS UPDATED, WE INSERT A ROW IN THE LOG TABLE)


DELIMITER $$

CREATE TRIGGER track_routes_changes
AFTER UPDATE ON routes
FOR EACH ROW
BEGIN
    -- Log changes for each updated column in the `routes` table
    IF OLD.start_location != NEW.start_location THEN
        INSERT INTO routes_log (route_id, column_changed, old_value, new_value, change_timestamp)
        VALUES (NEW.route_id, 'start_location', OLD.start_location, NEW.start_location, NOW());
    END IF;

    IF OLD.end_location != NEW.end_location THEN
        INSERT INTO routes_log (route_id, column_changed, old_value, new_value, change_timestamp)
        VALUES (NEW.route_id, 'end_location', OLD.end_location, NEW.end_location, NOW());
    END IF;

    IF OLD.distance_km !=  NEW.distance_km THEN
        INSERT INTO routes_log (route_id, column_changed, old_value, new_value, change_timestamp)
        VALUES (NEW.route_id, 'distance_km', OLD.distance_km, NEW.distance_km, NOW());
    END IF;

    IF OLD.price != NEW.price THEN
        INSERT INTO routes_log (route_id, column_changed, old_value, new_value, change_timestamp)
        VALUES (NEW.route_id, 'price', OLD.price, NEW.price, NOW());
    END IF;

    IF OLD.time_minutes != NEW.time_minutes THEN
        INSERT INTO routes_log (route_id, column_changed, old_value, new_value, change_timestamp)
        VALUES (NEW.route_id, 'time_minutes', OLD.time_minutes, NEW.time_minutes, NOW());
    END IF;
END$$

DELIMITER ;

-- TEST THE TRIGGER FOR THE LOG TABLE

INSERT INTO routes (route_id, start_location, end_location, distance_km, price, time_minutes)
VALUES 
('R7', 'Location A', 'Location B', 5, 10.00, 15),
('R8', 'Location C', 'Location D', 7, 12.50, 20);

UPDATE routes
SET start_location = 'Location X', price = 15.00
WHERE route_id = 'R7';


-- TRIGGER FOR UPDATE (MARK TRIPS AS PAID AFTER THE PAYMENT)

DELIMITER $$
CREATE TRIGGER mark_trips_as_paid
AFTER INSERT ON payments
FOR EACH ROW
BEGIN
    UPDATE trip_children tc
    JOIN children c ON tc.child_id = c.child_id
    JOIN trips t ON tc.trip_id = t.trip_id
    JOIN routes r ON t.route_id = r.route_id
    SET tc.is_paid = 1
    WHERE c.parent_id = NEW.parent_id
      AND MONTH(t.start_time) = MONTH(NEW.payment_date)
      AND YEAR(t.start_time) = YEAR(NEW.payment_date)
      AND tc.is_paid = 0; -- Only update unpaid trips
END$$
DELIMITER ;


-- TEST THE TRIGGER FOR UPDATES

-- see the value to add in the payments table related to march 2024 for 'P1'
SELECT 
    SUM(r.price) AS total_amount
FROM 
    trip_children tc
JOIN 
    children c ON tc.child_id = c.child_id
JOIN 
    trips t ON tc.trip_id = t.trip_id
JOIN 
    routes r ON t.route_id = r.route_id
WHERE 
    c.parent_id = 'P1'
    AND t.start_time BETWEEN '2024-03-01 00:00:00' AND '2024-03-31 23:59:59'
    AND tc.is_paid = 0; -- Only unpaid trips
    
-- insert value in payments
INSERT INTO payments (payment_id, amount, payment_date, payment_method, rating, comments, parent_id)
VALUES 
('PAY_TEST', 36, '2024-03-31', 'Credit Card', '5', 'Testing trigger', 'P1');


-- QUERIES

-- 1. What is the route that generates more revenue/what route is done the most
# EXPLAIN (uncomment explain to check optmization) 
SELECT 
    t.route_id, 
    COUNT(*) AS total_trips, 
    SUM(r.price) AS total_revenue
FROM 
    trips AS t
JOIN 
    routes AS r ON t.route_id = r.route_id
GROUP BY 
    t.route_id
ORDER BY 
    total_revenue DESC, total_trips DESC;

-- 2. Most Loyal Customers and the Average They Spend
# EXPLAIN
SELECT 
    p.parent_id,
    p.parents_name,
    COUNT(tc.trip_id) AS total_trips, 
    AVG(py.amount) AS average_spent
FROM 
    parents p
JOIN 
    children c ON p.parent_id = c.parent_id
JOIN 
    trip_children tc ON c.child_id = tc.child_id
JOIN 
    payments py ON p.parent_id = py.parent_id
GROUP BY 
    p.parent_id, p.parents_name
ORDER BY 
    total_trips DESC;


-- 3. Route with the Most Average Delay
# EXPLAIN
SELECT 
    t.route_id,
    AVG(TIMESTAMPDIFF(MINUTE, t.start_time, t.end_time) - r.time_minutes) AS average_delay
FROM 
    trips t
JOIN 
    routes r ON t.route_id = r.route_id
GROUP BY 
    t.route_id
ORDER BY 
    average_delay DESC;
    
    
-- 4. Drivers with the Most Delay
# EXPLAIN
SELECT 
    t.driver_id,
    d.drivers_name,
    AVG(TIMESTAMPDIFF(MINUTE, t.start_time, t.end_time) - r.time_minutes) AS average_delay
FROM 
    trips t
JOIN 
    drivers d ON t.driver_id = d.drivers_id
JOIN 
    routes r ON t.route_id = r.route_id
GROUP BY 
    t.driver_id, d.drivers_name
ORDER BY 
    average_delay DESC;
    
    
-- 5. Average Profit Per Month
# EXPLAIN
SELECT 
	DATE_FORMAT(payment_date, '%Y-%m') AS month, 
	SUM(amount) AS total_profit
FROM 
	payments
GROUP BY 
	DATE_FORMAT(payment_date, '%Y-%m')
ORDER BY 
	month ASC;
    
    
-- Optimizing queries
-- 1. 
CREATE INDEX idx_routes_price ON routes(price);
CREATE INDEX idx_trips_route_id ON trips(route_id);

# EXPLAIN
SELECT 
    t.route_id, 
    COUNT(1) AS total_trips, 
    SUM(r.price) AS total_revenue
FROM 
    trips t
JOIN 
    routes r ON t.route_id = r.route_id
GROUP BY 
    t.route_id
ORDER BY 
    total_revenue DESC, total_trips DESC;

-- 2. 
CREATE INDEX idx_parents_parent_id ON parents(parent_id);
CREATE INDEX idx_children_parent_id ON children(parent_id);
CREATE INDEX idx_trip_children_child_id ON trip_children(child_id);
CREATE INDEX idx_payments_parent_id ON payments(parent_id);

# EXPLAIN
SELECT 
    p.parent_id,
    p.parents_name,
    COUNT(tc.trip_id) AS total_trips, 
    AVG(py.amount) AS average_spent
FROM 
    parents p
JOIN 
    children c ON p.parent_id = c.parent_id
JOIN 
    trip_children tc ON c.child_id = tc.child_id
JOIN 
    payments py ON p.parent_id = py.parent_id
GROUP BY 
    p.parent_id, p.parents_name
ORDER BY 
    total_trips DESC;

-- 3. 
CREATE INDEX idx_routes_time_minutes ON routes(time_minutes);

# EXPLAIN
SELECT 
    t.route_id,
    AVG(TIMESTAMPDIFF(MINUTE, t.start_time, t.end_time) - r.time_minutes) AS average_delay
FROM 
    trips t
JOIN 
    routes r ON t.route_id = r.route_id
GROUP BY 
    t.route_id
ORDER BY 
    average_delay DESC;


-- 4. 
CREATE INDEX idx_trips_driver_id ON trips(driver_id);
CREATE INDEX idx_drivers_drivers_id ON drivers(drivers_id);

# EXPLAIN
SELECT 
    t.driver_id,
    d.drivers_name,
    AVG(TIMESTAMPDIFF(MINUTE, t.start_time, t.end_time) - r.time_minutes) AS average_delay
FROM 
    trips t
JOIN 
    drivers d ON t.driver_id = d.drivers_id
JOIN 
    routes r ON t.route_id = r.route_id
GROUP BY 
    t.driver_id, d.drivers_name
ORDER BY 
    average_delay DESC;

-- 5. 
CREATE INDEX idx_payments_payment_date ON payments(payment_date);

# EXPLAIN
SELECT 
    DATE_FORMAT(payment_date, '%Y-%m') AS month, 
    SUM(amount) AS total_revenue
FROM 
    payments
GROUP BY 
    DATE_FORMAT(payment_date, '%Y-%m')
ORDER BY 
    month ASC;
    
-- INVOICE

-- Invoice Header

CREATE OR REPLACE VIEW invoice_head_totals AS
SELECT
    CONCAT(p.parent_id, '_', DATE_FORMAT(MIN(t.start_time), '%Y%m')) AS invoice_id,
    p.parent_id,
    p.parents_name,
    p.parents_email,
    DATE_FORMAT(MIN(t.start_time), '%Y-%m-01') AS invoice_month, -- Invoice month
    SUM(r.price) AS total_amount,
    COALESCE(MAX(pm.payment_method), 'N/A') AS payment_method,
    COALESCE(MAX(pm.rating), 0) AS rating
FROM
    parents p
JOIN
    children c ON p.parent_id = c.parent_id
JOIN
    trip_children tc ON c.child_id = tc.child_id
JOIN
    trips t ON tc.trip_id = t.trip_id
JOIN
    routes r ON t.route_id = r.route_id
LEFT JOIN
    payments pm ON pm.parent_id = p.parent_id 
                AND DATE_FORMAT(pm.payment_date, '%Y-%m') = DATE_FORMAT(t.start_time, '%Y-%m')
WHERE
    tc.is_paid = 1
GROUP BY
    p.parent_id, p.parents_name, p.parents_email, DATE_FORMAT(t.start_time, '%Y-%m');


-- Invoice Details

CREATE OR REPLACE VIEW invoice_details AS
SELECT
    CONCAT(p.parent_id, '_', DATE_FORMAT(t.start_time, '%Y%m')) AS invoice_id, -- Unique ID per parent per month
    tc.trip_id AS trip_id,
    DATE(t.start_time) AS trip_date,
    c.child_name AS child_name,
    r.start_location AS start_location,
    r.end_location AS end_location,
    r.price AS trip_cost
FROM
    parents p
JOIN
    children c ON p.parent_id = c.parent_id
JOIN
    trip_children tc ON c.child_id = tc.child_id
JOIN
    trips t ON tc.trip_id = t.trip_id
JOIN
    routes r ON t.route_id = r.route_id
WHERE
    tc.is_paid = 1
ORDER BY
    invoice_id, trip_id, c.child_name;