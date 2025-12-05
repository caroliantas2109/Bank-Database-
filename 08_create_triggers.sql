CREATE TABLE audit (
    audit_id INT IDENTITY(1,1) PRIMARY KEY,
    audit_description VARCHAR(500),
    action_time DATETIME DEFAULT GETDATE()
);

--1. Customer Trigger
CREATE TRIGGER trg_CustomerInserted
ON customer
AFTER INSERT
AS
BEGIN
    -- Update timestamp fields for customer table upon insertion
    UPDATE c
    SET created_at = GETDATE(),
        updated_at = GETDATE()
    FROM customer c
    INNER JOIN inserted i ON c.customer_id = i.customer_id;

    -- Write to audit log
    INSERT INTO audit (audit_description, action_time)
    SELECT 
        'New customer created: ID:' + CAST(i.customer_id AS VARCHAR(20)) +
        ', FirstName:' + i.first_name +
        ', LastName:' + i.last_name,
        GETDATE()
    FROM inserted i;
END;
GO

--Update 
CREATE TRIGGER trg_CustomerUpdated
ON customer
AFTER UPDATE
AS
BEGIN
	-- AVOID INFINITE LOOP
	IF UPDATE(updated_at)
        RETURN;

    UPDATE c
    SET updated_at = GETDATE()
    FROM customer c
    INNER JOIN inserted i ON c.customer_id = i.customer_id;

    INSERT INTO audit (audit_description, action_time)
    SELECT 
        'Customer updated: ID:' + CAST(i.customer_id AS VARCHAR(20)),
        GETDATE()
    FROM inserted i;
END;
GO

--Test
INSERT INTO customer (first_name, last_name)
VALUES ('Peter', 'Jack');

UPDATE customer
SET first_name = 'Elon Reeve'
WHERE customer_id = (SELECT TOP 1 customer_id FROM customer ORDER BY customer_id desc);

SELECT TOP 2 * FROM audit ORDER BY audit_id DESC
SELECT TOP 1 * FROM customer ORDER BY customer_id DESC


--2. Account Trigger
CREATE TRIGGER trg_AccountCreated
ON account
AFTER INSERT
AS
BEGIN
    -- Update timestamps when account was created
    UPDATE a
    SET created_at = GETDATE(),
        updated_at = GETDATE()
    FROM account a
    INNER JOIN inserted i ON a.account_id = i.account_id;

    -- Add audit log
    INSERT INTO audit (audit_description, action_time)
    SELECT
        'New Account created: ID:' + CAST(i.account_id AS VARCHAR(20)) +
        ', Balance:' + CAST(i.balance AS VARCHAR(20)) +
        ', LastAccess:' + CAST(i.last_access_date AS VARCHAR(30)),
        GETDATE()
    FROM inserted i;
END;
GO

-- Update 
CREATE TRIGGER trg_AccountUpdated
ON account
AFTER UPDATE
AS
BEGIN
	-- AVOID INFINITE LOOP
	IF UPDATE(updated_at)
        RETURN;

    UPDATE a
    SET updated_at = GETDATE()
    FROM account a
    INNER JOIN inserted i ON a.account_id = i.account_id;

    INSERT INTO audit (audit_description, action_time)
    SELECT
        'Account updated: ID:' + CAST(i.account_id AS VARCHAR(20)),
        GETDATE()
    FROM inserted i;
END;
GO

--Test
INSERT INTO account (account_type_id, balance, last_access_date)
VALUES (12, 30000, GETDATE());

UPDATE account
SET balance = balance + 1000
WHERE account_id = (SELECT TOP 1 account_id FROM account ORDER BY account_id desc);

SELECT TOP 2 * FROM audit ORDER BY audit_id DESC
SELECT TOP 1 * FROM account ORDER BY account_id DESC



--3. Account_type Trigger
CREATE TRIGGER trg_AccountTypeInserted
ON account_type
AFTER INSERT
AS
BEGIN
	 -- Update timestamps when account_type was created
    UPDATE at
    SET created_at = GETDATE(),
        updated_at = GETDATE()
    FROM account_type at
    INNER JOIN inserted i ON at.account_type_id = i.account_type_id;

    INSERT INTO audit (audit_description, action_time)
    SELECT
        'New Account Type created: Code: ' + i.code +
        ', Description: ' + i.description,
        GETDATE()
    FROM inserted i;
END;
GO

-- Update
CREATE TRIGGER trg_AccountTypeUpdated
ON account_type
AFTER UPDATE
AS
BEGIN
	-- AVOID INFINITE LOOP
	IF UPDATE(updated_at)
			RETURN;

    UPDATE at
    SET updated_at = GETDATE()
    FROM account_type at
    INNER JOIN inserted i ON at.account_type_id = i.account_type_id;

    INSERT INTO audit (audit_description, action_time)
    SELECT
        'Account Type updated: Code: ' + i.code,
        GETDATE()
    FROM inserted i;
END;
GO

--Test
INSERT INTO account_type (code, description)
VALUES ('SVG', 'Savings Account');

UPDATE account_type
SET description = 'Updated Savings Account'
WHERE account_type_id = (SELECT TOP 1 account_type_id FROM account_type ORDER BY account_type_id desc);

SELECT TOP 2 * FROM audit ORDER BY audit_id DESC
SELECT TOP 1 * FROM account_type ORDER BY account_type_id DESC



