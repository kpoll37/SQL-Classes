CREATE TABLE aisles (aisle_id integer, aisle varchar);
CREATE TABLE departments (department_id integer, department varchar);
CREATE TABLE order_products_prior (order_id integer, product_id integer, add_to_cart_order integer, reordered integer);
CREATE TABLE order_products_train (order_id integer, product_id integer, add_to_cart_order integer, reordered integer);
CREATE TABLE orders (order_id integer, user_id integer, eval_set char(5), order_number integer, order_dow integer, order_hour_of_day integer, days_since_prior_order double precision);
CREATE TABLE products (product_id integer, product_name varchar, aisle_id integer, department_id integer);

COPY aisles FROM 'C:\Users\stoli\Documents\BAS 240 NOT One Drive\instacart-market-basket-analysis\aisles.csv\aisles.csv' DELIMITER ',' CSV HEADER;
COPY departments FROM 'C:\Users\stoli\Documents\BAS 240 NOT One Drive\instacart-market-basket-analysis\departments.csv\departments.csv' DELIMITER ',' CSV HEADER;
COPY order_products_prior FROM 'C:\Users\stoli\Documents\BAS 240 NOT One Drive\instacart-market-basket-analysis\order_products__prior.csv\order_products__prior.csv' DELIMITER ',' CSV HEADER;
COPY order_products_train FROM 'C:\Users\stoli\Documents\BAS 240 NOT One Drive\instacart-market-basket-analysis\order_products__train.csv\order_products__train.csv' DELIMITER ',' CSV HEADER;
COPY orders FROM 'C:\Users\stoli\Documents\BAS 240 NOT One Drive\instacart-market-basket-analysis\orders.csv\orders.csv'DELIMITER ',' CSV HEADER;
COPY products FROM 'C:\Users\stoli\Documents\BAS 240 NOT One Drive\instacart-market-basket-analysis\products.csv\products.csv'  DELIMITER ',' CSV HEADER;

ALTER TABLE aisles
ADD PRIMARY KEY (aisle_id);

ALTER TABLE departments
ADD PRIMARY KEY (department_id);

ALTER TABLE order_products_prior
ADD PRIMARY KEY (order_id, product_id);

ALTER TABLE order_products_train
ADD Primary Key (order_id, product_id);

ALTER TABLE orders
ADD Primary Key (order_id);

ALTER TABLE products
ADD PRIMARY KEY (product_id),
ADD FOREIGN KEY (aisle_id) References aisles(aisle_id),
ADD FOREIGN KEY (department_id) References departments(department_id);

Select * 
from aisles limit 100;

select *
from departments limit 100;

select *
from order_products_prior 
order by product_id desc limit 100;

select *
from order_products_train 
order by product_id desc limit 100;

select *
from order_products_prior 
order by order_id desc limit 100;

select *
from order_products_train 
order by order_id desc limit 100;

select *
from orders limit 100;

select *
from products
limit 100;
--I ran into a series of problems. I need to drop table orders; and try to fix my error. When I dropped the table,
--I reimported it using the column hour_of_day as an integer so I would use the case when. I tried many ways
--before that and nothing worked. If it is a problem let me know.

--10 Check Lab 2
select *
from order_products_prior as op
full outer join order_products_train as t
on t.order_id = op.order_id
limit 1000;

select t.product_id, count(distinct t.product_id)
from order_products_train as t
full join order_products_prior as op
on t.order_id = op.order_id
group by t.order_id, op.order_id, t.product_id
order by t.order_id, op.order_id 
limit 100;


--train has 131209 records
select count(distinct order_id)
from order_products_train;

--prior has 3214874
select count(distinct order_id)
from order_products_prior;

select distinct order_id 
from order_products_prior
group by order_id
limit 100;

select distinct order_id
from order_products_train
group by order_id
limit 100;

--11

select * 
from orders as o
join order_products_train as t
on o.order_id = t.order_id
limit 1000;


select *,
	(case when order_dow = 0 then 'Monday'
		 when order_dow = 1 then 'Tuesday'
		 when order_dow = 2 then 'Wednesday'
		 when order_dow = 3 then 'Thursday'
		 when order_dow = 4 then 'Friday'
		 when order_dow = 5 then 'Saturday'
		 else 'Sunday' end) as Day_of_Week,
		 	(case when order_hour_of_day < 6 then 'Early Morning Hours'
	 			when order_hour_of_day >= 6 and order_hour_of_day < 12 then 'Morning Hours'
				when order_hour_of_day >=12 and order_hour_of_day < 17 then 'Afternoon Hours'
				when order_hour_of_day >=17 and order_hour_of_day < 20 then 'Evening Hours'
				else 'Nighttime Hours' end) as time_of_day
from orders as o
join order_products_train as t
on o.order_id = t.order_id
limit 1000;

