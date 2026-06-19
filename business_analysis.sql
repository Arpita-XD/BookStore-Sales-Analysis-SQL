-- Ques 41 --> Top-selling genre
WITH top_selling AS
(
    SELECT b.genre,
           SUM(o.total_amount) AS revenue
    FROM Orders o
    JOIN Books b
    ON o.book_id = b.book_id
    GROUP BY b.genre
)
SELECT *
FROM top_selling
ORDER BY revenue DESC
LIMIT 1;

-- Ques 42 --> Least-selling genre

WITH top_selling AS
(
	SELECT b.genre, SUM(o.total_amount) AS revenue
	from Orders o
	JOIN Books b
	ON o.book_id = b.book_id
	Group By b.genre
	Order By revenue ASC
)
SELECT *
FROM top_selling
ORDER BY revenue ASC
LIMIT 1;


-- Ques 43 --> Top city by revenue

WITH top_city_rev AS
(
	SELECT c.city,  SUM(o.total_amount) AS revenue
	from Orders o
	JOIN Customers c
	ON o.customer_id = c.customer_id
	Group By City
)
SELECT *
FROM top_city_rev
ORDER BY revenue DESC
LIMIT 1;


-- Ques 44 --> Revenue by author

WITH rev_author AS
(
    SELECT b.author,
           SUM(o.total_amount) AS revenue
    FROM Orders o
    JOIN Books b
    ON b.book_id = o.book_id
    GROUP BY b.author
)
SELECT *
FROM rev_author;


-- Ques 45 --> Inventory status using CASE

SELECT book_id,
       title,
       stock,
       CASE
           WHEN stock = 0 THEN 'Out Of Stock'
           WHEN stock <= 10 THEN 'Low Stock'
           ELSE 'Enough Stock'
       END AS status
FROM Books;

-- Ques 46 --> Find repeat customers (customers with more than 1 order)

WITH rept_customers AS
(
	SELECT c.customer_id, c.name, COUNT(o.customer_id) AS rept_cus
	from Orders o
	JOIN Customers c
	ON c.customer_id = o.customer_id
	Group By c.customer_id, c.name
)
SELECT *
from rept_customers
WHERE rept_cus > 1;

-- Ques 47 --> Find customer lifetime value (CLV).

SELECT c.customer_id,c.name, SUM(o.total_amount) AS CLV
from Orders o
JOIN Customers c
ON o.customer_id = c.customer_id
Group By c.customer_id, c.name;

-- Ques 48 --> List all unsold books.

SELECT * from Books
where book_id NOT IN 
(
	SELECT book_id 
	from Orders
)


-- Ques 49 --> Show revenue share by genre (%).

WITH revenue AS
(
    SELECT b.genre,
           SUM(total_amount) AS total
    FROM Orders o
	JOIN Books b
	ON b.book_id = o.book_id
    GROUP BY b.genre
)
SELECT *,
       100.0 * total / SUM(total) OVER() AS contribution_percent
FROM revenue;


-- Ques 50 --> Find the best-selling book in each genre. --

WITH book_sales AS
(
    SELECT b.book_id,
           b.title,
           b.genre,
           SUM(o.quantity) AS quantity_sold
    FROM Books b
    JOIN Orders o
    ON b.book_id = o.book_id
    GROUP BY b.book_id, b.title, b.genre
),
ranked_books AS
(
    SELECT *,
           DENSE_RANK() OVER(
               PARTITION BY genre
               ORDER BY quantity_sold DESC
           ) AS rnk
    FROM book_sales
)
SELECT book_id,
       title,
       genre,
       quantity_sold
FROM ranked_books
WHERE rnk = 1
ORDER BY genre, quantity_sold DESC;
 
