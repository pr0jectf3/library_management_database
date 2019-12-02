
-- 1
Select BookID,Title From Books Where BookID In
	(Select BookID From Book_Copies Where CopyID In
		(Select CopyID From Book_Loans Join Borrower On 
		Book_Loans.CardID = Borrower.CardID Where Btype = "Faculty" And Department = "Electrical Engineering"));

Select Count(*)/Count(CopyID) From Book_Loans Where CardID In(Select CardID From Borrower Where Department = "Computer Science" And Btype = "Graduate Student");

-- 3
Select Fname,Lname,Borrower.CardID,CopyID,Date_Loaned,Date_Expected,Fee From Borrower 
	Join Book_Loans On Borrower.CardID = Book_Loans.CardID 
		Where Borrower.Btype = "Undergraduate Student" Having Datediff(CURDATE(),Date_Expected) > 0;

-- 5
Select BookID,Title From Books Where BookID Not In
	(Select BookID From Book_Copies Where BranchID != 2);
    
-- 6
Select Fname, Lname From Borrower Where CardID In
	(Select CardID From Book_Loans Where Extensions_Taken >= 1 And Date_Returned Is Null) 
	And Department = "Finance" And Btype Like '%Student%';
    
-- 7
Select CopyID,Books.BookID,Title,Category,Status From Books 
	Join Book_Copies On Books.BookID = Book_Copies.BookID 
		Where Category = "New" And BranchID = 3 And Status = "Available";

-- 8
Select Publish_Press,BranchID From Books Join Book_Copies On Books.BookID = Book_Copies.BookID Group By Publish_Press Having Count(*) >= All(Select Count(*) From Branch group by BranchID);