-- TODO: remove drop database
DROP DATABASE Library;
CREATE DATABASE Library;
USE library;

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
    Phone varchar(12)
);

CREATE TABLE Employee(
	Eno char(7),
    Position varchar(15)
);

CREATE TABLE Books(
	BookID char(6),
    Btitle varchar(100),
    Isbn varchar(13),
    PublishPress varchar(50),
    YearPublished int,
    NumOfWords varchar(100),
    Price int,
    Summary varchar(999)
);

CREATE TABLE Book_Author(
	Isbn varchar(13),
	Fname varchar(20),
    Lname varchar(20)
);

CREATE TABLE Branch(
	Bno int PRIMARY KEY,
	Bname varchar(100)
);

INSERT INTO Branch(Bno,Bname)
Values(1,"Library of Business and Management");

INSERT INTO Branch(Bno,Bname)
Values(2,"Library of Science and Technology");

INSERT INTO Branch(Bno,Bname)
Values(3,"Library of Arts and Literature");

INSERT INTO Borrower(Fname,Minit,Lname,CardID,Btype,Department,Email,Sex,Bdate,Phone)
Values("John","L","Smith","1111111","Faculty",1,"jls@gmail.com","M","1965-12-08","3109873425");

INSERT INTO Borrower(Fname,Minit,Lname,CardID,Btype,Department,Email,Sex,Bdate,Phone)
Values("Sam","R","Westner","2222222","Faculty",1,"srw@gmail.com","M","1998-01-01","1896325874");

INSERT INTO Borrower(Fname,Minit,Lname,CardID,Btype,Department,Email,Sex,Bdate,Phone)
Values("Zachary","J","Perry","3333333","Faculty",1,"zjp@gmail.com","M","1987-02-05","3946751248");

INSERT INTO Borrower(Fname,Minit,Lname,CardID,Btype,Department,Email,Sex,Bdate,Phone)
Values("Oscar","M","Polonco","4444444","Faculty",1,"omp@gmail.com","M","1985-03-09","1234996525");

INSERT INTO Borrower(Fname,Minit,Lname,CardID,Btype,Department,Email,Sex,Bdate,Phone)
Values("Joshua","W","Talter","5555555","Faculty",1,"jwt@gmail.com","M","1995-04-10","3325652548");

INSERT INTO Borrower(Fname,Minit,Lname,CardID,Btype,Department,Email,Sex,Bdate,Phone)
Values("Kevin","V","Shmo","6666666","Faculty",1,"kvs@gmail.com","M","1987-05-22","3695825847");

INSERT INTO Borrower(Fname,Minit,Lname,CardID,Btype,Department,Email,Sex,Bdate,Phone)
Values("Jimmothy","D","Tolini","7777777","Faculty",1,"jdt@gmail.com","M","1975-06-23","7985632598");

INSERT INTO Borrower(Fname,Minit,Lname,CardID,Btype,Department,Email,Sex,Bdate,Phone)
Values("Michael","B","Rackner","8888888","Faculty",1,"mbr@gmail.com","M","1992-06-16","1114785259");

INSERT INTO Borrower(Fname,Minit,Lname,CardID,Btype,Department,Email,Sex,Bdate,Phone)
Values("Rebecca","C","Taylor","9999999","Faculty",1,"rct@gmail.com","F","1996-07-17","1325698569");

INSERT INTO Borrower(Fname,Minit,Lname,CardID,Btype,Department,Email,Sex,Bdate,Phone)
Values("Maddeline","T","Black","1234567","Faculty",1,"mtb@gmail.com","F","1996-08-19","3365289658");

INSERT INTO Borrower(Fname,Minit,Lname,CardID,Btype,Department,Email,Sex,Bdate,Phone)
Values("Darline","J","Dasini","7654321","Faculty",1,"djd@gmail.com","F","1997-08-23","1313125632");

INSERT INTO Borrower(Fname,Minit,Lname,CardID,Btype,Department,Email,Sex,Bdate,Phone)
Values("Jessica","L","Facht","0000000","Faculty",1,"jlf@gmail.com","F","1995-09-05","7878541259");

INSERT INTO Borrower(Fname,Minit,Lname,CardID,Btype,Department,Email,Sex,Bdate,Phone)
Values("Joana","Q","Garcia","1212121","Faculty",1,"jqg@gmail.com","F","1989-09-14","3696369636");

INSERT INTO Borrower(Fname,Minit,Lname,CardID,Btype,Department,Email,Sex,Bdate,Phone)
Values("Brenda","E","Wo","4545454","Faculty",1,"bew@gmail.com","F","1988-11-02","4565456321");







