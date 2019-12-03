
-- 1
Create View Books_Faculty_Borrowed As
	Select BookID,Title From Books Where BookID In
		(Select BookID From Book_Copies Where CopyID In
			(Select CopyID From Book_Loans Join Borrower On 
			Book_Loans.CardID = Borrower.CardID Where Btype = "Faculty" And Department = "Electrical Engineering"));
Select * From Books_Faculty_Borrowed;
Drop View Books_Faculty_Borrowed;


-- 2
Select Avg(books) From 
	(Select Count(BL.CardID) as books From Borrower B Left Join Book_Loans BL 
		On B.CardID = BL.CardID 
        Where Department = "Computer Science" And Btype = "Graduate Student" Group By B.CardID) temp;

-- 3
Select LoanID,Fname,Lname,Borrower.CardID,CopyID,Date_Loaned,Date_Expected,Fee From Borrower 
	Join Book_Loans On Borrower.CardID = Book_Loans.CardID 
		Where Borrower.Btype = "Undergraduate Student" And Date_Returned is Null Having Datediff(CURDATE(),Date_Expected) > 0;
        
-- 4
Select Bname From Branch Where BranchID In
	(Select BranchID From Book_Loans Where CardID In 
    (Select CardID From Borrower Where Department = "Computer Science" And Btype = "Faculty"));

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
-- Select Publish_Press,BranchID From Books Join Book_Copies On Books.BookID = Book_Copies.BookID Where BranchId = 3;
-- Select Publish_Press,BranchID,Count(Publish_Press) as total From Books Join Book_Copies On Books.BookID = Book_Copies.BookID Group By BranchID,Publish_Press;
Select BranchID,Publish_Press,total From 
	(Select Publish_Press,BranchID,Count(Publish_Press) as total From Books Join Book_Copies 
		On Books.BookID = Book_Copies.BookID Group By BranchID,Publish_Press Order By total DESC) temp Group By BranchID;
        
Select Publish_Press,BranchID,Count(Publish_Press) as total From Books Join Book_Copies 
		On Books.BookID = Book_Copies.BookID Group By BranchID,Publish_Press;