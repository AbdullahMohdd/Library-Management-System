
-- Create the database
CREATE DATABASE LibraryDB;
GO

USE LibraryDB;
GO

-- Create Books table
CREATE TABLE Books (
    BookID INT PRIMARY KEY IDENTITY(1,1),
    Title NVARCHAR(255),
    Author NVARCHAR(255),
    ISBN NVARCHAR(20),
    PublishedDate DATE,
    Genre NVARCHAR(100),
    ShelfLocation NVARCHAR(100),
    CurrentStatus NVARCHAR(20) CHECK (CurrentStatus IN ('Available', 'Borrowed'))
);
GO

-- Create Borrowers table
CREATE TABLE Borrowers (
    BorrowerID INT PRIMARY KEY IDENTITY(1,1),
    FirstName NVARCHAR(100),
    LastName NVARCHAR(100),
    Email NVARCHAR(150) UNIQUE,
    DateOfBirth DATE,
    MembershipDate DATE
);
GO

-- Create Loans table
CREATE TABLE Loans (
    LoanID INT PRIMARY KEY IDENTITY(1,1),
    BookID INT,
    BorrowerID INT,
    DateBorrowed DATE,
    DueDate DATE,
    DateReturned DATE NULL,
    FOREIGN KEY (BookID) REFERENCES Books(BookID),
    FOREIGN KEY (BorrowerID) REFERENCES Borrowers(BorrowerID)
);
GO

-- Create AuditLog table
CREATE TABLE AuditLog (
    LogID INT PRIMARY KEY IDENTITY(1,1),
    BookID INT,
    StatusChange NVARCHAR(20),
    ChangeDate DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (BookID) REFERENCES Books(BookID)
);
GO
