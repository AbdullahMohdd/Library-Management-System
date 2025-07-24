
CREATE TABLE Books (
    BookID INT PRIMARY KEY,
    Title NVARCHAR(255),
    Author NVARCHAR(255),
    ISBN NVARCHAR(13),
    PublishedDate DATE,
    Genre NVARCHAR(100),
    ShelfLocation NVARCHAR(100),
    CurrentStatus NVARCHAR(20) CHECK (CurrentStatus IN ('Available', 'Borrowed'))
);

CREATE TABLE Borrowers (
    BorrowerID INT PRIMARY KEY,
    FirstName NVARCHAR(100),
    LastName NVARCHAR(100),
    Email NVARCHAR(255) UNIQUE,
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


-- Seed Data Examples (for 3 records only)
INSERT INTO Books VALUES
(1, 'The Great Gatsby', 'F. Scott Fitzgerald', '9780743273565', '1925-04-10', 'Fiction', 'A1', 'Available'),
(2, 'To Kill a Mockingbird', 'Harper Lee', '9780061120084', '1960-07-11', 'Classic', 'B3', 'Borrowed'),
(3, '1984', 'George Orwell', '9780451524935', '1949-06-08', 'Dystopian', 'C5', 'Available');

INSERT INTO Borrowers VALUES
(1, 'John', 'Doe', 'john.doe@example.com', '1990-03-15', '2022-01-01'),
(2, 'Jane', 'Smith', 'jane.smith@example.com', '1985-07-22', '2022-03-10');

INSERT INTO Loans VALUES
(1, 2, 1, '2025-07-01', '2025-07-15', NULL);
