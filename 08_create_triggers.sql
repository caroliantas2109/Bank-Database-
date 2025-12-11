-- AUDIT table
CREATE TABLE audit (
    audit_id INT IDENTITY(1,1) PRIMARY KEY,
    audit_description VARCHAR(500),
    action_time DATETIME DEFAULT GETDATE()
);
GO

/* ----------------------------------------------------
   1. CUSTOMER TRIGGERS
---------------------------------------------------- */

CREATE TRIGGER trg_CustomerInserted
ON customer
AFTER INSERT
AS
BEGIN
    UPDATE c
    SET created_at = GETDATE(),
        updated_at = GETDATE()
    FROM customer c
    INNER JOIN inserted i ON c.customer_id = i.customer_id;

    INSERT INTO audit (audit_description, action_time)
    SELECT 
        'New customer created: ID:' + CAST(i.customer_id AS VARCHAR(20)) +
        ', FirstName:' + i.first_name +
        ', LastName:' + i.last_name,
        GETDATE()
    FROM inserted i;
END;
GO

CREATE TRIGGER trg_CustomerUpdated
ON customer
AFTER UPDATE
AS
BEGIN
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

/* ----------------------------------------------------
   2. ACCOUNT TRIGGERS
---------------------------------------------------- */

CREATE TRIGGER trg_AccountCreated
ON account
AFTER INSERT
AS
BEGIN
    UPDATE a
    SET created_at = GETDATE(),
        updated_at = GETDATE()
    FROM account a
    INNER JOIN inserted i ON a.account_id = i.account_id;

    INSERT INTO audit (audit_description, action_time)
    SELECT
        'New Account created: ID:' + CAST(i.account_id AS VARCHAR(20)) +
        ', Balance:' + CAST(i.balance AS VARCHAR(20)) +
        ', LastAccess:' + CAST(i.last_access_date AS VARCHAR(30)),
        GETDATE()
    FROM inserted i;
END;
GO

CREATE TRIGGER trg_AccountUpdated
ON account
AFTER UPDATE
AS
BEGIN
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

/* ----------------------------------------------------
   3. ACCOUNT_TYPE TRIGGERS
---------------------------------------------------- */

CREATE TRIGGER trg_AccountTypeInserted
ON account_type
AFTER INSERT
AS
BEGIN
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

CREATE TRIGGER trg_AccountTypeUpdated
ON account_type
AFTER UPDATE
AS
BEGIN
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