Drop view if exists orders_opt_merge;
CREATE VIEW orders_opt_merge 
as select o.order_id, o.order_dow, o.order_hour_of_day, product_id,
	(case when order_dow = 0 then 'Monday'
		 when order_dow = 1 then 'Tuesday'
		 when order_dow = 2 then 'Wednesday'
		 when order_dow = 3 then 'Thursday'
		 when order_dow = 4 then 'Friday'
		 when order_dow = 5 then 'Saturday'
		 else 'Sunday' end) as Day_of_Week,
		 	(case when order_hour_of_day < 6 then 'Early Morning Hours'
	 			when order_hour_of_day >= 6 and order_hour_of_day < 12 then 'Morning Hours'
				when order_hour_of_day >=12 and order_hour_of_day < 17 then 'Afternoon Hours'
				when order_hour_of_day >=17 and order_hour_of_day < 20 then 'Evening Hours'
				else 'Nighttime Hours' end) as time_of_day
from orders o, order_products_train t
where o.order_id = t.order_id
limit 1000;


select *
from orders_opt_merge;

select *
from orders_opt_merge
where day_of_week = 'Friday';

--Try to figure out avg orders on days of week.)
select distinct day_of_week, count(day_of_week) as totals
from orders_opt_merge
group by day_of_week
order by day_of_week
limit 1000;

--avg # of orders on weekend days and weekdays
SELECT (Round(avg(wkend),2)) as wkend_avg, round(avg(wkday),2) as wkday_avg
  FROM 
    (
    SELECT day_of_week, COUNT(day_of_week) AS wkend
		FROM orders_opt_merge
	WHERE day_of_week = 'Friday' or day_of_week = 'Saturday' or day_of_week ='Sunday'
		group by day_of_week
      ) as weekend_total,
	  (select day_of_week, count(day_of_week) as wkday
	  from orders_opt_merge
	  where day_of_week = 'Monday' or day_of_week = 'Tuesday' or day_of_week = 'Wednesday' 
	   or day_of_week ='Thursday'
	  group by day_of_week) as wkday_total
limit 1000;

--Day and Time of orders placed
Select distinct day_of_week, time_of_day, count(time_of_day)
from orders_opt_merge
group by day_of_week, time_of_day;

----Day and Time of most orders placed
Select distinct day_of_week, time_of_day, count(time_of_day)
from orders_opt_merge
group by day_of_week, time_of_day
order by count desc;


Drop view if exists prd_asl_dpts;
create view prd_asl_dpts
as Select p.aisle_id, p.product_id, p.product_name, p.department_id, d.department, a.aisle
from products as p 
join aisles as a on a.aisle_id = p.aisle_id
join departments as d on d.department_id = p.department_id
limit 1000;

select *
from prd_asl_dpts;

select distinct aisle
from prd_asl_dpts
order by aisle desc;

select aisle
from prd_asl_dpts
where aisle like '%wine%';

select aisle, count(product_id)
from prd_asl_dpts
where aisle like '%wine%'
group by product_id, aisle
order by count desc;

Drop view if exists prd_asl_dep_orders_merge;
create view prd_asl_dep_orders_merge
as Select p.aisle_id, p.product_id, p.product_name, p.department_id, d.department, a.aisle, o.order_id,
o.order_hour_of_day, o.order_dow
from products as p 
join aisles as a on a.aisle_id = p.aisle_id
join departments as d on d.department_id = p.department_id
join order_products_train as t on t.product_id = p.product_id
join orders as o on o.order_id = t.order_id
limit 1000;

Drop view if exists prd_asl_dep_orders_days_times_merge;
create view prd_asl_dep_orders_days_times_merge as
select order_id, order_dow, order_hour_of_day, product_id, aisle, product_name, department_id, department,
	(case when order_dow = 0 then 'Monday'
		 when order_dow = 1 then 'Tuesday'
		 when order_dow = 2 then 'Wednesday'
		 when order_dow = 3 then 'Thursday'
		 when order_dow = 4 then 'Friday'
		 when order_dow = 5 then 'Saturday'
		 else 'Sunday' end) as Day_of_Week,
		 	(case when order_hour_of_day < 6 then 'Early Morning Hours'
	 			when order_hour_of_day >= 6 and order_hour_of_day < 12 then 'Morning Hours'
				when order_hour_of_day >=12 and order_hour_of_day < 17 then 'Afternoon Hours'
				when order_hour_of_day >=17 and order_hour_of_day < 20 then 'Evening Hours'
				else 'Nighttime Hours' end) as time_of_day
from prd_asl_dep_orders_merge
limit 1000;

select *
from prd_asl_dep_orders_days_times_merge;

--snapshot of aisle with wine and when purchased.
select aisle, product_name, day_of_week, time_of_day, count(order_id)
from prd_asl_dep_orders_days_times_merge
where aisle like '%wine%'
group by aisle, day_of_week, time_of_day, product_name
order by count desc;

select aisle
from prd_asl_dep_orders_days_times_merge;

select product_name
from prd_asl_dep_orders_days_times_merge;

select product_name, count(distinct product_name)
from prd_asl_dep_orders_days_times_merge
group by product_name
order by count desc;

select distinct day_of_week, count(product_name)   
from prd_asl_dep_orders_days_times_merge
where product_name like '%Organic%'
group by day_of_week
order by count desc;

select day_of_week, time_of_day, count(product_name)   
from prd_asl_dep_orders_days_times_merge
where product_name like '%Organic%'
group by day_of_week, time_of_day
order by count(product_name) desc;
