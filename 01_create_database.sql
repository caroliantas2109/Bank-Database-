/* 
   File: prepared_queries.sql
   Project: SKS National Bank (Final Project) =D
   Group Members: <Pedro Molina, Carol Iantas and Vivekbhai Pateli>
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
