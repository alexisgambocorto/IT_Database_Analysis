-- Create Database --
CREATE DATABASE IT_support_company;

-- Create TABLES --
DROP TABLE IF EXISTS clients;
CREATE TABLE clients
            (
                client_id INT PRIMARY KEY AUTO_INCREMENT,	
                company_name VARCHAR(30),	 
                contact_name VARCHAR(30),	
				email	VARCHAR(255) UNIQUE,
                phone	VARCHAR(15),
                address VARCHAR(50)
            );
            
            
DROP TABLE IF EXISTS users;
CREATE TABLE users
            (
                user_id INT PRIMARY KEY AUTO_INCREMENT,	
                client_id INT,	 
                user_name VARCHAR(30) NOT NULL,
				email VARCHAR(255) UNIQUE NOT NULL,
				user_role ENUM('admin', 'technician', 'manager', 'client'),

                CONSTRAINT fk_client
					FOREIGN KEY (client_id)
					REFERENCES clients(client_id)
            );
            
DROP TABLE IF EXISTS technicians;
CREATE TABLE technicians
            (
                technician_id INT PRIMARY KEY AUTO_INCREMENT,	
                technician_name VARCHAR(30) NOT NULL,
				email VARCHAR(255) UNIQUE NOT NULL,
				skill_level ENUM('junior', 'mid', 'senior'),
				hire_date DATE
            );
			
DROP TABLE IF EXISTS support_tickets;
CREATE TABLE support_tickets
            (
				ticket_id INT PRIMARY KEY AUTO_INCREMENT,	
                client_id INT,
                user_id INT,
                technician_id INT,
                ticket_status ENUM('fufilled', 'in progress', 'unfufiled'),
				created_at DATETIME NOT NULL,
				closed_at DATETIME,

                CONSTRAINT fk_tickets_client
					FOREIGN KEY (client_id)
					REFERENCES clients(client_id),
                    
				 CONSTRAINT fk_user
					FOREIGN KEY (user_id)
					REFERENCES users(user_id),
                    
				 CONSTRAINT fk_technician
					FOREIGN KEY (technician_id)
					REFERENCES technicians(technician_id)
               
            );           
            
          
DROP TABLE IF EXISTS services;
CREATE TABLE services
            (
                service_id INT PRIMARY KEY AUTO_INCREMENT,	
                service_name VARCHAR(30) NOT NULL,
				hourly_rate INT,
				description VARCHAR(255)
            );
            
DROP TABLE IF EXISTS ticket_services;
CREATE TABLE ticket_services
            (
                ticket_id INT NOT NULL,	
                service_id INT NOT NULL,
				hours_worked DECIMAL(5,2) NOT NULL,
                
                PRIMARY KEY(ticket_id, service_id),
                
                CONSTRAINT fk_ticket_service
					FOREIGN KEY (ticket_id)
					REFERENCES support_tickets(ticket_id),
                    
				CONSTRAINT fk_services
					FOREIGN KEY (service_id)
					REFERENCES services(service_id)
            );
          
DROP TABLE IF EXISTS devices;
CREATE TABLE devices
            (
                device_id INT PRIMARY KEY AUTO_INCREMENT,
                client_id INT NOT NULL,
				user_id INT NOT NULL,
                device_type VARCHAR(255),
                serial_numer INT UNIQUE,
                os VARCHAR(255),
                
                CONSTRAINT fk_user_device
					FOREIGN KEY (user_id)
					REFERENCES users(user_id),
                    
				CONSTRAINT fk_clients_device
					FOREIGN KEY (client_id)
					REFERENCES clients(client_id)
            );
           
DROP TABLE IF EXISTS contracts;
CREATE TABLE contracts
            (
                contract_id INT PRIMARY KEY AUTO_INCREMENT,
                client_id INT NOT NULL,
				contract_type VARCHAR(255),
                start_date DATE,
                end_date DATE,
                monthly_fee DECIMAL(13,2),
                
				CONSTRAINT fk_clients_contract
					FOREIGN KEY (client_id)
					REFERENCES clients(client_id)
            );
            
            
