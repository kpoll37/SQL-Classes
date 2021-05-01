--Exercise1
select customer_name, rental_date from rental_details_2
order by customer_name, rental_date;

--Exercise2
select customer_name, rental_date, row_num,
prev_row_num
from (Select customer_name,rental_date, 
row_number() over (partition by customer_name order by customer_name) as row_num,
row_number() over () - 1 as prev_row_num
from(
select customer_name, rental_date from rental_details_2
order by customer_name, rental_date) as sub) as foo;

--Exercise3
With cust_dates as
(select customer_name,rental_date, row_num, prev_row_num
from (Select customer_name,rental_date, 
row_number() over () as row_num,
row_number() over () - 1 as prev_row_num
from(
select customer_name, rental_date from rental_details_2
order by customer_name, rental_date) as sub) as foo )


select A.customer_name, B.rental_date, A.rental_date as prev_rental_date
from cust_dates as A
join cust_dates as B on A.customer_name= B.customer_name and A.row_num=B.prev_row_num ;


--Exercise4
(select sub.customer_name, sub.rental_date, 
lag(sub.rental_date,1) over (partition by sub.customer_name order by sub.customer_name) as pre_rental_date
from(
select customer_name, rental_date from rental_details_2
order by customer_name, rental_date) as sub);

--Exercise5
select foo.customer_name, Avg(rental_date-pre_rental_date) as avg_days_rental_interval
from
(select sub.customer_name, sub.rental_date, 
lag(sub.rental_date,1) over (partition by sub.customer_name order by sub.customer_name) as pre_rental_date
from(
select customer_name, rental_date from rental_details_2
order by customer_name, rental_date) as sub) as foo
group by customer_name;

--Excercise 6
Drop view if exists customer_metrics3;
Create view customer_metrics3 as
(with cust_avg_interval as
(select foo.customer_name, Avg(rental_date-pre_rental_date) as avg_days_rental_interval
from
(select sub.customer_name, sub.rental_date, 
lag(sub.rental_date,1) over (partition by sub.customer_name order by sub.customer_name) as pre_rental_date
from(
select customer_name, rental_date from rental_details_2
order by customer_name, rental_date) as sub) as foo
group by customer_name)

select b.customer_name, b.num_rentals, b.total_amount_paid, b.overdue_fine_total, b.avg_days_rented,
b.avg_rental_length, b.favorite_actor, a.avg_days_rental_interval
from cust_avg_interval a
left join customer_metrics as b on a.customer_name=b.customer_name
group by b.customer_name, b.num_rentals, b.total_amount_paid, b.overdue_fine_total, b.avg_days_rented,
b.avg_rental_length, b.favorite_actor, a.avg_days_rental_interval);

select * from customer_metrics3;
