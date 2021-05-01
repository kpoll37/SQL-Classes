--Lab4 Part 2
--#1 1.How many rows are in the orders table? – Expect 830 rows

select * from orders;

--2.How many orders are in the order_details table? – Expect 830 rows
select count(*)
from (select distinct order_details."OrderID" 
	  from order_details) as s;

--3.How many rows are in the order_details table? – Expect 2155 rows

select * from order_details;

--4.How many customers are in the orders table? – Expect 89 rows
select count(*) 
from (select distinct orders."CustomerID" 
	  from orders) as s;

--5.How many customers are in the customers table? – Expect 91 rows
select count("CustomerID")
from customers;

--6.How many products are in the order_details table? – Expect 77 rows
select count(*)
from
	(select distinct order_details."ProductID" from order_details) as s;

--7.How many products are in the products table? – Expect 77 rows
select "ProductID"
from products;

--8.What OrderID has the highest Freight cost? – Expect “10540” 
select orders."OrderID" 
from orders
where "Freight" = 
(select max("Freight")
 From orders);

--9.What CustomerID has the most orders in orders table? – Expect “SAVEA”
select "CustomerID" 
from orders 
group by "CustomerID" 
having count("OrderID") = ( 
   select max(h."mycount") 
   from ( 
      select count("OrderID") as "mycount" 
      from Orders 
      group by "CustomerID") as h);

--10.Which ProductID is the most product in order_details?  -- Expect “59”
select "ProductID" 
from order_details  
group by "ProductID" 
having count("OrderID") =( 
		select max(h."mycount") 
		from ( 
			Select count("OrderID") as "mycount" from order_details group by "ProductID") as h);

