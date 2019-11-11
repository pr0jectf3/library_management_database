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
Values("John","L","Smith","1234567","Faculty",1,"jls@gmail.com","M","1965-12-08","3109873425");

INSERT INTO Borrower(Fname,Minit,Lname,CardID,Btype,Department,Email,Sex,Bdate,Phone)
Values("Sam","L","Smith","1234567","Faculty",1,"jls@gmail.com","M","1965-12-08","3109873425");

INSERT INTO Borrower(Fname,Minit,Lname,CardID,Btype,Department,Email,Sex,Bdate,Phone)
Values("John","L","Smith","1234567","Faculty",1,"jls@gmail.com","M","1965-12-08","3109873425");

INSERT INTO Borrower(Fname,Minit,Lname,CardID,Btype,Department,Email,Sex,Bdate,Phone)
Values("John","L","Smith","1234567","Faculty",1,"jls@gmail.com","M","1965-12-08","3109873425");

INSERT INTO Borrower(Fname,Minit,Lname,CardID,Btype,Department,Email,Sex,Bdate,Phone)
Values("John","L","Smith","1234567","Faculty",1,"jls@gmail.com","M","1965-12-08","3109873425");

INSERT INTO Borrower(Fname,Minit,Lname,CardID,Btype,Department,Email,Sex,Bdate,Phone)
Values("John","L","Smith","1234567","Faculty",1,"jls@gmail.com","M","1965-12-08","3109873425");

INSERT INTO Borrower(Fname,Minit,Lname,CardID,Btype,Department,Email,Sex,Bdate,Phone)
Values("John","L","Smith","1234567","Faculty",1,"jls@gmail.com","M","1965-12-08","3109873425");

INSERT INTO Borrower(Fname,Minit,Lname,CardID,Btype,Department,Email,Sex,Bdate,Phone)
Values("John","L","Smith","1234567","Faculty",1,"jls@gmail.com","M","1965-12-08","3109873425");

INSERT INTO Borrower(Fname,Minit,Lname,CardID,Btype,Department,Email,Sex,Bdate,Phone)
Values("John","L","Smith","1234567","Faculty",1,"jls@gmail.com","M","1965-12-08","3109873425");

INSERT INTO Borrower(Fname,Minit,Lname,CardID,Btype,Department,Email,Sex,Bdate,Phone)
Values("John","L","Smith","1234567","Faculty",1,"jls@gmail.com","M","1965-12-08","3109873425");

INSERT INTO Borrower(Fname,Minit,Lname,CardID,Btype,Department,Email,Sex,Bdate,Phone)
Values("John","L","Smith","1234567","Faculty",1,"jls@gmail.com","M","1965-12-08","3109873425");

INSERT INTO Borrower(Fname,Minit,Lname,CardID,Btype,Department,Email,Sex,Bdate,Phone)
Values("John","L","Smith","1234567","Faculty",1,"jls@gmail.com","M","1965-12-08","3109873425");

INSERT INTO Borrower(Fname,Minit,Lname,CardID,Btype,Department,Email,Sex,Bdate,Phone)
Values("John","L","Smith","1234567","Faculty",1,"jls@gmail.com","M","1965-12-08","3109873425");

INSERT INTO Borrower(Fname,Minit,Lname,CardID,Btype,Department,Email,Sex,Bdate,Phone)
Values("John","L","Smith","1234567","Faculty",1,"jls@gmail.com","M","1965-12-08","3109873425");







