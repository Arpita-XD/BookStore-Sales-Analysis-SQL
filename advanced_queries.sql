-- Ques 21 --> Books priced above average price

SELECT * from Books
WHERE price > 
(
	SELECT AVG(price) from Books
)


-- Ques 22 --> Customers who never placed an order.

SELECT customer_id, name from Customers 
where customer_id NOT IN
(
	SELECT customer_id from Orders
)


-- Ques 23 --> Books never ordered

SELECT Book_id, title from Books
WHERE Book_id NOT IN
(
	SELECT Book_id from Orders
);


-- Ques 24 --> Customer(s) with highest total spending

SELECT customer_id, SUM(total_amount) AS total_spending 
from Orders
Group By customer_id0.
order by total_spending desc ;


-- Ques 25 --> Most expensive book in each genre

SELECT title, genre, price from Books
where (genre, price) IN
(
	SELECT genre, max(price) As expensive
	from Books
	Group By Genre  
)


-- Ques 26 --> Create a customer spending summary showing:
-- customer_id
-- customer_name
-- total_orders
-- total_spent

WITH summary AS
(
    SELECT customer_id,
           COUNT(*) AS total_orders,
           SUM(total_amount) AS total_spent
    FROM Orders
    GROUP BY customer_id
)
SELECT c.customer_id,
       c.name,
       s.total_orders,
       s.total_spent
FROM Customers c
JOIN summary s
ON c.customer_id = s.customer_id;


-- Ques 27 --> Show customers whose total spending is greater than the average customer spending. --

WITH customer_spending AS
(
    SELECT customer_id,
           SUM(total_amount) AS total_spent
    FROM Orders
    GROUP BY customer_id
)
SELECT *
FROM customer_spending
WHERE total_spent >
(
    SELECT AVG(total_spent)
    FROM customer_spending
);


-- Ques 28 --> Retrieve the Top 5 customers by revenue.

WITH revenue As
(
	SELECT customer_id , SUM(total_amount) AS rev
	from Orders
	Group By customer_id
)
SELECT c.customer_id, c.name, r.rev from Customers c
JOIN revenue r
ON c.customer_id = r.customer_id
ORDER BY r.rev DESC
Limit 5;


-- Ques 29 --> Create a book sales summary showing:
-- book_id
-- title
-- total_quantity_sold
-- total_revenue

WITH BookSummary AS
(
	SELECT book_id, SUM(quantity) AS qty, SUM(total_amount) AS totalAmount
	from Orders
	Group By book_id
)
SELECT b.book_id, b.title, s.qty, s.totalAmount
from Books b
JOIN BookSummary s
ON b.book_id = s.book_id;


-- Ques 30 --> Find genres generating above-average revenue.--

WITH genre_revenue AS
(
	SELECT b.genre, SUM(o.total_amount) AS revenue
	from Books b
	JOIN Orders o
	ON b.book_id = o.book_id
	Group By b.Genre
)
SELECT *
FROM genre_revenue
WHERE revenue >
(
   SELECT AVG(revenue)
   FROM genre_revenue
);


-- Ques 31 --> Show total revenue generated in each year.

SELECT EXTRACT(YEAR FROM order_date) AS year,
       SUM(total_amount) AS revenue
FROM Orders
Group By EXTRACT(YEAR FROM order_date);


-- Ques 32 --> Show total revenue generated in each month.

SELECT EXTRACT(MONTH FROM order_date) AS month,
	SUM(total_amount) AS revenue
FROM Orders
Group By EXTRACT(MONTH FROM order_date)
Order By EXTRACT(MONTH FROM order_date); 


-- Ques 33 --> Show number of orders placed in each month.

SELECT EXTRACT(MONTH FROM order_date) AS month,
	Count(customer_id) AS num_of_orders
FROM orders
Group By EXTRACT(MONTH FROM order_date)
Order By EXTRACT(MONTH FROM order_date); 


-- QUES 34 --> Find the year with the highest revenue.

SELECT EXTRACT(YEAR FROM order_date) AS year,
       SUM(total_amount) AS revenue
FROM Orders
Group By year
ORDER BY revenue Desc LIMIT 1;


-- Ques 35 --> Find the month with the highest revenue.

SELECT EXTRACT(MONTH FROM order_date) AS month,
       SUM(total_amount) AS revenue
FROM Orders
Group By month
ORDER BY revenue Desc LIMIT 1;


-- Ques 36 --> Rank customers by total spending. --

WITH customer_spend AS
(
	SELECT customer_id, SUM(total_amount) AS total_spent
	from Orders
	Group By customer_id
)
select customer_id , total_spent,
DENSE_RANK() OVER(Order By total_spent Desc)
AS cus_total_spend
from customer_spend;


-- Ques37 --> Show the top 3 customers by spending.--

WITH customer_spend AS
(
    SELECT customer_id,
           SUM(total_amount) AS total_spent
    FROM Orders
    GROUP BY customer_id
),
ranked AS
(
    SELECT customer_id,
           total_spent,
           DENSE_RANK() OVER(ORDER BY total_spent DESC) AS rnk
    FROM customer_spend
)
SELECT *
FROM ranked
WHERE rnk <= 3;


-- Ques 38 --> Show running revenue over time.

SELECT customer_id,
       total_amount,
	   order_date,
       SUM(total_amount) OVER(ORDER BY order_date) AS running_revenue
FROM Orders;


-- Ques 39 --> For each order, show the previous order's amount.

SELECT order_id,
       total_amount,
       LAG(total_amount) OVER(ORDER BY order_id) AS previous_order_amount
FROM Orders;


-- Ques 40 --> Show each customer's contribution to total revenue as a percentage.

WITH revenue AS
(
    SELECT customer_id,
           SUM(total_amount) AS total
    FROM Orders
    GROUP BY customer_id
)
SELECT customer_id,
       total,
       ROUND(
           total * 100.0 /
           SUM(total) OVER(),
           2
       ) AS contribution_percent
FROM revenue;


***************OR****************

WITH revenue AS
(
    SELECT customer_id,
           SUM(total_amount) AS total
    FROM Orders
    GROUP BY customer_id
)
SELECT *,
       100.0 * total / SUM(total) OVER() AS contribution_percent
FROM revenue;