DROP TABLE IF EXISTS invoices;
CREATE TABLE invoices
            (
                invoice_id INT PRIMARY KEY AUTO_INCREMENT,
                client_id INT NOT NULL,
				contract_id INT NOT NULL,
                invoice_date DATETIME,
                total_amount DECIMAL(13,2),
                status ENUM('paid', 'not paid', 'payment proccessing'),
                
				CONSTRAINT fk_clients_invoice
					FOREIGN KEY (client_id)
					REFERENCES clients(client_id),
                    
				CONSTRAINT fk_contract_invoice
					FOREIGN KEY (contract_id)
					REFERENCES contracts(contract_id)
            );
            
            
DROP TABLE IF EXISTS ticket_logs;
CREATE TABLE ticket_logs
            (
                log_id INT PRIMARY KEY AUTO_INCREMENT,
                ticket_id INT NOT NULL,
				technician_id INT NOT NULL,
				ticket_action VARCHAR(255),
                ticket_log_timestamp DATETIME,
                
				CONSTRAINT fk_ticket_logs
					FOREIGN KEY (ticket_id)
					REFERENCES ticket_services(ticket_id),
                    
				CONSTRAINT fk_technician_ticket_logs
					FOREIGN KEY (technician_id)
					REFERENCES technicians(technician_id)
            );
            

DROP TABLE IF EXISTS technician_skills;
CREATE TABLE technician_skills
            (
				technician_id INT NOT NULL,	
                technician_skill VARCHAR(255),
                
                PRIMARY KEY(technician_id, technician_skill),
                
                CONSTRAINT fk_technician_skill
					FOREIGN KEY (technician_id)
					REFERENCES technicians(technician_id)
            );      
            
            
            
-- Add Sample Data --


          -- Client Sample Data --  
INSERT INTO clients (client_id, company_name, contact_name, email, phone, address) VALUES
(1, 'Acme Corp', 'Alice Johnson', 'alice.johnson@acme.com', '555-1010', '123 Main St'),
(2, 'BetaTech LLC', 'Bob Smith', 'bob.smith@betatech.com', '555-1020', '456 Oak Ave'),
(3, 'Gamma Industries', 'Carol Lee', 'carol.lee@gammaind.com', '555-1030', '789 Pine Rd'),
(4, 'Delta Solutions', 'David Kim', 'david.kim@delta.com', '555-1040', '321 Cedar St'),
(5, 'Epsilon Enterprises', 'Emma Davis', 'emma.davis@epsilon.com', '555-1050', '654 Spruce Blvd'),
(6, 'Zeta Tech', 'Zoe Summers', 'zoe.summers@zetatech.com', '555-1060', '987 Maple St'),
(7, 'Eta Solutions', 'Ethan Cole', 'ethan.cole@etasolutions.com', '555-1070', '741 Birch Rd'),
(8, 'Theta Innovations', 'Theresa Green', 'theresa.green@theta.com', '555-1080', '852 Walnut Ave'),
(9, 'Iota Systems', 'Ian Black', 'ian.black@iota.com', '555-1090', '963 Elm Blvd'),
(10, 'Kappa Networks', 'Karen White', 'karen.white@kappa.com', '555-1100', '147 Cherry Ln'),
(11, 'Lambda IT', 'Liam King', 'liam.king@lambda.com', '555-1110', '258 Willow Rd'),
(12, 'Mu Enterprises', 'Mia Scott', 'mia.scott@mu.com', '555-1120', '369 Poplar St'),
(13, 'Nu Dynamics', 'Nathan Hall', 'nathan.hall@nu.com', '555-1130', '159 Aspen St'),
(14, 'Xi Tech', 'Xander Price', 'xander.price@xi.com', '555-1140', '753 Fir Ln'),
(15, 'Omicron Solutions', 'Olivia Reed', 'olivia.reed@omicron.com', '555-1150', '951 Hickory Rd');


		-- User Sample Data --  
