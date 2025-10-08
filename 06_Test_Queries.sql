--1) Tests for spGetCustomerAccounts
--BEGIN
EXEC dbo.spGetCustomerAccounts @CustomerId = 1;

-- Invalid test (customer does not exist)
BEGIN TRY
	EXEC dbo.spGetCustomerAccounts @CustomerId = 9999;
END TRY
BEGIN CATCH
	SELECT ERROR_NUMBER() AS ErrorNumber, ERROR_MESSAGE() AS ErrorMessage;
END CATCH;

--END

--2) Tests for spGetLoanSummaryByCustomer
-- BEGIN
EXEC dbo.spGetLoanSummaryByCustomer @CustomerId = 1;

-- Invalid test (customer does not exist)
BEGIN TRY
    EXEC dbo.spGetLoanSummaryByCustomer @CustomerId = 9999;
END TRY
BEGIN CATCH
    SELECT ERROR_NUMBER() AS ErrorNumber, ERROR_MESSAGE() AS ErrorMessage;
END CATCH;
--END

--3) Tests for spRecordLoanPayment
-- BEGIN
EXEC dbo.spRecordLoanPayment @LoanId = 1, @Amount = 100;

-- Invalid test (loan does not exist)
BEGIN TRY
    EXEC dbo.spRecordLoanPayment @LoanId = 9999, @Amount = 100;
END TRY
BEGIN CATCH
    SELECT ERROR_NUMBER() AS ErrorNumber, ERROR_MESSAGE() AS ErrorMessage;
END CATCH;

-- Invalid test (negative amount)
BEGIN TRY
    EXEC dbo.spRecordLoanPayment @LoanId = 1, @Amount = -50;
END TRY
BEGIN CATCH
    SELECT ERROR_NUMBER() AS ErrorNumber, ERROR_MESSAGE() AS ErrorMessage;
END CATCH;
--END

--4) Tests for spTransferFunds
-- BEGIN
EXEC dbo.spTransferFunds @FromAccountId = 1, @ToAccountId = 2, @Amount = 50, @Description = 'Test transfer';

-- Invalid test (source account does not exist)
BEGIN TRY
    EXEC dbo.spTransferFunds @FromAccountId = 9999, @ToAccountId = 2, @Amount = 50;
END TRY
BEGIN CATCH
    SELECT ERROR_NUMBER(), ERROR_MESSAGE();
END CATCH;

-- Invalid test (insufficient funds)
BEGIN TRY
    EXEC dbo.spTransferFunds @FromAccountId = 1, @ToAccountId = 2, @Amount = 1000000;
END TRY
BEGIN CATCH
    SELECT ERROR_NUMBER(), ERROR_MESSAGE();
END CATCH;
--END

--5) Tests for spCreateNewAccount
-- BEGIN
EXEC dbo.spCreateNewAccount @CustomerId = 1, @AccountTypeCode = 'SAV-STD', @InitialBalance = 1000, @InterestRate = 0.05;

-- Invalid test (customer does not exist)
BEGIN TRY
    EXEC dbo.spCreateNewAccount @CustomerId = 9999, @AccountTypeCode = 'SAV';
END TRY
BEGIN CATCH
    SELECT ERROR_NUMBER(), ERROR_MESSAGE();
END CATCH;

-- Invalid test (invalid account type)
BEGIN TRY
    EXEC dbo.spCreateNewAccount @CustomerId = 1, @AccountTypeCode = 'ABC';
END TRY
BEGIN CATCH
    SELECT ERROR_NUMBER(), ERROR_MESSAGE();
END CATCH;
--END

--6) Tests for spAddNewCustomer
-- BEGIN
EXEC dbo.spAddNewCustomer @FirstName = 'Maria', @LastName = 'Silva', @AddressId = 1;

-- Invalid test (empty first name)
BEGIN TRY
    EXEC dbo.spAddNewCustomer @FirstName = '', @LastName = 'Silva';
