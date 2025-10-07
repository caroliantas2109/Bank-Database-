/* 
   Purpose: Insert sample data into SKS National Bank
*/

/* HERE TO POPULATE */
USE BankDB;
GO

/*Address Table*/
INSERT INTO dbo.address (street, city, province, postal_code, country, notes)
VALUES
('123 Main Street', 'Toronto', 'Ontario', 'M5H 2N2', 'Canada', 'Downtown location'),
('456 Oak Avenue', 'Vancouver', 'British Columbia', 'V6B 1A1', 'Canada', 'West End area'),
('789 Maple Road', 'Montreal', 'Quebec', 'H3A 1A1', 'Canada', 'Business district'),
('321 Pine Street', 'Calgary', 'Alberta', 'T2P 1J9', 'Canada', 'City center'),
('654 Elm Boulevard', 'Ottawa', 'Ontario', 'K1P 5E7', 'Canada', 'Government area'),
('987 Cedar Lane', 'Edmonton', 'Alberta', 'T5J 2B6', 'Canada', 'North side'),
('147 Birch Drive', 'Winnipeg', 'Manitoba', 'R3C 0N2', 'Canada', 'Residential area'),
('258 Spruce Court', 'Halifax', 'Nova Scotia', 'B3J 1M4', 'Canada', 'Waterfront'),
('369 Willow Way', 'Victoria', 'British Columbia', 'V8W 1S6', 'Canada', 'Near harbor'),
('741 Aspen Circle', 'Saskatoon', 'Saskatchewan', 'S7K 0J5', 'Canada', 'University district'),
('852 Cherry Street', 'Regina', 'Saskatchewan', 'S4P 3Y2', 'Canada', 'Downtown core'),
('963 Poplar Avenue', 'Quebec City', 'Quebec', 'G1R 4P5', 'Canada', 'Old town'),
('159 Fir Road', 'London', 'Ontario', 'N6A 1M3', 'Canada', 'Residential'),
('357 Hemlock Lane', 'Kitchener', 'Ontario', 'N2G 4X1', 'Canada', 'Tech hub area'),
('486 Redwood Drive', 'Mississauga', 'Ontario', 'L5B 3Y3', 'Canada', 'Suburban location');

/*Branch*/
INSERT INTO dbo.branch (name, address_id, total_deposits, total_loans)
VALUES
('Toronto Main Branch', 1, 15000000.00, 8000000.00),
('Vancouver Downtown', 2, 12000000.00, 6500000.00),
('Montreal Central', 3, 10000000.00, 5000000.00),
('Calgary Tower Branch', 4, 9500000.00, 4800000.00),
('Ottawa Parliament', 5, 8000000.00, 4200000.00),
('Edmonton North', 6, 7500000.00, 3900000.00),
('Winnipeg Exchange', 7, 6800000.00, 3500000.00),
('Halifax Waterfront', 8, 6200000.00, 3200000.00),
('Victoria Harbor', 9, 5900000.00, 3000000.00),
('Saskatoon University', 10, 5500000.00, 2800000.00),
('Regina Downtown', 11, 5200000.00, 2600000.00),
('Quebec Old Port', 12, 4900000.00, 2400000.00),
('London Central', 13, 4600000.00, 2300000.00),
('Kitchener Tech Hub', 14, 4300000.00, 2100000.00),
('Mississauga Square', 15, 4000000.00, 2000000.00);

/*Locations*/
INSERT INTO dbo.location (name, address_id, is_branch, branch_id, notes)
VALUES
('Toronto Main Branch', 1, 1, 1, 'Primary branch location'),
('Vancouver Downtown', 2, 1, 2, 'Branch office'),
('Montreal Central', 3, 1, 3, 'Branch office'),
('Calgary Tower Branch', 4, 1, 4, 'Branch office'),
('Ottawa Parliament', 5, 1, 5, 'Branch office'),
('Toronto ATM - Mall', 1, 0, 1, 'ATM in shopping center'),
('Vancouver ATM - Airport', 2, 0, 2, 'Airport terminal ATM'),
('Montreal ATM - Station', 3, 0, 3, 'Train station ATM'),
('Calgary ATM - Hospital', 4, 0, 4, 'Medical center ATM'),
('Ottawa ATM - University', 5, 0, 5, 'Campus ATM location'),
('Edmonton North', 6, 1, 6, 'Branch office'),
('Winnipeg Exchange', 7, 1, 7, 'Branch office'),
('Halifax Waterfront', 8, 1, 8, 'Branch office'),
('Victoria Harbor', 9, 1, 9, 'Branch office'),
('Saskatoon University', 10, 1, 10, 'Branch office');

