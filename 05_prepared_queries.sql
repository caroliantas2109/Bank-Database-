/* 
   Purpose: Stored procedures & functions
*/

USE BankDB;
GO

-- Error number system:
-- 51000-51099: Customer errors
-- 51100-51199: Account errors  
-- 51200-51299: Loan errors
-- 51300-51399: Branch/Location errors
-- 51500-51599: Transaction errors

-- 1) Get Customer Accounts
CREATE OR ALTER PROCEDURE dbo.spGetCustomerAccounts
  @CustomerId INT
AS
BEGIN
  SET NOCOUNT ON;
  
  IF NOT EXISTS (SELECT 1 FROM dbo.customer WHERE customer_id = @CustomerId)
  BEGIN
    THROW 51001, 'Customer not found.', 1;
    RETURN;
  END
  
  SELECT a.account_id, at.code, at.description, ah.ownership_percent,
         a.balance, a.last_access_date, a.created_at
  FROM dbo.account_holder ah
  JOIN dbo.account a ON a.account_id = ah.account_id
  JOIN dbo.account_type at ON at.account_type_id = a.account_type_id
  WHERE ah.customer_id = @CustomerId
  ORDER BY a.account_id;
END
GO

-- 2) Get Loan Summary By Customer
CREATE OR ALTER PROCEDURE dbo.spGetLoanSummaryByCustomer
  @CustomerId INT
AS
BEGIN
  SET NOCOUNT ON;
  
  IF NOT EXISTS (SELECT 1 FROM dbo.customer WHERE customer_id = @CustomerId)
  BEGIN
    THROW 51001, 'Customer not found.', 1;
    RETURN;
  END
  
  SELECT l.loan_id, b.name AS origin_branch, lh.share_percent,
         l.loan_amount, l.outstanding_balance, l.created_at
  FROM dbo.loan_holder lh
  JOIN dbo.loan l ON l.loan_id = lh.loan_id
  JOIN dbo.branch b ON b.branch_id = l.origin_branch_id
  WHERE lh.customer_id = @CustomerId
  ORDER BY l.loan_id;
END
GO

-- 3) Record Loan Payment
CREATE OR ALTER PROCEDURE dbo.spRecordLoanPayment
  @LoanId INT,
  @Amount DECIMAL(18,2),
  @PaymentDate DATE = NULL
AS
BEGIN
  SET NOCOUNT ON;

  IF @PaymentDate IS NULL
    SET @PaymentDate = CAST(GETDATE() AS DATE);

  DECLARE @CurrentBalance DECIMAL(18,2);
  SELECT @CurrentBalance = outstanding_balance 
  FROM dbo.loan 
  WHERE loan_id = @LoanId;

  IF @CurrentBalance IS NULL
  BEGIN
    THROW 51201, 'Loan not found.', 1;
    RETURN;
  END

  IF @Amount <= 0
  BEGIN
    THROW 51202, 'Payment amount must be positive.', 1;
    RETURN;
  END

  IF @Amount > @CurrentBalance
  BEGIN
    THROW 51203, 'Payment amount cannot exceed outstanding balance.', 1;
    RETURN;
  END

  BEGIN TRY
    BEGIN TRAN;

    DECLARE @nextNo INT = ISNULL((
      SELECT MAX(payment_number) + 1
      FROM dbo.loan_payment
      WHERE loan_id = @LoanId
    ), 1);

    INSERT INTO dbo.loan_payment(loan_id, payment_number, payment_date, amount, created_at)
    VALUES (@LoanId, @nextNo, @PaymentDate, @Amount, GETDATE());

    UPDATE dbo.loan 
    SET outstanding_balance = outstanding_balance - @Amount,
        updated_at = GETDATE()
    WHERE loan_id = @LoanId;

    COMMIT;

    SELECT 
      @LoanId AS loan_id, 
      @nextNo AS payment_number, 
      @Amount AS amount, 
      @PaymentDate AS payment_date,
      (@CurrentBalance - @Amount) AS new_balance;
      
  END TRY
  BEGIN CATCH
    IF @@TRANCOUNT > 0 ROLLBACK;
    THROW;
  END CATCH;
END
GO

-- 4) Transfer Funds Between Accounts
CREATE OR ALTER PROCEDURE dbo.spTransferFunds
  @FromAccountId INT,
  @ToAccountId INT,
  @Amount DECIMAL(18,2),
  @Description VARCHAR(200) = NULL