END TRY
BEGIN CATCH
    SELECT ERROR_NUMBER(), ERROR_MESSAGE();
END CATCH;

-- Invalid test (address does not exist)
BEGIN TRY
    EXEC dbo.spAddNewCustomer @FirstName = 'João', @LastName = 'Souza', @AddressId = 9999;
END TRY
BEGIN CATCH
    SELECT ERROR_NUMBER(), ERROR_MESSAGE();
END CATCH;
--END

--7) Tests for spUpdateAccountBalance
-- BEGIN
EXEC dbo.spUpdateAccountBalance @AccountId = 1, @Amount = 200, @TransactionType = 'DEPOSIT';

-- Valid withdrawal
EXEC dbo.spUpdateAccountBalance @AccountId = 1, @Amount = 50, @TransactionType = 'WITHDRAW';

-- Invalid withdrawal (insufficient funds)
BEGIN TRY
    EXEC dbo.spUpdateAccountBalance @AccountId = 1, @Amount = 1000000, @TransactionType = 'WITHDRAW';
END TRY
BEGIN CATCH
    SELECT ERROR_NUMBER(), ERROR_MESSAGE();
END CATCH;

-- Invalid transaction type
BEGIN TRY
    EXEC dbo.spUpdateAccountBalance @AccountId = 1, @Amount = 100, @TransactionType = 'TRANSFER';
END TRY
BEGIN CATCH
    SELECT ERROR_NUMBER(), ERROR_MESSAGE();
END CATCH;
--END

--8) Tests for spGetBranchFinancialSummary
-- BEGIN
EXEC dbo.spGetBranchFinancialSummary;

-- Summary for a specific branch
EXEC dbo.spGetBranchFinancialSummary @BranchId = 1;

-- Invalid test (branch does not exist)
BEGIN TRY
    EXEC dbo.spGetBranchFinancialSummary @BranchId = 9999;
END TRY
BEGIN CATCH
    SELECT ERROR_NUMBER(), ERROR_MESSAGE();
END CATCH;
--END

--9) Tests for spSearchCustomers
-- BEGIN
EXEC dbo.spSearchCustomers @SearchTerm = 'Silva';

-- Invalid search (empty search term)
BEGIN TRY
    EXEC dbo.spSearchCustomers @SearchTerm = '';
END TRY
BEGIN CATCH
    SELECT ERROR_NUMBER(), ERROR_MESSAGE();
END CATCH;
--END

--10) Tests for spGetOverdraftsForAccount
-- BEGIN
EXEC dbo.spGetOverdraftsForAccount @AccountId = 1;

-- Invalid account
BEGIN TRY
    EXEC dbo.spGetOverdraftsForAccount @AccountId = 9999;
END TRY
BEGIN CATCH
    SELECT ERROR_NUMBER(), ERROR_MESSAGE();
END CATCH;

-- Invalid test (not a chequing account)
BEGIN TRY
    EXEC dbo.spGetOverdraftsForAccount @AccountId = 1; -- assuming this is a SAV account
END TRY
BEGIN CATCH
    SELECT ERROR_NUMBER(), ERROR_MESSAGE();
END CATCH;
--END

--11) Tests for fnTotalOwnershipPercent
-- BEGIN
SELECT dbo.fnTotalOwnershipPercent(1) AS total_ownership;

-- Non-existent account
SELECT dbo.fnTotalOwnershipPercent(9999) AS total_ownership;
--END

--12) Tests for fnAccountAgingDays
-- BEGIN
SELECT dbo.fnAccountAgingDays(1) AS aging_days;

-- Non-existent account
SELECT dbo.fnAccountAgingDays(9999) AS aging_days;
--END

--13) Tests for fnBranchExposure
-- BEGIN
SELECT * FROM dbo.fnBranchExposure(1);

-- Branch with no loans
SELECT * FROM dbo.fnBranchExposure(9999);
--END