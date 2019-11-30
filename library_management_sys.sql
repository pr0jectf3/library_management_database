-- TODO: remove drop database
DROP DATABASE Library;
CREATE DATABASE Library;
USE Library;

CREATE TABLE Loan_Type(
	Type varchar(20),
    Category varchar(20),
    Max_Loaned int,
    Loan_period int,
    Extension int,
    Late_Fine decimal(4,2),
    PRIMARY KEY(Type,Category)
);

CREATE TABLE Borrower(
	Fname varchar(20),
    Minit char,
    Lname varchar(20),
    CardID char(7),
    Btype varchar(20),
    Department varchar(100),
    Email varchar(50),
    Sex char(1),
    Bdate date,
    Phone varchar(12),
    PRIMARY KEY(CardID),
    FOREIGN KEY(Btype) REFERENCES Loan_Type(Type)
);

CREATE TABLE Online_System(
	CardID char(7),
    Username varchar(20),
    Password varchar(20),
    PRIMARY KEY(CardID)
);

CREATE TABLE Branch(
	BranchID int,
	Bname varchar(100),
    PRIMARY KEY(BranchID)
);

CREATE TABLE Employee(
	EmployeeID char(7),
    BranchID int,
    Position varchar(15),
    PRIMARY KEY(EmployeeID),
    FOREIGN KEY(BranchID) REFERENCES Branch(BranchID)
);

CREATE TABLE Books(
	BookID char(6),
    Title varchar(100),
    Category varchar(20),
    Isbn char(17),
    Publish_Press varchar(50),
    Year_Published int,
    Word_Count varchar(100),
    Price decimal(8,2),
    Summary varchar(999),
    Date_Registered date,
    PRIMARY KEY(BookID)
);

CREATE TABLE Book_Authors(
	BookID char(6),
	Author_Name varchar(50),
    PRIMARY KEY(BookID,Author_Name)
);

CREATE TABLE Book_Copies(
	CopyID char(4),
	BookID char(6),
    BranchID int,
    Status varchar(15),
    PRIMARY KEY(CopyID),
    FOREIGN KEY(BranchID) REFERENCES Branch(BranchID)
);

CREATE TABLE Book_Loans(
	LoanID char(3),
    CardID char(7),
    CopyID char(4),
    BranchID int,
    Date_Loaned date,
    Date_Expected date,
    Date_Returned date,
    Extensions_Taken int,
    Fee decimal(9,2),
    PRIMARY KEY(LoanID),
    FOREIGN KEY(CardID) REFERENCES Borrower(CardID),
    FOREIGN KEY(CopyID) REFERENCES Book_Copies(CopyID),
    FOREIGN KEY(BranchID) REFERENCES Branch(BranchID)
);


DELIMITER //
CREATE PROCEDURE Borrow(IN Loan char(3),IN memberID char(7), IN Copy char(4), In date_borrowed date)
BEGIN
	Select Category Into @category From Books Where BookID IN(Select BookID From Book_Copies Where CopyID = Copy) Limit 1;
    Select Btype Into @type From Borrower Where CardID = memberID Limit 1;
    Select BranchID Into @branch From Book_Copies Where CopyID = Copy;
    Select Late_Fine,Loan_Period Into @fine,@period From Loan_Type Where Type = @type And Category = @category;

    Set @dateExpected = Date_add(date_borrowed, Interval @period Day);
    Set @daysSinceExpected = datediff(CURDATE(),@dateExpected);
    Set @fee = 0.00;
    
    If @daysSinceExpected > @period Then
		Set @fee = @daysSinceExpected * @fine;
	End If;
    
    Insert Into Book_Loans(LoanID,CardID,CopyID,BranchID,Date_Loaned,Date_Expected,Date_Returned,Extensions_Taken,Fee)
    Values(Loan,memberID,Copy,@branch,date_borrowed,@dateExpected,NULL,0,@fee);
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE Renewal(IN Loan char(3))
BEGIN
	Select Category Into @category From Books Where BookID In(Select BookID From Book_Copies Where CopyID In(Select CopyID From Book_Loans Where LoanID = Loan));
    Select Btype Into @type From Borrower Where CardID In (Select CardID From Book_Loans Where LoanID = Loan);
    Select Date_Expected Into @expected From Book_Loans Where LoanID = Loan;
    Select Late_Fine,Loan_Period,Extension Into @fine,@period,@renewperiod From Loan_Type Where Type = @type And Category = @category;
    
    Set @newExpected = Date_add(@expected, Interval @renewperiod Day);
    Set @daysSinceExpected = datediff(CURDATE(),@newExpected);
    Set @fee = 0.00;
    
    If @daysSinceExpected > @period Then
		Set @fee = @daysSinceExpected * @fine;
	End If;
    
    Update Book_Loans Set Date_Expected = @newExpected, Extensions_Taken = Extensions_Taken+1, Fee = @fee Where LoanID = Loan;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE ReturnBook(IN Loan char(3), IN Branch int, IN Rdate date)
