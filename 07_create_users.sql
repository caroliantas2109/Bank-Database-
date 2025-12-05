-- ============================================
-- CREATE LOGINS AND USERS WITH PRIVILEGES
-- ============================================

USE master;
GO

-- Create login for customer group
CREATE LOGIN customer_group_A 
WITH PASSWORD = 'customer',
     DEFAULT_DATABASE = BankDB,
     CHECK_EXPIRATION = OFF,
     CHECK_POLICY = OFF;
GO

-- Create login for accountant group
CREATE LOGIN accountant_group_A
WITH PASSWORD = 'accountant',
     DEFAULT_DATABASE = BankDB,
     CHECK_EXPIRATION = OFF,
     CHECK_POLICY = OFF;
GO

-- Switch to BankDB database
USE BankDB;
GO

-- Create user for customer group
CREATE USER customer_group_A 
FOR LOGIN customer_group_A
WITH DEFAULT_SCHEMA = dbo;
GO

-- Create user for accountant group
CREATE USER accountant_group_A
FOR LOGIN accountant_group_A
WITH DEFAULT_SCHEMA = dbo;
GO

-- ============================================
-- GRANT PRIVILEGES
-- ============================================

-- For customer_group_A: Read-only access to customer-related tables
GRANT SELECT ON dbo.customer TO customer_group_A;
GRANT SELECT ON dbo.account TO customer_group_A;
GRANT SELECT ON dbo.account_holder TO customer_group_A;
GRANT SELECT ON dbo.account_type TO customer_group_A;
GRANT SELECT ON dbo.loan TO customer_group_A;
GRANT SELECT ON dbo.loan_holder TO customer_group_A;
GRANT SELECT ON dbo.loan_payment TO customer_group_A;
GRANT SELECT ON dbo.savings_account TO customer_group_A;
GRANT SELECT ON dbo.chequing_account TO customer_group_A;
GRANT SELECT ON dbo.overdraft TO customer_group_A;

-- Grant EXECUTE on stored procedures related to customers
GRANT EXECUTE ON dbo.spGetCustomerAccounts TO customer_group_A;
GRANT EXECUTE ON dbo.spGetLoanSummaryByCustomer TO customer_group_A;
GRANT EXECUTE ON dbo.spSearchCustomers TO customer_group_A;

-- Grant EXECUTE on functions related to customers
GRANT EXECUTE ON dbo.fnTotalOwnershipPercent TO customer_group_A;
GRANT EXECUTE ON dbo.fnAccountAgingDays TO customer_group_A;

-- Deny all other permissions for customer user
DENY INSERT, UPDATE, DELETE ON SCHEMA::dbo TO customer_group_A;
DENY ALTER ON SCHEMA::dbo TO customer_group_A;
DENY CONTROL ON SCHEMA::dbo TO customer_group_A;

-- For accountant_group_A: Read access to ALL tables
GRANT SELECT ON SCHEMA::dbo TO accountant_group_A;
GO

-- Grant EXECUTE on ALL stored procedures and functions
GRANT EXECUTE ON SCHEMA::dbo TO accountant_group_A;
GO

-- Deny write access to financial tables
DENY INSERT, UPDATE, DELETE ON dbo.account TO accountant_group_A;
DENY INSERT, UPDATE, DELETE ON dbo.account_holder TO accountant_group_A;
DENY INSERT, UPDATE, DELETE ON dbo.loan TO accountant_group_A;
DENY INSERT, UPDATE, DELETE ON dbo.loan_holder TO accountant_group_A;
DENY INSERT, UPDATE, DELETE ON dbo.loan_payment TO accountant_group_A;
DENY INSERT, UPDATE, DELETE ON dbo.savings_account TO accountant_group_A;
DENY INSERT, UPDATE, DELETE ON dbo.chequing_account TO accountant_group_A;
DENY INSERT, UPDATE, DELETE ON dbo.overdraft TO accountant_group_A;

-- Deny EXECUTE on procedures that modify financial data
DENY EXECUTE ON dbo.spRecordLoanPayment TO accountant_group_A;
DENY EXECUTE ON dbo.spTransferFunds TO accountant_group_A;
DENY EXECUTE ON dbo.spCreateNewAccount TO accountant_group_A;
DENY EXECUTE ON dbo.spUpdateAccountBalance TO accountant_group_A;
GO

-- Grant write access to non-financial tables for accountant
GRANT INSERT, UPDATE, DELETE ON dbo.address TO accountant_group_A;
GRANT INSERT, UPDATE, DELETE ON dbo.branch TO accountant_group_A;
GRANT INSERT, UPDATE, DELETE ON dbo.location TO accountant_group_A;
GRANT INSERT, UPDATE, DELETE ON dbo.employee TO accountant_group_A;
GRANT INSERT, UPDATE, DELETE ON dbo.employee_location TO accountant_group_A;
GRANT INSERT, UPDATE, DELETE ON dbo.customer_employee TO accountant_group_A;
GRANT INSERT, UPDATE, DELETE ON dbo.account_type TO accountant_group_A;

-- Grant EXECUTE on procedures for non-financial operations
GRANT EXECUTE ON dbo.spAddNewCustomer TO accountant_group_A;
GRANT EXECUTE ON dbo.spGetBranchFinancialSummary TO accountant_group_A;
GRANT EXECUTE ON dbo.spGetOverdraftsForAccount TO accountant_group_A;
GRANT SELECT ON dbo.fnBranchExposure TO accountant_group_A;
GO

PRINT '============================================';
PRINT 'USER CREATION COMPLETE';
PRINT '============================================';
PRINT 'Created users:';
PRINT '1. customer_group_A (password: customer)';
PRINT '2. accountant_group_A (password: accountant)';
GO