/*Employee*/
INSERT INTO dbo.employee (first_name, last_name, address_id, start_date, manager_id, job_title)
VALUES
('Sarah', 'Johnson', 1, '2015-03-15', NULL, 'Regional Manager'),
('Michael', 'Chen', 2, '2016-07-22', 1, 'Branch Manager'),
('Emily', 'Rodriguez', 3, '2017-01-10', 1, 'Branch Manager'),
('David', 'Thompson', 4, '2018-04-18', 2, 'Loan Officer'),
('Jessica', 'Williams', 5, '2019-09-05', 2, 'Customer Service Representative'),
('Robert', 'Brown', 6, '2017-11-30', 3, 'Loan Officer'),
('Amanda', 'Davis', 7, '2020-02-14', 3, 'Teller'),
('Christopher', 'Wilson', 8, '2018-08-20', 1, 'Branch Manager'),
('Jennifer', 'Martinez', 9, '2019-05-12', 8, 'Financial Advisor'),
('Matthew', 'Anderson', 10, '2021-01-25', 8, 'Customer Service Representative'),
('Ashley', 'Taylor', 11, '2016-10-08', 1, 'Branch Manager'),
('Daniel', 'Garcia', 12, '2020-06-17', 11, 'Loan Officer'),
('Michelle', 'Lee', 13, '2019-12-03', 11, 'Teller'),
('James', 'White', 14, '2021-03-22', 2, 'Financial Advisor'),
('Laura', 'Harris', 15, '2018-07-09', 3, 'Customer Service Representative');

/*Employee_Location*/

/* 
   Purpose: Populate SKS National Bank database with 15 records per table
*/

USE BankDB;
GO

-- =============================================
-- 1. ADDRESS (15 records)
-- =============================================
INSERT INTO dbo.address (street, city, province, postal_code, country, notes)
VALUES
('123 Main Street', 'Toronto', 'Ontario', 'M5H 2N2', 'Canada', 'Downtown location'),
('456 Oak Avenue', 'Vancouver', 'British Columbia', 'V6B 1A1', 'Canada', 'West End area'),
('789 Maple Road', 'Montreal', 'Quebec', 'H3A 1A1', 'Canada', 'Business district'),
('321 Pine Street', 'Calgary', 'Alberta', 'T2P 1J9', 'Canada', 'City center'),
('654 Elm Boulevard', 'Ottawa', 'Ontario', 'K1P 5E7', 'Canada', 'Government area'),
('987 Cedar Lane', 'Edmonton', 'Alberta', 'T5J 2B6', 'Canada', 'North side'),
('147 Birch Drive', 'Winnipeg', 'Manitoba', 'R3C 0N2', 'Canada', 'Residential area'),
('258 Spruce Court', 'Halifax', 'Nova Scotia', 'B3J 1M4', 'Canada', 'Waterfront'),
('369 Willow Way', 'Victoria', 'British Columbia', 'V8W 1S6', 'Canada', 'Near harbor'),
('741 Aspen Circle', 'Saskatoon', 'Saskatchewan', 'S7K 0J5', 'Canada', 'University district'),
('852 Cherry Street', 'Regina', 'Saskatchewan', 'S4P 3Y2', 'Canada', 'Downtown core'),
('963 Poplar Avenue', 'Quebec City', 'Quebec', 'G1R 4P5', 'Canada', 'Old town'),
('159 Fir Road', 'London', 'Ontario', 'N6A 1M3', 'Canada', 'Residential'),
('357 Hemlock Lane', 'Kitchener', 'Ontario', 'N2G 4X1', 'Canada', 'Tech hub area'),
('486 Redwood Drive', 'Mississauga', 'Ontario', 'L5B 3Y3', 'Canada', 'Suburban location');