INSERT INTO Users (user_id, client_id, user_name, email, user_role) VALUES
(1, 1, 'John Doe', 'john.doe@acme.com', 'client'),
(2, 1, 'Jane Roe', 'jane.roe@acme.com', 'manager'),
(3, 2, 'Sam Wilson', 'sam.wilson@betatech.com', 'client'),
(4, 2, 'Nina Patel', 'nina.patel@betatech.com', 'client'),
(5, 3, 'Tom Hanks', 'tom.hanks@gammaind.com', 'manager'),
(6, 4, 'Lucy Liu', 'lucy.liu@delta.com', 'client'),
(7, 5, 'Mike Brown', 'mike.brown@epsilon.com', 'client'),
(8, 6, 'Paul Turner', 'paul.turner@zetatech.com', 'client'),
(9, 6, 'Linda Zhao', 'linda.zhao@zetatech.com', 'manager'),
(10, 7, 'Brian Adams', 'brian.adams@etasolutions.com', 'client'),
(11, 7, 'Sara Nguyen', 'sara.nguyen@etasolutions.com', 'client'),
(12, 8, 'Kevin Clark', 'kevin.clark@theta.com', 'client'),
(13, 8, 'Julia Kim', 'julia.kim@theta.com', 'manager'),
(14, 9, 'Oscar Reed', 'oscar.reed@iota.com', 'client'),
(15, 9, 'Patricia Long', 'patricia.long@iota.com', 'client'),
(16, 10, 'Quinn Fox', 'quinn.fox@kappa.com', 'manager'),
(17, 10, 'Rita Young', 'rita.young@kappa.com', 'client'),
(18, 11, 'Steve Hall', 'steve.hall@lambda.com', 'client'),
(19, 11, 'Tina Bell', 'tina.bell@lambda.com', 'client'),
(20, 12, 'Uma Clark', 'uma.clark@mu.com', 'client'),
(21, 12, 'Victor Gray', 'victor.gray@mu.com', 'manager'),
(22, 13, 'Wendy Lopez', 'wendy.lopez@nu.com', 'client'),
(23, 13, 'Xavier Cruz', 'xavier.cruz@nu.com', 'client'),
(24, 14, 'Yara Diaz', 'yara.diaz@xi.com', 'manager'),
(25, 14, 'Zane Kim', 'zane.kim@xi.com', 'client'),
(26, 15, 'Aaron Hill', 'aaron.hill@omicron.com', 'client'),
(27, 15, 'Bella Reed', 'bella.reed@omicron.com', 'client'),
(33, 18, 'Frank Moore', 'frank@gamma.com', 'client'),
(34, 18, 'Grace Kim', 'grace@gamma.com', 'client'),
(35, 18, 'Helen Park', 'helen@gamma.com', 'manager'),

(36, 19, 'Ian Lopez', 'ian@delta.com', 'client'),
(37, 19, 'Julia Chen', 'julia@delta.com', 'manager'),

(38, 20, 'Kevin Patel', 'kevin@epsilon.com', 'client'),
(39, 20, 'Laura Nguyen', 'laura@epsilon.com', 'client'),
(40, 20, 'Mark Johnson', 'mark@epsilon.com', 'manager');

SELECT * FROM contracts;

		-- Technican Sample Data --  
INSERT INTO Technicians (technician_id, technician_name, email, skill_level, hire_date) VALUES
(1, 'Alice Tech', 'alice.tech@itsupport.com', 'senior', '2018-02-15'),
(2, 'Bob Fixit', 'bob.fixit@itsupport.com', 'mid', '2019-06-01'),
(3, 'Charlie Repair', 'charlie.repair@itsupport.com', 'junior', '2020-11-20'),
(4, 'Derek Fixit', 'derek.fixit@itsupport.com', 'mid', '2021-03-15'),
(5, 'Eve Tech', 'eve.tech@itsupport.com', 'senior', '2017-08-01'),
(6, 'Frank Repair', 'frank.repair@itsupport.com', 'junior', '2022-06-20'),
(7, 'Grace Code', 'grace.code@itsupport.com', 'mid', '2019-12-05'),
(8, 'Hank Security', 'hank.security@itsupport.com', 'senior', '2016-11-11');


		-- Service Sample Data --
INSERT INTO Services (service_id, service_name, hourly_rate, description) VALUES
(1, 'Network Setup', 100, 'Install and configure client network'),
(2, 'Hardware Repair', 80, 'Repair or replace faulty hardware'),
(3, 'Software Troubleshooting', 70, 'Diagnose and fix software issues'),
(4, 'Security Audit', 120, 'Evaluate client IT security'),
(5, 'Data Backup', 60, 'Set up backup and recovery systems');

		-- Support Ticket Sample Data --
