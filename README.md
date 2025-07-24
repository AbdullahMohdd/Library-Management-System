
# Library Management System - Tech-Lib Project

## 📚 Overview

This project is a relational database system for a library to manage books, borrowers, loans, and support extensive queries and reporting.

---

## 🧱 Database Structure

### 📘 Books Table
- `BookID` (Primary Key)
- `Title`
- `Author`
- `ISBN`
- `PublishedDate`
- `Genre`
- `ShelfLocation`
- `CurrentStatus` ('Available' or 'Borrowed')

### 👤 Borrowers Table
- `BorrowerID` (Primary Key)
- `FirstName`
- `LastName`
- `Email`
- `DateOfBirth`
- `MembershipDate`

### 📄 Loans Table
- `LoanID` (Primary Key)
- `BookID` (Foreign Key)
- `BorrowerID` (Foreign Key)
- `DateBorrowed`
- `DueDate`
- `DateReturned`

---

## 🛠️ Implementation Highlights

### ✅ SQL Features Implemented
- Entity Relationship Diagram (ERD)
- Relational Schema
- Database Seeding (1000 records for each table)
- 10+ Complex Queries using:
  - CTEs
  - Window Functions
  - Aggregation & Joins
- Stored Procedures:
  - `sp_AddNewBorrower`
  - `sp_BorrowedBooksReport`
  - `sp_ListBorrowedBooks`
  - `sp_OverdueBorrowersWithTemp`
- Functions:
  - `fn_CalculateOverdueFees`
  - `fn_BookBorrowingFrequency`
- Trigger:
  - AuditLog on book status change
- BONUS Query: Peak loan days by weekday

---

## 📂 Files in This Repository

- `1_schema_seed.sql`: Tables + 1000-row DMLs
- `2_queries_procedures_functions_triggers.sql`: All queries, procedures, functions, trigger
- `Sample_Books.csv`, `Sample_Borrowers.csv`, `Sample_Loans.csv`: Sample datasets
- `ERD.pdf`: Entity-Relationship Diagram
- `Project_Report.docx`: Full project documentation
- `README.md`: Project overview

---

## 🚀 How to Use

1. Run `1_schema_seed.sql` in Microsoft SQL Server to create and populate the database.
2. Execute `2_queries_procedures_functions_triggers.sql` to add all functionality.
3. Explore queries and procedures as needed for analytics.

---

## 👨‍💻 Author

Developed as part of the academic training project for database systems.