-- =============================================
-- 2. BRANCH (15 records)
-- =============================================
INSERT INTO dbo.branch (name, address_id, total_deposits, total_loans)
VALUES
('Toronto Main Branch', 1, 15000000.00, 8000000.00),
('Vancouver Downtown', 2, 12000000.00, 6500000.00),
('Montreal Central', 3, 10000000.00, 5000000.00),
('Calgary Tower Branch', 4, 9500000.00, 4800000.00),
('Ottawa Parliament', 5, 8000000.00, 4200000.00),
('Edmonton North', 6, 7500000.00, 3900000.00),
('Winnipeg Exchange', 7, 6800000.00, 3500000.00),
('Halifax Waterfront', 8, 6200000.00, 3200000.00),
('Victoria Harbor', 9, 5900000.00, 3000000.00),
('Saskatoon University', 10, 5500000.00, 2800000.00),
('Regina Downtown', 11, 5200000.00, 2600000.00),
('Quebec Old Port', 12, 4900000.00, 2400000.00),
('London Central', 13, 4600000.00, 2300000.00),
('Kitchener Tech Hub', 14, 4300000.00, 2100000.00),
('Mississauga Square', 15, 4000000.00, 2000000.00);

-- =============================================
-- 3. LOCATION (15 records)
-- =============================================
INSERT INTO dbo.location (name, address_id, is_branch, branch_id, notes)
VALUES
('Toronto Main Branch', 1, 1, 1, 'Primary branch location'),
('Vancouver Downtown', 2, 1, 2, 'Branch office'),
('Montreal Central', 3, 1, 3, 'Branch office'),
('Calgary Tower Branch', 4, 1, 4, 'Branch office'),
('Ottawa Parliament', 5, 1, 5, 'Branch office'),
('Toronto ATM - Mall', 1, 0, 1, 'ATM in shopping center'),
('Vancouver ATM - Airport', 2, 0, 2, 'Airport terminal ATM'),
('Montreal ATM - Station', 3, 0, 3, 'Train station ATM'),
('Calgary ATM - Hospital', 4, 0, 4, 'Medical center ATM'),
('Ottawa ATM - University', 5, 0, 5, 'Campus ATM location'),
('Edmonton North', 6, 1, 6, 'Branch office'),
('Winnipeg Exchange', 7, 1, 7, 'Branch office'),
('Halifax Waterfront', 8, 1, 8, 'Branch office'),
('Victoria Harbor', 9, 1, 9, 'Branch office'),
('Saskatoon University', 10, 1, 10, 'Branch office');

-- =============================================
-- 4. EMPLOYEE (15 records)
-- =============================================
INSERT INTO dbo.employee (first_name, last_name, address_id, start_date, manager_id, job_title)
VALUES
('Sarah', 'Johnson', 1, '2015-03-15', NULL, 'Regional Manager'),
('Michael', 'Chen', 2, '2016-07-22', 1, 'Branch Manager'),
('Emily', 'Rodriguez', 3, '2017-01-10', 1, 'Branch Manager'),
('David', 'Thompson', 4, '2018-04-18', 2, 'Loan Officer'),
('Jessica', 'Williams', 5, '2019-09-05', 2, 'Customer Service Representative'),
('Robert', 'Brown', 6, '2017-11-30', 3, 'Loan Officer'),
('Amanda', 'Davis', 7, '2020-02-14', 3, 'Teller'),
('Christopher', 'Wilson', 8, '2018-08-20', 1, 'Branch Manager'),
('Jennifer', 'Martinez', 9, '2019-05-12', 8, 'Financial Advisor'),
('Matthew', 'Anderson', 10, '2021-01-25', 8, 'Customer Service Representative'),
('Ashley', 'Taylor', 11, '2016-10-08', 1, 'Branch Manager'),
('Daniel', 'Garcia', 12, '2020-06-17', 11, 'Loan Officer'),
('Michelle', 'Lee', 13, '2019-12-03', 11, 'Teller'),
('James', 'White', 14, '2021-03-22', 2, 'Financial Advisor'),
('Laura', 'Harris', 15, '2018-07-09', 3, 'Customer Service Representative');