INSERT INTO support_tickets (ticket_id, client_id, user_id, technician_id, ticket_status, created_at, closed_at) VALUES
(1, 1, 1, 1, 'fulfilled', '2026-01-05', '2026-01-06'),
(2, 1, 2, 2, 'in progress', '2026-01-10', NULL),
(3, 2, 3, 1, 'fulfilled', '2026-01-02', '2026-01-03'),
(4, 2, 4, 3, 'in progress', '2026-01-12', NULL),
(5, 3, 5, 1, 'fulfilled', '2026-01-07', '2026-01-08'),
(6, 6, 8, 4, 'fulfilled', '2026-01-05', '2026-01-06'),
(7, 6, 9, 5, 'in progress', '2026-01-07', NULL),
(8, 7, 10, 6, 'fulfilled', '2026-01-03', '2026-01-04'),
(9, 7, 11, 7, 'unfulfilled', '2026-01-09', NULL),
(10, 8, 12, 1, 'fulfilled', '2026-01-02', '2026-01-03'),
(11, 8, 13, 2, 'in progress', '2026-01-06', NULL),
(12, 9, 14, 3, 'fulfilled', '2026-01-01', '2026-01-02'),
(13, 9, 15, 4, 'unfulfilled', '2026-01-08', NULL),
(14, 10, 16, 5, 'fulfilled', '2026-01-04', '2026-01-05'),
(15, 10, 17, 6, 'in progress', '2026-01-11', NULL),
(16, 11, 18, 7, 'fulfilled', '2026-01-05', '2026-01-06'),
(17, 11, 19, 8, 'unfulfilled', '2026-01-07', NULL),
(18, 12, 20, 1, 'fulfilled', '2026-01-02', '2026-01-03'),
(19, 12, 21, 2, 'in progress', '2026-01-06', NULL),
(20, 13, 22, 3, 'fulfilled', '2026-01-01', '2026-01-02'),
(21, 14, 24, 4, 'unfulfilled', '2026-01-08', NULL),
(22, 15, 26, 5, 'fulfilled', '2026-01-04', '2026-01-05'),
(23, 15, 27, 6, 'in progress', '2026-01-11', NULL),
(24, 1, 1, 7, 'fulfilled', '2026-01-03', '2026-01-04'),
(25, 2, 4, 8, 'unfulfilled', '2026-01-07', NULL),
(26, 3, 5, 1, 'fulfilled', '2026-01-02', '2026-01-03'),
(27, 4, 6, 2, 'in progress', '2026-01-06', NULL),
(28, 5, 7, 3, 'fulfilled', '2026-01-01', '2026-01-02'),
(29, 6, 8, 4, 'unfulfilled', '2026-01-08', NULL),
(30, 7, 10, 5, 'fulfilled', '2026-01-03', '2026-01-04');


	-- Ticket Services Sample Data --
INSERT INTO ticket_services (ticket_id, service_id, hours_worked) VALUES
(1, 1, 3),
(1, 3, 2),
(2, 2, 4),
(3, 3, 1),
(4, 1, 5),
(4, 4, 2),
(5, 5, 3);

	-- Device Sample Data --
INSERT INTO devices (device_id, client_id, user_id, device_type, serial_number, os) VALUES
(1, 1, 1, 'Laptop', 'AC12345', 'Windows 11'),
(2, 1, 2, 'Desktop', 'AC12346', 'Windows 10'),
(3, 2, 3, 'Server', 'BT98765', 'Linux'),
(4, 2, 4, 'Laptop', 'BT98766', 'Windows 11'),
(5, 3, 5, 'Desktop', 'GM55555', 'macOS'),
(6, 4, 6, 'Laptop', 'DL33333', 'Windows 11'),
(7, 5, 7, 'Printer', 'EP11111', 'N/A');


-- Adding More Data to Support tickets --
INSERT INTO support_tickets
(ticket_id, client_id, user_id, technician_id, ticket_status, created_at, closed_at)
VALUES
-- Technician 1 (senior, improving over time)
(31, 1, 1, 1, 'fulfilled', '2025-11-01', '2025-11-10'),
(32, 2, 2, 1, 'fulfilled', '2025-11-15', '2025-11-22'),
(33, 3, 3, 1, 'fulfilled', '2026-01-05', '2026-01-06'),
(34, 4, 4, 1, 'fulfilled', '2026-01-07', '2026-01-08'),

-- Technician 2 (consistently slow)
(35, 1, 1, 2, 'fulfilled', '2025-12-01', '2025-12-15'),
(36, 2, 2, 2, 'fulfilled', '2025-12-10', '2025-12-28'),
(37, 3, 3, 2, 'fulfilled', '2026-01-02', '2026-01-20'),