BEGIN
    Select Category Into @category From Books Where BookID In(Select BookID From Book_Copies Where CopyID In(Select CopyID From Book_Loans Where LoanID = Loan));
    Select Btype Into @type From Borrower Where CardID In (Select CardID From Book_Loans Where LoanID = Loan);
    Select Date_Expected Into @expected From Book_Loans Where LoanID = Loan;
    Select Late_Fine,Loan_Period Into @fine,@period From Loan_Type Where Type = @type And Category = @category;
    Set @daysSinceExpected = datediff(Rdate,@expected);
    Set @fee = 0.00;
    
    If @daysSinceExpected > @period Then
		Set @fee = ABS(@daysSinceExpected) * @fine;
	End If;
    
    Update Book_Loans Set Date_Returned = Rdate, Fee = @fee, BranchID = Branch Where LoanID = Loan;
END //
DELIMITER ;

CREATE PROCEDURE Inquiry_Borrower(IN Card char(7))
BEGIN
	
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER `set_book_lent_out` AFTER INSERT
ON `Book_Loans`
FOR EACH ROW
BEGIN
	Update Book_Copies
    Set Status = "Lent Out"
    Where CopyID = NEW.CopyID;
END;//
DELIMITER ;

DELIMITER //
CREATE TRIGGER `create_online_acct` AFTER INSERT
ON `Borrower`
FOR EACH ROW
BEGIN
	INSERT INTO Online_System(CardID,Username,Password)
    Values(NEW.CardID,NEW.CardID,date_format(NEW.Bdate,'%m%d%Y'));
END;//
DELIMITER ;

DELIMITER //
CREATE TRIGGER `check_before_returning_and_renewal` BEFORE UPDATE
ON `Book_Loans`
FOR EACH ROW
BEGIN
	Select datediff(CURDATE(),OLD.Date_Expected) Into @datediff From Book_Loans Where CardID = OLD.CardID;
     
    
    If @datediff > 0 Then
		Signal sqlstate "45000" SET message_text = "RENEWAL REJECTED: BORROWER HAS AN OVERDUE BOOK";
	END IF;
	If OLD.Extensions_Taken > 1 Then
		Signal sqlstate "45000" SET message_text = "RENEWAL REJECTED: BORROWER HAS REACHED THEIR MAXIMUM RENEWAL ON THIS LOAN";
	END IF;
    If OLD.BranchID != NEW.BranchID Then
		Signal sqlstate "45000" SET message_text = "RETURN REJECTED: BORROWER HAS ATTEMPTED TO RETURN AT THE WRONG BRANCH";
	END IF;
    If OLD.Date_Loaned = NEW.Date_Returned Then
		Signal sqlstate "45000" SET message_text = "RETURN REJECTED: BORROWER CANNOT RETURN A BOOK THE SAME DAY IT WAS BORROWED";
	END IF;
END;//
DELIMITER ;

DELIMITER //
CREATE TRIGGER `action_aftet_returning` AFTER UPDATE
ON `Book_Loans`
FOR EACH ROW
BEGIN
	IF NEW.Date_Returned Is Not NULL THEN
		Update Book_Copies Set Status = "Available" Where CopyID = OLD.CopyID;
    END IF;
END;//
DELIMITER ;

DELIMITER //
CREATE TRIGGER `check_new_book` BEFORE INSERT
ON `Books`
FOR EACH ROW
BEGIN
	IF datediff(CURDATE(),NEW.Date_Registered) < 60 THEN SET NEW.Category = "New";
    END IF;
END;//
DELIMITER ;

DELIMITER //
CREATE TRIGGER `check_before_borrowing` Before Insert
ON `Book_Loans`
FOR EACH ROW
BEGIN
	
END;//
DELIMITER ;

INSERT INTO Loan_Type(Type,Category,Max_Loaned,Loan_Period,Extension,Late_Fine)
Values
	("Faculty","English",12,90,30,0.2),
	("Faculty","Foreign",3,60,30,0.5),
	("Faculty","New",1,7,NULL,0.5),
	("Staff","English",7,60,30,0.2),
	("Staff","Foreign",1,30,30,0.5),
	("Staff","New",1,7,NULL,0.5),
	("Graduate","English",12,60,30,0.2),
	("Graduate","Foreign",3,60,30,0.5),
	("Graduate","New",1,7,NULL,0.5),
	("Undergraduate","English",8,60,30,0.2),
	("Undergraduate","Foreign",2,60,30,0.5),
	("Undergraduate","New",1,7,NULL,0.5),
	("Vocational","English",5,60,15,0.2),
	("Vocational","Foreign",1,30,15,0.5),
	("Vocational","New",1,7,NULL,0.5);
    
