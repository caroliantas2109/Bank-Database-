/* 
   File: prepared_queries.sql
   Project: SKS National Bank (Final Project) =D
   Group Members: <Pedro Molina, Carol Iantas and Vivekbhai Pateli>
   
   Notes:
     - This file assumes the BankDB schema from create_database.sql exists.
     - Each query is a stored procedure or function with a short description
       and an example test call at the end of its block.
*/

/* 
   Purpose: Create the main database for SKS National Bank
*/

IF DB_ID('BankDB') IS NOT NULL
    DROP DATABASE BankDB;
GO

CREATE DATABASE BankDB;
GO

USE BankDB;
GO