-- =============================================
-- 5. EMPLOYEE_LOCATION (15 records)
-- =============================================
INSERT INTO dbo.employee_location (employee_id, location_id, role)
VALUES
(1, 1, 'Regional Supervisor'),
(2, 2, 'Branch Manager'),
(3, 3, 'Branch Manager'),
(4, 2, 'Loan Officer'),
(5, 2, 'CSR'),
(6, 3, 'Loan Officer'),
(7, 3, 'Teller'),
(8, 8, 'Branch Manager'),
(9, 9, 'Financial Advisor'),
(10, 8, 'CSR'),
(11, 11, 'Branch Manager'),
(12, 11, 'Loan Officer'),
(13, 11, 'Teller'),
(14, 2, 'Financial Advisor'),
(15, 3, 'CSR');

/*Customer*/
INSERT INTO dbo.customer (first_name, last_name, address_id)
VALUES
('John', 'Smith', 1),
('Maria', 'Gonzalez', 2),
('William', 'Jones', 3),
('Linda', 'Miller', 4),
('Richard', 'Davis', 5),
('Patricia', 'Moore', 6),
('Charles', 'Taylor', 7),
('Barbara', 'Anderson', 8),
('Joseph', 'Thomas', 9),
('Susan', 'Jackson', 10),
('Thomas', 'Martin', 11),
('Karen', 'Thompson', 12),
('Donald', 'White', 13),
('Nancy', 'Clark', 14),
('Paul', 'Lewis', 15);

/*Customer_Employee*/
INSERT INTO dbo.customer_employee (customer_id, employee_id, role)
VALUES
(1, 4, 'Primary Banker'),
(2, 4, 'Primary Banker'),
(3, 6, 'Primary Banker'),
(4, 6, 'Primary Banker'),
(5, 12, 'Primary Banker'),
(6, 2, 'Account Manager'),
(7, 3, 'Account Manager'),
(8, 8, 'Account Manager'),
(9, 9, 'Financial Advisor'),
(10, 9, 'Financial Advisor'),
(11, 14, 'Financial Advisor'),
(12, 5, 'Customer Service'),
(13, 7, 'Customer Service'),
(14, 10, 'Customer Service'),
(15, 15, 'Customer Service');

/*Account Type*/
INSERT INTO dbo.account_type (code, description)
VALUES
('CHK-STD', 'Standard Chequing Account'),
('CHK-PRE', 'Premium Chequing Account'),
('CHK-STU', 'Student Chequing Account'),
('SAV-STD', 'Standard Savings Account'),
('SAV-HI', 'High Interest Savings Account'),
('SAV-TFSA', 'Tax-Free Savings Account'),
('SAV-RRSP', 'Registered Retirement Savings Plan'),
('CHK-BUS', 'Business Chequing Account'),
('SAV-RESP', 'Registered Education Savings Plan'),
('CHK-SEN', 'Senior Chequing Account'),
('SAV-USD', 'US Dollar Savings Account'),
('CHK-USD', 'US Dollar Chequing Account'),
('SAV-CHLD', 'Children Savings Account'),
('CHK-JONT', 'Joint Chequing Account'),
('SAV-EMRG', 'Emergency Fund Savings Account');

/*Account*/
INSERT INTO dbo.account (account_type_id, balance, last_access_date)
VALUES
(1, 2500.75, '2024-10-05'),
(4, 15000.00, '2024-10-06'),
(2, 5200.50, '2024-10-04'),
(5, 25000.00, '2024-10-01'),
(3, 850.25, '2024-10-07'),
(6, 10000.00, '2024-09-28'),
(1, 3200.00, '2024-10-06'),
(4, 8500.50, '2024-10-02'),
(7, 45000.00, '2024-09-15'),
(2, 4750.25, '2024-10-05'),
(8, 12000.00, '2024-10-03'),
(5, 18500.75, '2024-10-01'),
(3, 625.00, '2024-10-07'),
(1, 1850.50, '2024-10-06'),
(9, 5500.00, '2024-09-20');

