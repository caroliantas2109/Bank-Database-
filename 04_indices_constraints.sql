/* 
   Purpose: Define foreign keys, constraints, and indexes
*/

USE BankDB;
GO

-- Address relationships
ALTER TABLE dbo.branch 
  ADD CONSTRAINT FK_branch_address 
  FOREIGN KEY (address_id) REFERENCES dbo.address(address_id);

ALTER TABLE dbo.location 
  ADD CONSTRAINT FK_location_address 
  FOREIGN KEY (address_id) REFERENCES dbo.address(address_id);

ALTER TABLE dbo.employee 
  ADD CONSTRAINT FK_employee_address 
  FOREIGN KEY (address_id) REFERENCES dbo.address(address_id);

ALTER TABLE dbo.customer 
  ADD CONSTRAINT FK_customer_address 
  FOREIGN KEY (address_id) REFERENCES dbo.address(address_id);

-- Branch relationships
ALTER TABLE dbo.location 
  ADD CONSTRAINT FK_location_branch 
  FOREIGN KEY (branch_id) REFERENCES dbo.branch(branch_id);

ALTER TABLE dbo.loan 
  ADD CONSTRAINT FK_loan_branch 
  FOREIGN KEY (origin_branch_id) REFERENCES dbo.branch(branch_id);

-- Employee relationships
ALTER TABLE dbo.employee 
  ADD CONSTRAINT FK_employee_manager 
  FOREIGN KEY (manager_id) REFERENCES dbo.employee(employee_id);

-- Bridge table relationships
ALTER TABLE dbo.employee_location 
  ADD CONSTRAINT FK_employee_location_employee 
  FOREIGN KEY (employee_id) REFERENCES dbo.employee(employee_id);

ALTER TABLE dbo.employee_location 
  ADD CONSTRAINT FK_employee_location_location 
  FOREIGN KEY (location_id) REFERENCES dbo.location(location_id);

ALTER TABLE dbo.customer_employee 
  ADD CONSTRAINT FK_customer_employee_customer 
  FOREIGN KEY (customer_id) REFERENCES dbo.customer(customer_id);

ALTER TABLE dbo.customer_employee 
  ADD CONSTRAINT FK_customer_employee_employee 
  FOREIGN KEY (employee_id) REFERENCES dbo.employee(employee_id);

-- Account relationships
ALTER TABLE dbo.account 
  ADD CONSTRAINT FK_account_account_type 
  FOREIGN KEY (account_type_id) REFERENCES dbo.account_type(account_type_id);

ALTER TABLE dbo.account_holder 
  ADD CONSTRAINT FK_account_holder_account 
  FOREIGN KEY (account_id) REFERENCES dbo.account(account_id);

ALTER TABLE dbo.account_holder 
  ADD CONSTRAINT FK_account_holder_customer 
  FOREIGN KEY (customer_id) REFERENCES dbo.customer(customer_id);

ALTER TABLE dbo.savings_account 
  ADD CONSTRAINT FK_savings_account_account 
  FOREIGN KEY (account_id) REFERENCES dbo.account(account_id);

ALTER TABLE dbo.chequing_account 
  ADD CONSTRAINT FK_chequing_account_account 
  FOREIGN KEY (account_id) REFERENCES dbo.account(account_id);

ALTER TABLE dbo.overdraft 
  ADD CONSTRAINT FK_overdraft_chequing_account 
  FOREIGN KEY (account_id) REFERENCES dbo.chequing_account(account_id);

-- Loan relationships
ALTER TABLE dbo.loan_holder 
  ADD CONSTRAINT FK_loan_holder_loan 
  FOREIGN KEY (loan_id) REFERENCES dbo.loan(loan_id);

ALTER TABLE dbo.loan_holder 
  ADD CONSTRAINT FK_loan_holder_customer 
  FOREIGN KEY (customer_id) REFERENCES dbo.customer(customer_id);

ALTER TABLE dbo.loan_payment 
  ADD CONSTRAINT FK_loan_payment_loan 
  FOREIGN KEY (loan_id) REFERENCES dbo.loan(loan_id);

-- Percentage validations
ALTER TABLE dbo.account_holder WITH NOCHECK 
  ADD CONSTRAINT CHK_ownership_percent_range 
  CHECK (ownership_percent BETWEEN 0 AND 100);

ALTER TABLE dbo.loan_holder WITH NOCHECK 
  ADD CONSTRAINT CHK_share_percent_range 
  CHECK (share_percent BETWEEN 0 AND 100);

-- Financial validations
ALTER TABLE dbo.account WITH NOCHECK 
  ADD CONSTRAINT CHK_balance_non_negative 
  CHECK (balance >= 0);

ALTER TABLE dbo.loan WITH NOCHECK 
  ADD CONSTRAINT CHK_loan_amount_positive 
  CHECK (loan_amount > 0);

ALTER TABLE dbo.loan WITH NOCHECK 
  ADD CONSTRAINT CHK_outstanding_balance_valid 
  CHECK (outstanding_balance >= 0 AND outstanding_balance <= loan_amount);

ALTER TABLE dbo.savings_account WITH NOCHECK 
  ADD CONSTRAINT CHK_interest_rate_range 
  CHECK (interest_rate IS NULL OR (interest_rate >= 0 AND interest_rate <= 25.0000));

-- Transaction validations
ALTER TABLE dbo.overdraft WITH NOCHECK 
  ADD CONSTRAINT CHK_overdraft_amount_positive 
  CHECK (amount > 0);

ALTER TABLE dbo.loan_payment WITH NOCHECK 
  ADD CONSTRAINT CHK_payment_amount_positive 
  CHECK (amount > 0);

-- Essential: Search performance
CREATE INDEX IX_customer_names ON dbo.customer(last_name, first_name);
CREATE INDEX IX_employee_names ON dbo.employee(last_name, first_name);

-- Essential: Foreign key performance
CREATE INDEX IX_account_holder_customer ON dbo.account_holder(customer_id);
CREATE INDEX IX_loan_holder_customer ON dbo.loan_holder(customer_id);
CREATE INDEX IX_loan_origin_branch ON dbo.loan(origin_branch_id);

-- Useful: Common banking queries
CREATE INDEX IX_account_balance ON dbo.account(balance);