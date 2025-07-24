
-- Library Management System: Full SQL Implementation
-- Includes Queries, Stored Procedures, Functions, Triggers, and BONUS Analysis

-- 1. Stored Procedure: List all books borrowed by a specific borrower
CREATE PROCEDURE sp_ListBorrowedBooks
    @BorrowerID INT
AS
BEGIN
    SELECT b.Title, l.DateBorrowed, l.DateReturned
    FROM Loans l
    JOIN Books b ON l.BookID = b.BookID
    WHERE l.BorrowerID = @BorrowerID;
END;

-- 2. Active Borrowers with CTEs
WITH ActiveBorrowers AS (
    SELECT BorrowerID, COUNT(*) AS BorrowCount
    FROM Loans
    WHERE DateReturned IS NULL
    GROUP BY BorrowerID
)
SELECT * FROM ActiveBorrowers WHERE BorrowCount >= 2;

-- 3. Borrowing Frequency using Window Functions
SELECT BorrowerID, COUNT(*) AS TotalBorrowed,
       RANK() OVER (ORDER BY COUNT(*) DESC) AS BorrowRank
FROM Loans
GROUP BY BorrowerID;

-- 4. Popular Genre Analysis
SELECT TOP 1 Genre, COUNT(*) AS Total
FROM Loans l
JOIN Books b ON l.BookID = b.BookID
WHERE MONTH(DateBorrowed) = MONTH(GETDATE())
GROUP BY Genre
ORDER BY Total DESC;

-- 5. Stored Procedure: Add New Borrower
CREATE PROCEDURE sp_AddNewBorrower
    @FirstName NVARCHAR(50),
    @LastName NVARCHAR(50),
    @Email NVARCHAR(100),
    @DateOfBirth DATE,
    @MembershipDate DATE
AS
BEGIN
    IF EXISTS (SELECT 1 FROM Borrowers WHERE Email = @Email)
        RAISERROR('Email already exists.', 16, 1)
    ELSE
    BEGIN
        INSERT INTO Borrowers (FirstName, LastName, Email, DateOfBirth, MembershipDate)
        VALUES (@FirstName, @LastName, @Email, @DateOfBirth, @MembershipDate);
        SELECT SCOPE_IDENTITY() AS NewBorrowerID;
    END
END;

-- 6. Function: Calculate Overdue Fees
CREATE FUNCTION fn_CalculateOverdueFees(@LoanID INT)
RETURNS MONEY
AS
BEGIN
    DECLARE @DueDate DATE, @ReturnDate DATE, @Days INT, @Fee MONEY
    SELECT @DueDate = DueDate, @ReturnDate = DateReturned FROM Loans WHERE LoanID = @LoanID
    SET @Days = DATEDIFF(DAY, @DueDate, ISNULL(@ReturnDate, GETDATE()))
    IF @Days <= 0
        SET @Fee = 0
    ELSE IF @Days <= 30
        SET @Fee = @Days * 1
    ELSE
        SET @Fee = 30 + (@Days - 30) * 2
    RETURN @Fee
END;

-- 7. Function: Book Borrowing Frequency
CREATE FUNCTION fn_BookBorrowingFrequency(@BookID INT)
RETURNS INT
AS
BEGIN
    RETURN (SELECT COUNT(*) FROM Loans WHERE BookID = @BookID)
END;

-- 8. Overdue Books Over 30 Days
SELECT b.Title, br.FirstName, br.LastName, l.DueDate
FROM Loans l
JOIN Books b ON l.BookID = b.BookID
JOIN Borrowers br ON l.BorrowerID = br.BorrowerID
WHERE DATEDIFF(DAY, l.DueDate, GETDATE()) > 30 AND l.DateReturned IS NULL;

-- 9. Author Popularity
SELECT Author, COUNT(*) AS BorrowCount
FROM Books b
JOIN Loans l ON b.BookID = l.BookID
GROUP BY Author
ORDER BY BorrowCount DESC;

-- 10. Genre Preference by Age Group
SELECT 
    FLOOR(DATEDIFF(YEAR, br.DateOfBirth, GETDATE()) / 10) * 10 AS AgeGroup,
    b.Genre, COUNT(*) AS Total
FROM Loans l
JOIN Borrowers br ON l.BorrowerID = br.BorrowerID
JOIN Books b ON l.BookID = b.BookID
GROUP BY FLOOR(DATEDIFF(YEAR, br.DateOfBirth, GETDATE()) / 10) * 10, b.Genre;

-- 11. Stored Procedure: Borrowed Books Report
CREATE PROCEDURE sp_BorrowedBooksReport
    @StartDate DATE,
    @EndDate DATE
AS
BEGIN
    SELECT b.Title, br.FirstName, br.LastName, l.DateBorrowed
    FROM Loans l
    JOIN Books b ON l.BookID = b.BookID
    JOIN Borrowers br ON l.BorrowerID = br.BorrowerID
    WHERE l.DateBorrowed BETWEEN @StartDate AND @EndDate;
END;

-- 12. Trigger: Track Book Status Changes
CREATE TABLE AuditLog (
    LogID INT IDENTITY(1,1) PRIMARY KEY,
    BookID INT,
    StatusChange NVARCHAR(20),
    ChangeDate DATETIME DEFAULT GETDATE()
);

CREATE TRIGGER trg_BookStatusChange
ON Books
AFTER UPDATE
AS
BEGIN
    IF UPDATE(CurrentStatus)
    BEGIN
        INSERT INTO AuditLog (BookID, StatusChange)
        SELECT BookID, CurrentStatus FROM inserted
    END
END;

-- 13. Stored Procedure: Overdue Borrowers with Temp Table
CREATE PROCEDURE sp_OverdueBorrowersWithTemp
AS
BEGIN
    CREATE TABLE #OverdueBorrowers (BorrowerID INT)
    INSERT INTO #OverdueBorrowers
    SELECT DISTINCT BorrowerID FROM Loans WHERE DateReturned IS NULL AND DueDate < GETDATE()

    SELECT br.FirstName, br.LastName, l.BookID, l.DueDate
    FROM #OverdueBorrowers ob
    JOIN Borrowers br ON ob.BorrowerID = br.BorrowerID
    JOIN Loans l ON l.BorrowerID = br.BorrowerID
    WHERE l.DateReturned IS NULL AND l.DueDate < GETDATE()
END;

-- BONUS: Weekly Peak Days
SELECT DATENAME(WEEKDAY, DateBorrowed) AS DayOfWeek,
       COUNT(*) * 100.0 / (SELECT COUNT(*) FROM Loans) AS Percentage
FROM Loans
GROUP BY DATENAME(WEEKDAY, DateBorrowed)
ORDER BY Percentage DESC;
