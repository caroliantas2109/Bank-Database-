/* 
   Purpose: Define tables for SKS National Bank (matches ERD)
*/

USE BankDB;
GO

-- Address
CREATE TABLE dbo.address (
    address_id   INT IDENTITY(1,1) PRIMARY KEY,
    street       VARCHAR(255) NOT NULL,
    city         VARCHAR(100) NOT NULL,
    province     VARCHAR(100) NOT NULL,
    postal_code  VARCHAR(20)  NOT NULL,
    country      VARCHAR(100) NOT NULL DEFAULT ('Canada'),
    notes        NVARCHAR(MAX) NULL,
    created_at   DATETIME NOT NULL DEFAULT GETDATE(),
    updated_at   DATETIME NOT NULL DEFAULT GETDATE()
);

-- Branch
CREATE TABLE dbo.branch (
    branch_id       INT IDENTITY(1,1) PRIMARY KEY,
    name            VARCHAR(100) NOT NULL UNIQUE,
    address_id      INT NULL,
    total_deposits  DECIMAL(18,2) NOT NULL DEFAULT (0),
    total_loans     DECIMAL(18,2) NOT NULL DEFAULT (0),
    created_at      DATETIME NOT NULL DEFAULT GETDATE(),
    updated_at      DATETIME NOT NULL DEFAULT GETDATE()
);

-- Location
CREATE TABLE dbo.location (
    location_id INT IDENTITY(1,1) PRIMARY KEY,
    name        VARCHAR(150) NOT NULL,
    address_id  INT NULL,
    is_branch   BIT NOT NULL DEFAULT (0),
    branch_id   INT NULL,
    notes       NVARCHAR(MAX) NULL,
    created_at  DATETIME NOT NULL DEFAULT GETDATE(),
    updated_at  DATETIME NOT NULL DEFAULT GETDATE()
);

-- Employee
CREATE TABLE dbo.employee (
    employee_id INT IDENTITY(1,1) PRIMARY KEY,
    first_name  VARCHAR(50) NOT NULL,
    last_name   VARCHAR(50) NOT NULL,
    address_id  INT NULL,
    start_date  DATE NOT NULL,
    manager_id  INT NULL,
    job_title   VARCHAR(100) NOT NULL,
    created_at  DATETIME NOT NULL DEFAULT GETDATE(),
    updated_at  DATETIME NOT NULL DEFAULT GETDATE()
);

-- Employee ↔ Location
CREATE TABLE dbo.employee_location (
    employee_id INT NOT NULL,
    location_id INT NOT NULL,
    role        VARCHAR(50) NOT NULL,
    PRIMARY KEY (employee_id, location_id)
);

-- Customer
CREATE TABLE dbo.customer (
    customer_id INT IDENTITY(1,1) PRIMARY KEY,
    first_name  VARCHAR(50) NOT NULL,
    last_name   VARCHAR(50) NOT NULL,
    address_id  INT NULL,
    created_at  DATETIME NOT NULL DEFAULT GETDATE(),
    updated_at  DATETIME NOT NULL DEFAULT GETDATE()
);

-- Customer ↔ Employee
CREATE TABLE dbo.customer_employee (
    customer_id INT NOT NULL,
    employee_id INT NOT NULL,
    role        VARCHAR(50) NOT NULL,
    PRIMARY KEY (customer_id, employee_id)
);

-- Account Type
CREATE TABLE dbo.account_type (
    account_type_id INT IDENTITY(1,1) PRIMARY KEY,
    code            VARCHAR(10) NOT NULL UNIQUE,
    description     VARCHAR(255) NOT NULL,
    created_at      DATETIME NOT NULL DEFAULT GETDATE(),
    updated_at      DATETIME NOT NULL DEFAULT GETDATE()
);

-- Account
CREATE TABLE dbo.account (
    account_id        INT IDENTITY(1,1) PRIMARY KEY,
    account_type_id   INT NOT NULL,
    balance           DECIMAL(18,2) NOT NULL DEFAULT (0),
    last_access_date  DATETIME NULL,
    created_at        DATETIME NOT NULL DEFAULT GETDATE(),
    updated_at        DATETIME NOT NULL DEFAULT GETDATE()
);

-- Account Holder
CREATE TABLE dbo.account_holder (
    account_id        INT NOT NULL,
    customer_id       INT NOT NULL,
    ownership_percent DECIMAL(5,2) NOT NULL,
    PRIMARY KEY (account_id, customer_id)
);

-- Savings Account
CREATE TABLE dbo.savings_account (
    account_id    INT PRIMARY KEY,
    interest_rate DECIMAL(6,4) NULL
);

-- Chequing Account
CREATE TABLE dbo.chequing_account (
    account_id INT PRIMARY KEY
);

-- Overdraft
CREATE TABLE dbo.overdraft (
    overdraft_id INT IDENTITY(1,1) PRIMARY KEY,
    account_id   INT NOT NULL,
    date         DATE NOT NULL,
    amount       DECIMAL(18,2) NOT NULL,
    check_number VARCHAR(50) NULL,
    created_at   DATETIME NOT NULL DEFAULT GETDATE(),
    updated_at   DATETIME NOT NULL DEFAULT GETDATE()
);

-- Loan
CREATE TABLE dbo.loan (
    loan_id             INT IDENTITY(1,1) PRIMARY KEY,
    origin_branch_id    INT NOT NULL,
    loan_amount         DECIMAL(18,2) NOT NULL,
    outstanding_balance DECIMAL(18,2) NOT NULL,
    created_at          DATETIME NOT NULL DEFAULT GETDATE(),
    updated_at          DATETIME NOT NULL DEFAULT GETDATE()
);

-- Loan Holder
CREATE TABLE dbo.loan_holder (
    loan_id       INT NOT NULL,
    customer_id   INT NOT NULL,
    share_percent DECIMAL(5,2) NOT NULL,
    PRIMARY KEY (loan_id, customer_id)
);

-- Loan Payment
CREATE TABLE dbo.loan_payment (
    loan_id        INT NOT NULL,
    payment_number INT NOT NULL,
    payment_date   DATE NOT NULL,
    amount         DECIMAL(18,2) NOT NULL,
    created_at     DATETIME NOT NULL DEFAULT GETDATE(),
    PRIMARY KEY (loan_id, payment_number)
);