-- Technician 3 (fast performer)
(38, 1, 1, 3, 'fulfilled', '2026-01-01', '2026-01-02'),
(39, 2, 2, 3, 'fulfilled', '2026-01-03', '2026-01-04'),
(40, 3, 3, 3, 'fulfilled', '2026-01-05', '2026-01-06'),

-- Technician 4 (overloaded, works with many clients)
(41, 1, 1, 4, 'fulfilled', '2026-01-01', '2026-01-03'),
(42, 2, 2, 4, 'fulfilled', '2026-01-02', '2026-01-05'),
(43, 3, 3, 4, 'fulfilled', '2026-01-03', '2026-01-07'),
(44, 4, 4, 4, 'fulfilled', '2026-01-04', '2026-01-10'),
(45, 5, 5, 4, 'fulfilled', '2026-01-05', '2026-01-12'),

-- In-progress & unfulfilled tickets
(46, 1, 1, 1, 'in progress', '2026-01-15', NULL),
(47, 2, 2, 2, 'unfulfilled', '2026-01-16', NULL),
(48, 3, 3, 3, 'in progress', '2026-01-17', NULL),
(49, 4, 4, 4, 'unfulfilled', '2026-01-18', NULL),
(50, 5, 5, 1, 'in progress', '2026-01-19', NULL);


-- Data Cleaning --

-- Get rid of 'time' in data. Change to date only --
ALTER TABLE support_tickets
MODIFY COLUMN created_at DATE;

 -- Queries --
 
 -- Find all unfulfilled support tickets --
 SELECT client_id, ticket_id, technician_id, ticket_status
 FROM support_tickets
 WHERE ticket_status != 'fulfilled';
 
 
 -- Get all of the tickets for a specific client --
 SELECT client_id, ticket_id, created_at, ticket_status
 FROM support_tickets
 WHERE client_id = 3;
 
 
 -- Get all of the invoices where the total amount is more than 500 --
 SELECT invoice_id, invoice_date, total_amount
 FROM invoices 
 WHERE total_amount > 500.00;
 
 
 -- Join Queries --
 -- Show the names of the technicians and their specified skills --
 SELECT t.technician_name as technician, s.technician_skill
 FROM technicians t
 JOIN technician_skills s
 ON t.technician_id = s.technician_id
 ORDER BY t.technician_name;
 
 
 -- Show the tickets with technician names --
 SELECT st.ticket_id, t.technician_name AS technician
 FROM support_tickets st
 JOIN technicians t
 ON st.technician_id = t.technician_id;
 
 
 -- Show tickets with client company names
SELECT st.ticket_id, c.company_name, st.ticket_status
FROM support_tickets st
JOIN clients c
ON st.client_id = c.client_id;


-- Find all tickets assinged to junior technicians --
SELECT st.ticket_id, t.technician_name, t.skill_level
FROM support_tickets st
JOIN technicians t
ON st.technician_id = t.technician_id
WHERE t.skill_level = 'junior';
 

-- Find Technician(s) who know AWS basics --
SELECT DISTINCT t.technician_name
FROM technicians t
JOIN technician_skills s
ON t.technician_id = s.technician_id
WHERE s.technician_skill = "AWS Basics";
 
 
 -- Counts --
-- Count tickets per technician --
SELECT technician_id, COUNT(*) as ticket_count
FROM support_tickets
GROUP by technician_id;


-- Count tickets by status --
SELECT ticket_status, COUNT(*) as total
FROM support_tickets
GROUP BY ticket_status;


-- Find technicians with more than 3 tickets --
SELECT technician_id, COUNT(*) AS ticket_count
FROM support_tickets
GROUP BY technician_id
HAVING COUNT(*) > 3;


-- Get all tickets created in Janurary 2026 --
SELECT ticket_id, created_at
FROM support_tickets
WHERE created_at BETWEEN '2026-01-01' AND '2026-01-31';


-- Get average ticket resolution time --
SELECT AVG(DATEDIFF(closed_at,created_at)) as avg_days_to_resolve
FROM support_tickets
WHERE closed_at IS NOT NULL;


-- Find the technician which is working the most --
SELECT t.technician_name, COUNT(*) as ticket_count
FROM support_tickets st
JOIN technicians t
ON st.technician_id = t.technician_id
GROUP BY t.technician_name
ORDER BY ticket_count DESC
LIMIT 1;