INSERT INTO Borrower(Fname,Minit,Lname,CardID,Btype,Department,Email,Sex,Bdate,Phone)
Values
	("John","L","Smith","1111111","Faculty","Engineering","jls@gmail.com","M","1965-12-08","3109873425"),
	("Sam","R","Westner","2222222","Faculty","English","srw@gmail.com","M","1998-01-01","1896325874"),
	("Zachary","J","Perry","3333333","Faculty","English","zjp@gmail.com","M","1987-02-05","3946751248"),
	("Oscar","M","Polonco","4444444","Faculty","Health","omp@gmail.com","M","1985-03-09","1234996525"),
	("Joshua","W","Talter","5555555","Staff","Business","jwt@gmail.com","M","1995-04-10","3325652548"),
	("Rebecca","C","Taylor","9999999","Faculty","Engineering","rct@gmail.com","F","1996-07-17","1325698569"),
	("Maddeline","T","Black","1234567","Faculty","Business","mtb@gmail.com","F","1996-08-19","3365289658"),
	("Darline","J","Dasini","7654321","Faculty","Health","djd@gmail.com","F","1997-08-23","1313125632"),
	("Jessica","L","Facht","0000000","Faculty","Engineering","jlf@gmail.com","F","1995-09-05","7878541259"),
	("Joana","Q","Garcia","1212121","Staff","English","jqg@gmail.com","F","1989-09-14","3696369636"),
	("Brenda","E","Wo","4545454","Staff","Engineering","bew@gmail.com","F","1988-11-02","4565456321");

INSERT INTO Branch(BranchID,Bname)
Values
	(1,"Branch A"),
	(2,"Branch B"),
	(3,"Branch C");

INSERT INTO Employee(EmployeeID,BranchID,Position)
Values
	("4545454",1,"Manager"),
    ("1212121",2,"Manager"),
    ("5555555",3,"Manager");

INSERT INTO Books(BookID,Title,Category,Isbn,Publish_Press,Year_Published,Word_Count,Price,Summary,Date_Registered)
Values
	("123456","Learn Python 101","English","123-6-5478-9632-5","The Coders",2005,"18325",63.25,"Become a beginner to master in Python","2008-04-18"),
	("185526","Mastering Statistics","English","111-1-1111-1111-1","Penguin Press",2003,"10258",63.25,"This book makes statistics fun to learn","2019-11-17"),
	("785825","Data Science","English","232-3-2323-2323-2","The Coders",2013,"12354",20.00,"Learn everything that is needed for a Data Science Career","2010-12-23"),
	("111122","Book of Law","English","963-9-6396-3963-9","Dasi Press",1999,"28987",100.99,"Becoming the ultimate lawer has never been so easy","2011-02-18"),
	("999636","El Negocio","Foreign","222-2-8888-2222-8","Penguin Press",2016,"11256",59.99,"Learn to be a hispanic business entrepreneur","2017-06-04"),
	("000258","OOP Design","English","333-3-3333-6666-6","The Coders",2017,"20563",35.00,"Learn Object Oriented Programming in Java","2008-08-19"),
	("789456","The Court","English","777-7-7777-4444-4","Dasi Press",2002,"25367",78.32,"Adapt to the situations in a court room with this book","2003-01-16");
    
INSERT INTO Book_Copies(CopyID,BookID,BranchID,Status)
Values
    ("1111","999636",1,"Available"),
    ("2222","999636",2,"Available"),
    ("3333","185526",3,"Available"),
    ("4444","185526",1,"Available"),
    ("5555","123456",3,"Available"),
    ("6666","123456",3,"Available"),
    ("7777","785825",1,"Avaiable"),
    ("8888","785825",3,"Available"),
    ("9999","000258",2,"Available"),
    ("1234","789456",1,"Available"),
    ("5678","111122",2,"Available"),
    ("1010","999636",3,"Available"),
    ("1212","999636",1,"Available");

INSERT INTO Book_Authors(BookID,Author_Name)
Values
	("123456","Jack Weiss"),
	("123456","Sarah Cardington"),
	("185526","Sasha Brown"),
	("785825","Phil Spencer"),
	("785825","Sasha Brown"),
	("111122","Bob Washington"),
	("999636","Mark Rackner"),
	("000258","Gale Lackman"),
	("789456","Alexandria Cortez");

Call Borrow("123","1111111","1111","2018-11-27");
Call Borrow("456","2222222","7777","2019-10-05");
Call Borrow("789","3333333","3333","2019-01-23");
Call Borrow("222","3333333","4444","2017-05-01");
Call Borrow("111","3333333","2222","2019-02-10");
Call Borrow("444","0000000","1234","2019-06-11");
Call Borrow("999","9999999","1010","2019-10-18");


Call Renewal("999");
-- -- Call Renewal("222");

-- Call ReturnBook("222",1,"2017-05-23");
-- Select * From Book_Copies;
-- Call ReturnBook("999",3,"2019-11-01");

-- Call Borrow("221","3333333","4444","2019-11-28");
Select * From Book_Loans;

-- Select Loan_period From Loan_Type Where Type = 'Faculty' And Category = 'English';