AS
BEGIN
  SET NOCOUNT ON;

  IF NOT EXISTS (SELECT 1 FROM dbo.account WHERE account_id = @FromAccountId)
  BEGIN
    THROW 51102, 'Source account not found.', 1;
    RETURN;
  END

  IF NOT EXISTS (SELECT 1 FROM dbo.account WHERE account_id = @ToAccountId)
  BEGIN
    THROW 51103, 'Destination account not found.', 1;
    RETURN;
  END

  IF @Amount <= 0
  BEGIN
    THROW 51107, 'Transfer amount must be positive.', 1;
    RETURN;
  END

  DECLARE @FromBalance DECIMAL(18,2);
  SELECT @FromBalance = balance FROM dbo.account WHERE account_id = @FromAccountId;
  
  IF @FromBalance < @Amount
  BEGIN
    THROW 51104, 'Insufficient funds for transfer.', 1;
    RETURN;
  END

  BEGIN TRY
    BEGIN TRAN;

    UPDATE dbo.account 
    SET balance = balance - @Amount,
        last_access_date = GETDATE(),
        updated_at = GETDATE()
    WHERE account_id = @FromAccountId;

    UPDATE dbo.account 
    SET balance = balance + @Amount,
        last_access_date = GETDATE(),
        updated_at = GETDATE()
    WHERE account_id = @ToAccountId;

    COMMIT;

    SELECT 
      @FromAccountId AS from_account_id,
      @ToAccountId AS to_account_id,
      @Amount AS amount,
      @Description AS description,
      GETDATE() AS transfer_date;

  END TRY
  BEGIN CATCH
    IF @@TRANCOUNT > 0 ROLLBACK;
    THROW;
  END CATCH;
END
GO

-- 5) Create New Account
CREATE OR ALTER PROCEDURE dbo.spCreateNewAccount
  @CustomerId INT,
  @AccountTypeCode VARCHAR(10),
  @InitialBalance DECIMAL(18,2) = 0,
  @InterestRate DECIMAL(6,4) = NULL
AS
BEGIN
  SET NOCOUNT ON;

  IF NOT EXISTS (SELECT 1 FROM dbo.customer WHERE customer_id = @CustomerId)
  BEGIN
    THROW 51001, 'Customer not found.', 1;
    RETURN;
  END

  DECLARE @AccountTypeId INT;
  SELECT @AccountTypeId = account_type_id 
  FROM dbo.account_type 
  WHERE code = @AccountTypeCode;

  IF @AccountTypeId IS NULL
  BEGIN
    THROW 51105, 'Invalid account type code.', 1;
    RETURN;
  END

  IF @InitialBalance < 0
  BEGIN
    THROW 51106, 'Initial balance cannot be negative.', 1;
    RETURN;
  END

  BEGIN TRY
    BEGIN TRAN;

    INSERT INTO dbo.account (account_type_id, balance, last_access_date)
    VALUES (@AccountTypeId, @InitialBalance, GETDATE());

    DECLARE @NewAccountId INT = SCOPE_IDENTITY();

    INSERT INTO dbo.account_holder (account_id, customer_id, ownership_percent)
    VALUES (@NewAccountId, @CustomerId, 100.00);

    IF @AccountTypeCode = 'SAV' AND @InterestRate IS NOT NULL
    BEGIN
      INSERT INTO dbo.savings_account (account_id, interest_rate)
      VALUES (@NewAccountId, @InterestRate);
    END
    ELSE IF @AccountTypeCode = 'CHK'
    BEGIN
      INSERT INTO dbo.chequing_account (account_id)
      VALUES (@NewAccountId);
    END

    COMMIT;

    SELECT 
      @NewAccountId AS new_account_id,
      @AccountTypeCode AS account_type,
      @InitialBalance AS initial_balance,
      @InterestRate AS interest_rate;

  END TRY
  BEGIN CATCH
    IF @@TRANCOUNT > 0 ROLLBACK;
    THROW;
  END CATCH;
END
GO

-- 6) Add New Customer
CREATE OR ALTER PROCEDURE dbo.spAddNewCustomer
  @FirstName VARCHAR(50),
  @LastName VARCHAR(50),
  @AddressId INT = NULL