-- Find Technicians with no tickets assigned currently --
SELECT t.technician_name
FROM technicians t
LEFT JOIN support_tickets st
ON t.technician_id = st.technician_id
WHERE st.ticket_id is NULL;


-- Find clients who have more than 5 total tickets --
SELECT client_id, COUNT(*) as total_tickets
FROM support_tickets
GROUP BY client_id
HAVING COUNT(*) > 1;


-- Find technicians who worked with 3+ clients --
SELECT technician_id
FROM support_tickets
GROUP by technician_id
HAVING COUNT(DISTINCT client_id) >=3;


-- Find worse than average resolution times --
SELECT technician_id
FROM support_tickets
WHERE closed_at IS NOT NULL
GROUP BY technician_id
HAVING AVG(DATEDIFF(closed_at, created_at)) >
		(SELECT AVG(DATEDIFF(closed_at, created_at))
        FROM support_tickets
        WHERE closed_at IS NOT NULL);


-- Find clients with no fuffilled tickets --
SELECT client_id
FROM support_tickets
GROUP BY client_id
HAVING SUM(ticket_status = 'fulfilled') = 0;


-- Find amount of fulfilled tickets per technician --
SELECT technician_id, COUNT(*) as fulfilled_tickets
FROM support_tickets
WHERE ticket_status = 'fulfilled'
GROUP BY technician_id;


-- Find Tickets that have been open for 1 day --
SELECT ticket_id
from support_tickets
WHERE closed_at IS NOT NULL
	AND DATEDIFF(closed_at, created_at) = 1;
    
    
-- Find tickets which are slower than average --
SELECT st.ticket_id
FROM support_tickets st
JOIN 
	(
	SELECT technician_id, 
			AVG(DATEDIFF(closed_at, created_at)) as average_days
            FROM support_tickets
            WHERE closed_at IS NOT NULL
            GROUP BY technician_id
	)
    average_times
	ON st.technician_id = average_times.technician_id
    WHERE DATEDIFF(st.closed_at, st.created_at) > average_times.average_days;


-- Find a workload imbalance --
SELECT technician_id
FROM support_tickets
GROUP BY technician_id
HAVING COUNT(*) > 
	2 * (SELECT COUNT(*) / COUNT(DISTINCT technician_id)
    FROM support_tickets);
  
  
-- Find users who sumbit the most tickets --
SELECT user_id
FROM support_tickets
GROUP BY user_id
ORDER BY COUNT(*) DESC
LIMIT 1;



-- Count contracts per type --
SELECT contract_type, COUNT(*) AS total_contracts
FROM contracts
GROUP BY contract_type;


-- Find expired contracts --
SELECT contract_id, client_id, end_date
FROM contracts
WHERE end_date < CURDATE();


-- Find Contracts that overlap --
SELECT c1.client_id, c1.contract_id AS contract_a, c2.contract_id AS contract_b
FROM contracts c1
JOIN contracts c2
  ON c1.client_id = c2.client_id
  AND c1.contract_id < c2.contract_id
  AND c1.start_date <= c2.end_date
  AND c2.start_date <= c1.end_date;
  
 -- Find Resolution time by skill level -- 
 -- Supports promotion decisons --
SELECT
  t.skill_level,
  COUNT(*) AS tickets_closed,
  ROUND(AVG(TIMESTAMPDIFF(HOUR, st.created_at, st.closed_at)), 2)
    AS avg_resolution_hours
FROM support_tickets st
JOIN technicians t ON st.technician_id = t.technician_id
WHERE st.closed_at IS NOT NULL
GROUP BY t.skill_level;

-- Ticket distrubution upon technicians --
-- Make sure tickets are distributed properly --
SELECT
  t.technician_name,
  COUNT(st.ticket_id) AS total_tickets
FROM technicians t
LEFT JOIN support_tickets st ON t.technician_id = st.technician_id
GROUP BY t.technician_id
ORDER BY total_tickets DESC;

-- Which clients submit the most support tickets --
SELECT
  c.company_name,
  COUNT(st.ticket_id) AS total_tickets
FROM clients c
JOIN support_tickets st ON c.client_id = st.client_id
GROUP BY c.client_id
ORDER BY total_tickets DESC;

-- Ticket Growth by month --
SELECT
  DATE_FORMAT(created_at, '%Y-%m') AS month,
  COUNT(*) AS tickets_created
FROM support_tickets
GROUP BY month
ORDER BY month;




