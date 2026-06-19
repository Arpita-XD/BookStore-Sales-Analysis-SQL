-- Ques 1 --> Retrieve all books in the "Fiction" genre;

SELECT * FROM Books
WHERE Genre = 'Fiction';


-- Ques 2 --> Find books published after year 1950

SELECT * from Books
WHERE published_year > 1950;


-- Ques 3 --> List all the Customers from Canada

SELECT * from Customers
WHERE Country = 'Canada';


-- Ques 4 --> Show Orders placed in November 2023

SELECT * from Orders
WHERE order_date between '2023-11-01' AND '2023-11-30';


-- Ques 5 --> Retrieve the total stock of books available

SELECT SUM(Stock) AS Total_Stock
from Books;


-- Ques 6 --> Find the details of most expensive book

SELECT * from Books Order By Price Desc Limit 1;


-- Ques 7 --> Show all customers who ordered more than 1 quantity of a book

SELECT * from Orders
WHERE Quantity >  1;


-- Ques 8 --> Retrieve all orders WHERE the total amount exceeds $20

SELECT * from Orders 
WHERE Total_Amount > 20;


-- Ques 9 --> List all the genres available in the books table

SELECT Distinct(Genre) from Books;


-- Ques 10 --> Find the book with the lowest stock

SELECT * from Books Order By Stock Limit 1;


-- Ques 11 --> Calculate the total revenue generated from all Orders

SELECT SUM(total_amount) AS Revenue from Orders;


-- Ques 12 --> Retrieve the total numbers of books sold for each genre 

SELECT * from Orders;

SELECT b.Genre, SUM(o.Quantity) AS Total_Books_Sold
from Books b
JOIN Orders o
ON b.Book_ID = o.Book_ID
GROUP BY b.Genre;


-- Ques 13 --> Find the average price of books in the "Fantasy" Genre

SELECT AVG(Price) AS Avg_Price from Books
WHERE genre = 'Fantasy';


-- Ques 14 --> List customers who have placed at least 2 orders

SELECT customer_id, Count(Order_id) AS Order_Count
from orders
Group By customer_id
Having Count(order_id) >= 2;


-- -------- OR -------------

SELECT o.customer_id, c.name, Count(o.Order_id) AS Order_Count
from orders o
JOIN customers c
ON o.customer_id = c.customer_id
Group by o.customer_id , c.name
Having Count(order_id) >= 2;


-- Ques 15 --> Find the most frequently ordered book

SELECT book_id, Count(order_id) AS Order_count
from orders
group by Book_id
Order By Order_count DESC Limit 1; 


---------- OR -------------

SELECT o.book_id, b.title, Count(o.order_id) AS Order_count
from orders o
JOIN Books b
ON o.book_id = b.book_id
group by o.book_id, b.title
Order By Order_count DESC Limit 1; 


-- Ques 16 --> Show the top 3 expensive books of "Fantasy" Genre

SELECT * from Books
WHERE genre = 'Fantasy'
Order By Price Desc Limit 3;


-- Ques 17 --> Retrieve the total quantity of books sold by each author

SELECT b.author, SUM(o.quantity)
from Books b
JOIN Orders o
ON b.Book_id = o.Book_id
Group By b.author;


-- Ques 18 --> List the Cities WHERE customers who spent over $30 over as located

SELECT DISTINCT c.city, total_amount
from orders o
JOIN customers c
ON o.customer_id = c.customer_id
WHERE o.total_amount > 30;


-- Ques 19 --> Find the customer who spend the most on orders

SELECT c.customer_id, c.name, SUM(o.total_amount) AS Total_Spent
from Orders o
JOIN Customers c
ON c.customer_id = o.customer_id
Group By c.customer_id, c.name
Order By Total_Spent Desc;


-- Ques 20 --> Calculate the stock remaining after fulfilling all orders

SELECT b.Book_id, b.title, b.stock, COALESCE(SUM(o.quantity),0) AS Order_quantity,
		b.stock - COALESCE(SUM(o.quantity),0) AS Remaining_quantity
from Books b
LEFT JOIN Orders o
ON b.Book_id = o.Book_id
Group By b.Book_id
Order By b.book_id;