AS
BEGIN
  SET NOCOUNT ON;

  IF @FirstName IS NULL OR LTRIM(RTRIM(@FirstName)) = ''
  BEGIN
    THROW 51002, 'First name is required.', 1;
    RETURN;
  END

  IF @LastName IS NULL OR LTRIM(RTRIM(@LastName)) = ''
  BEGIN
    THROW 51003, 'Last name is required.', 1;
    RETURN;
  END

  IF @AddressId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.address WHERE address_id = @AddressId)
  BEGIN
    THROW 51303, 'Address not found.', 1;
    RETURN;
  END

  BEGIN TRY
    BEGIN TRAN;

    INSERT INTO dbo.customer (first_name, last_name, address_id)
    VALUES (@FirstName, @LastName, @AddressId);

    DECLARE @NewCustomerId INT = SCOPE_IDENTITY();

    COMMIT;

    SELECT 
      @NewCustomerId AS customer_id,
      @FirstName AS first_name,
      @LastName AS last_name,
      @AddressId AS address_id;

  END TRY
  BEGIN CATCH
    IF @@TRANCOUNT > 0 ROLLBACK;
    THROW;
  END CATCH;
END
GO

-- 7) Update Account Balance (Deposit/Withdraw)
CREATE OR ALTER PROCEDURE dbo.spUpdateAccountBalance
  @AccountId INT,
  @Amount DECIMAL(18,2),
  @TransactionType VARCHAR(10)
AS
BEGIN
  SET NOCOUNT ON;

  IF NOT EXISTS (SELECT 1 FROM dbo.account WHERE account_id = @AccountId)
  BEGIN
    THROW 51101, 'Account not found.', 1;
    RETURN;
  END

  IF @Amount <= 0
  BEGIN
    THROW 51107, 'Amount must be positive.', 1;
    RETURN;
  END

  IF @TransactionType NOT IN ('DEPOSIT', 'WITHDRAW')
  BEGIN
    THROW 51501, 'Transaction type must be DEPOSIT or WITHDRAW.', 1;
    RETURN;
  END

  BEGIN TRY
    BEGIN TRAN;

    DECLARE @NewBalance DECIMAL(18,2);

    IF @TransactionType = 'DEPOSIT'
    BEGIN
      UPDATE dbo.account 
      SET balance = balance + @Amount,
          last_access_date = GETDATE(),
          updated_at = GETDATE()
      WHERE account_id = @AccountId;
      
      SET @NewBalance = (SELECT balance FROM dbo.account WHERE account_id = @AccountId);
    END
    ELSE IF @TransactionType = 'WITHDRAW'
    BEGIN
      DECLARE @CurrentBalance DECIMAL(18,2);
      SELECT @CurrentBalance = balance FROM dbo.account WHERE account_id = @AccountId;
      
      IF @CurrentBalance < @Amount
      BEGIN
        THROW 51104, 'Insufficient funds for withdrawal.', 1;
        RETURN;
      END

      UPDATE dbo.account 
      SET balance = balance - @Amount,
          last_access_date = GETDATE(),
          updated_at = GETDATE()
      WHERE account_id = @AccountId;
      
      SET @NewBalance = @CurrentBalance - @Amount;
    END

    COMMIT;

    SELECT 
      @AccountId AS account_id,
      @TransactionType AS transaction_type,
      @Amount AS amount,
      @NewBalance AS new_balance,
      GETDATE() AS transaction_date;

  END TRY
  BEGIN CATCH
    IF @@TRANCOUNT > 0 ROLLBACK;
    THROW;
  END CATCH;
END
GO

-- 8) Get Branch Financial Summary
CREATE OR ALTER PROCEDURE dbo.spGetBranchFinancialSummary
  @BranchId INT = NULL
AS
BEGIN
  SET NOCOUNT ON;

  IF @BranchId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.branch WHERE branch_id = @BranchId)
  BEGIN
    THROW 51301, 'Branch not found.', 1;
    RETURN;
  END

  SELECT 
    b.branch_id,
    b.name AS branch_name,
    b.total_deposits,
    b.total_loans,
    (b.total_deposits - b.total_loans) AS net_funds,
    ISNULL(account_counts.account_count, 0) AS total_accounts,
    ISNULL(loan_counts.loan_count, 0) AS total_loans_count,
    ISNULL(customer_counts.customer_count, 0) AS total_customers
  FROM dbo.branch b
  OUTER APPLY (
    SELECT COUNT(DISTINCT ah.account_id) AS account_count
    FROM dbo.account_holder ah
    JOIN dbo.account a ON a.account_id = ah.account_id
    JOIN dbo.customer c ON c.customer_id = ah.customer_id
    JOIN dbo.address addr ON addr.address_id = c.address_id
    WHERE EXISTS (
      SELECT 1 FROM dbo.location loc 
      WHERE loc.address_id = addr.address_id 
      AND loc.branch_id = b.branch_id
    )
  ) AS account_counts
  OUTER APPLY (
    SELECT COUNT(*) AS loan_count
    FROM dbo.loan l
    WHERE l.origin_branch_id = b.branch_id
  ) AS loan_counts
  OUTER APPLY (
    SELECT COUNT(DISTINCT c.customer_id) AS customer_count
    FROM dbo.customer c
    JOIN dbo.address addr ON addr.address_id = c.address_id
    WHERE EXISTS (
      SELECT 1 FROM dbo.location loc 
      WHERE loc.address_id = addr.address_id 
      AND loc.branch_id = b.branch_id
    )
  ) AS customer_counts
  WHERE @BranchId IS NULL OR b.branch_id = @BranchId
  ORDER BY b.total_deposits DESC;