/*Account Holder*/
INSERT INTO dbo.account_holder (account_id, customer_id, ownership_percent)
VALUES
(1, 1, 100.00),
(2, 1, 100.00),
(3, 2, 100.00),
(4, 2, 100.00),
(5, 3, 100.00),
(6, 4, 100.00),
(7, 5, 100.00),
(8, 6, 100.00),
(9, 7, 100.00),
(10, 8, 100.00),
(11, 9, 100.00),
(12, 10, 100.00),
(13, 11, 100.00),
(14, 12, 100.00),
(15, 13, 100.00);

/*Savings Account*/
INSERT INTO dbo.savings_account (account_id, interest_rate)
VALUES
(2, 2.5000),
(4, 3.2500),
(6, 2.0000),
(8, 2.7500),
(9, 1.5000),
(12, 3.0000),
(15, 1.7500)

/*Checking Account*/
INSERT INTO dbo.chequing_account (account_id)
VALUES
(1),
(3),
(5),
(7),
(10),
(11),
(13),
(14);

/*Overdraft*/
INSERT INTO dbo.overdraft (account_id, date, amount, check_number)
VALUES
(1, '2024-09-15', 125.50, 'CHK-1001'),
(3, '2024-09-20', 85.75, 'CHK-1002'),
(5, '2024-09-22', 45.00, NULL),
(7, '2024-09-25', 200.25, 'CHK-1003'),
(1, '2024-09-28', 75.50, 'CHK-1004'),
(10, '2024-10-01', 150.00, NULL),
(3, '2024-10-02', 95.25, 'CHK-1005'),
(11, '2024-10-03', 110.75, NULL),
(5, '2024-10-04', 60.00, 'CHK-1006'),
(13, '2024-10-05', 180.50, NULL),
(1, '2024-10-06', 90.25, 'CHK-1007'),
(7, '2024-10-06', 135.00, NULL),
(14, '2024-10-07', 105.75, 'CHK-1008'),
(3, '2024-10-07', 70.50, NULL),
(10, '2024-10-07', 195.25, 'CHK-1009');

/*Loan*/
INSERT INTO dbo.loan (origin_branch_id, loan_amount, outstanding_balance)
VALUES
(1, 250000.00, 235000.00),
(2, 180000.00, 165000.00),
(3, 350000.00, 340000.00),
(1, 45000.00, 38000.00),
(4, 200000.00, 185000.00),
(2, 75000.00, 68000.00),
(5, 420000.00, 410000.00),
(3, 25000.00, 20000.00),
(1, 150000.00, 135000.00),
(6, 90000.00, 82000.00),
(4, 300000.00, 285000.00),
(2, 55000.00, 48000.00),
(7, 175000.00, 160000.00),
(5, 210000.00, 195000.00),
(3, 125000.00, 110000.00);

/*Loan Holder*/
INSERT INTO dbo.loan_holder (loan_id, customer_id, share_percent)
VALUES
(1, 1, 100.00),
(2, 2, 100.00),
(3, 3, 100.00),
(4, 4, 100.00),
(5, 5, 100.00),
(6, 6, 100.00),
(7, 7, 100.00),
(8, 8, 100.00),
(9, 9, 100.00),
(10, 10, 100.00),
(11, 11, 100.00),
(12, 12, 100.00),
(13, 13, 100.00),
(14, 14, 100.00),
(15, 15, 100.00);

/*Loan Payment*/
INSERT INTO dbo.loan_payment (loan_id, payment_number, payment_date, amount)
VALUES
(1, 1, '2024-01-15', 1500.00),
(1, 2, '2024-02-15', 1500.00),
(2, 1, '2024-03-10', 1200.00),
(3, 1, '2024-04-05', 2000.00),
(4, 1, '2024-05-20', 800.00),
(5, 1, '2024-06-15', 1350.00),
(6, 1, '2024-07-10', 950.00),
(2, 2, '2024-04-10', 1200.00),
(7, 1, '2024-08-01', 2500.00),
(8, 1, '2024-08-25', 650.00),
(9, 1, '2024-09-15', 1100.00),
(10, 1, '2024-09-30', 1000.00),
(11, 1, '2024-10-05', 1750.00),
(3, 2, '2024-05-05', 2000.00),
(12, 1, '2024-10-07', 900.00);