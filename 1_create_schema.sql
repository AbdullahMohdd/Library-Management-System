
CREATE TABLE Books (
    BookID INT PRIMARY KEY,
    Title NVARCHAR(100),
    Author NVARCHAR(100),
    ISBN NVARCHAR(20),
    PublishedDate DATE,
    Genre NVARCHAR(50),
    ShelfLocation NVARCHAR(20),
    CurrentStatus NVARCHAR(10)
);

CREATE TABLE Borrowers (
    BorrowerID INT PRIMARY KEY,
    FirstName NVARCHAR(50),
    LastName NVARCHAR(50),
    Email NVARCHAR(100),
    DateOfBirth DATE,
    MembershipDate DATE
);

CREATE TABLE Loans (
    LoanID INT PRIMARY KEY,
    BookID INT FOREIGN KEY REFERENCES Books(BookID),
    BorrowerID INT FOREIGN KEY REFERENCES Borrowers(BorrowerID),
    DateBorrowed DATE,
    DueDate DATE,
    DateReturned DATE
);
