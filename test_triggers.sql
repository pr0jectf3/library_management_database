INSERT INTO Books(BookID,Title,Category,Isbn,Publish_Press,Year_Published,Word_Count,Price,Summary,Date_Registered)
Values
	("678910","Test Book Title","English","163-6-6668-9630-2","The Testers",2019,"9999",10.00,"Test Summary","2019-12-02");
    
INSERT INTO Book_Copies(CopyID,BookID,BranchID,Status)
Values
    ("5001","678910",3,"Available"),
    ("5002","678910",3,"Available"),
    ("5003","678910",3,"Available"),
    ("5004","678910",3,"Available"),
    ("5005","678910",3,"Available");
    
Call Borrow("150","0000006","5001",curdate());

-- Cannot renew a new book
-- Call Renewal("150");

-- cannot return on same day it was borrowed
-- Call ReturnBook("150",3,curdate());

-- reached max loan on category
-- Call Borrow("151","0000006","5002",curdate());

-- borrower did not return at same branch
-- Call ReturnBook("150",2,"2019-12-04");