END
GO

-- 9) Search Customers by Name
CREATE OR ALTER PROCEDURE dbo.spSearchCustomers
  @SearchTerm VARCHAR(100)
AS
BEGIN
  SET NOCOUNT ON;

  IF @SearchTerm IS NULL OR LTRIM(RTRIM(@SearchTerm)) = ''
  BEGIN
    THROW 51004, 'Search term is required.', 1;
    RETURN;
  END

  DECLARE @SearchPattern VARCHAR(102) = '%' + @SearchTerm + '%';

  SELECT 
    c.customer_id,
    c.first_name,
    c.last_name,
    COUNT(DISTINCT ah.account_id) AS total_accounts,
    COUNT(DISTINCT lh.loan_id) AS total_loans,
    ISNULL(SUM(a.balance), 0) AS total_balance
  FROM dbo.customer c
  LEFT JOIN dbo.account_holder ah ON ah.customer_id = c.customer_id
  LEFT JOIN dbo.account a ON a.account_id = ah.account_id
  LEFT JOIN dbo.loan_holder lh ON lh.customer_id = c.customer_id
  WHERE c.first_name LIKE @SearchPattern 
     OR c.last_name LIKE @SearchPattern
  GROUP BY c.customer_id, c.first_name, c.last_name
  ORDER BY c.last_name, c.first_name;
END
GO

-- 10) Get Overdrafts For Account
CREATE OR ALTER PROCEDURE dbo.spGetOverdraftsForAccount
  @AccountId INT
AS
BEGIN
  SET NOCOUNT ON;

  IF NOT EXISTS (SELECT 1 FROM dbo.account WHERE account_id = @AccountId)
  BEGIN
    THROW 51101, 'Account not found.', 1;
    RETURN;
  END

  -- Verify it's a chequing account
  IF NOT EXISTS (
    SELECT 1 
    FROM dbo.account a
    JOIN dbo.account_type at ON at.account_type_id = a.account_type_id
    WHERE a.account_id = @AccountId AND at.code = 'CHK'
  )
  BEGIN
    THROW 51108, 'Account is not a chequing account.', 1;
    RETURN;
  END

  SELECT 
    o.overdraft_id,
    o.account_id,
    o.date,
    o.amount,
    o.check_number,
    o.created_at
  FROM dbo.overdraft o
  WHERE o.account_id = @AccountId
  ORDER BY o.date DESC, o.overdraft_id DESC;
END
GO

-- 11) Function: Calculate Total Ownership Percent
CREATE OR ALTER FUNCTION dbo.fnTotalOwnershipPercent(@AccountId INT)
RETURNS DECIMAL(7,2)
AS
BEGIN
  DECLARE @pct DECIMAL(7,2);
  SELECT @pct = COALESCE(SUM(ownership_percent), 0.00)
  FROM dbo.account_holder
  WHERE account_id = @AccountId;
  RETURN @pct;
END
GO

-- 12) Function: Get Account Aging Days
CREATE OR ALTER FUNCTION dbo.fnAccountAgingDays(@AccountId INT)
RETURNS INT
AS
BEGIN
  DECLARE @days INT;
  SELECT @days =
    CASE WHEN last_access_date IS NULL THEN NULL
         ELSE DATEDIFF(DAY, last_access_date, GETDATE())
    END
  FROM dbo.account
  WHERE account_id = @AccountId;
  RETURN @days;
END
GO

-- 13) Function: Get Branch Exposure
CREATE OR ALTER FUNCTION dbo.fnBranchExposure(@BranchId INT)
RETURNS TABLE
AS
RETURN
(
  SELECT
    COUNT(*) AS total_loans,
    SUM(loan_amount) AS total_loan_amount,
    SUM(outstanding_balance) AS total_outstanding_balance,
    AVG(outstanding_balance) AS avg_outstanding_balance
  FROM dbo.loan
  WHERE origin_branch_id = @BranchId
);
GO