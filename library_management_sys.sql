-- TODO: remove drop database
DROP DATABASE Library;
CREATE DATABASE Library;
USE Library;

CREATE TABLE Loan_Type(
	Type varchar(15),
    Category varchar(20),
    Max_Loaned int,
    Loan_period int,
    Extension int,
    Late_Fine double,
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
    Sex varchar(1),
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
    Isbn varchar(13),
    PublishPress varchar(50),
    YearPublished int,
    WordCount varchar(100),
    Price double,
    Summary varchar(999),
    PRIMARY KEY(BookID)
);

CREATE TABLE Book_Authors(
	BookID char(6),
	Author_Name varchar(50),
    PRIMARY KEY(BookID,Author_Name)
);

CREATE TABLE Book_Copies(
	BookID char(6),
    BranchID int,
    Copies int,
    PRIMARY KEY(BookID,BranchID),
    FOREIGN KEY(BranchID) REFERENCES Branch(BranchID)
);

CREATE TABLE Book_Loans(
	LoanID int auto_increment,
    CardID char(7),
    BookID char(6),
    BranchID int,
    Date_Loaned date,
    Date_Expected date,
    Date_Returned date,
    Extensions_Taken int,
    Fee double,
    PRIMARY KEY(LoanID),
    FOREIGN KEY(CardID) REFERENCES Borrower(CardID),
    FOREIGN KEY(BookID) REFERENCES Books(BookID),
    FOREIGN KEY(BranchID) REFERENCES Branch(BranchID)
);

DELIMITER //
CREATE TRIGGER `create_online_acct` AFTER INSERT
ON `Borrower`
FOR EACH ROW
BEGIN
	INSERT INTO Online_System(CardID,Username,Password)
    Values(NEW.CardID,NEW.CardID,date_format(NEW.Bdate,'%m%d%Y'));
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
	(1,"Library of Business and Management"),
	(2,"Library of Science and Technology"),
	(3,"Library of Arts and Literature");

INSERT INTO Employee(EmployeeID,BranchID,Position)
Values
	("4545454",1,"Manager"),
    ("1212121",2,"Manager"),
    ("5555555",3,"Manager");

INSERT INTO Books(BookID,Title,Isbn,PublishPress,YearPublished,WordCount,Price,Summary)
Values
	("123456","Learn Python 101","1236547896325","The Coders",2005,"18325",63.25,"Become a beginner to master in Python"),
	("185526","Mastering Statistics","1111111111111","Penguin Press",2003,"10258",63.25,"This book makes statistics fun to learn"),
	("785825","Data Science","2323232323232","The Coders",2013,"12354",20.00,"Learn everything that is needed for a Data Science Career"),
	("111122","Book of Law","9639639639639","Dasi Press",1999,"28987",100.99,"Becoming the ultimate lawer has never been so easy"),
	("999636","Running A Business","2222888822228","Penguin Press",2016,"11256",59.99,"Learn to be an indepentent business entrepreneur"),
	("000258","OOP Design","3333333366666","The Coders",2017,"20563",35.00,"Learn Object Oriented Programming in Java"),
	("789456","The Court","7777777744444","Dasi Press",2002,"25367",78.32,"Adapt to the situations in a court room with this book");
    
INSERT INTO Book_Copies(BookID,BranchID,Copies)
Values
	("999636",1,4),
    ("185526",1,6),
    ("123456",2,10),
    ("785825",2,5),
    ("000258",2,35),
    ("789456",3,10),
    ("111122",3,1),
    ("999636",3,4);

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

Select * from Online_System;







