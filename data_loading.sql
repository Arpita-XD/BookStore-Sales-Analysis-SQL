COPY Books(Book_ID, Title, Author, Genre, Published_Year, Price, Stock)
FROM 'E:/SqlProject/Books.csv'
CSV HEADER;

COPY Customers(Customer_ID, Name, Email, Phone, City, Country)
FROM 'E:/SqlProject/Customers.csv'
CSV HEADER;

COPY Orders(Order_ID, Customer_ID, Book_ID, Order_Date, Quantity, Total_Amount)
FROM 'E:/SqlProject/Orders.csv'
CSV HEADER;
