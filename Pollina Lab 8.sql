select * from customer_actor
order by customer_name;

select * from customer_actor2
order by customer_name;

select * from customer_actor3
order by customer_name;

select * from customer_actor4
order by customer_name;

--Exercise 1.1
select customer_name, count(distinct actor_name) as num_favorite_actor
from customer_actor4
group by customer_name
order by customer_name, num_favorite_actor;

--Exercise 1.2a
select a.customer_name, b.actor_name as favorite_actor, a.num_favorite_actor
from (select customer_name, num_favorite_actor
from (select customer_name, count(customer_name) as num_favorite_actor
from customer_actor4
group by customer_name) as sub
where num_favorite_actor=1) as a
left join customer_actor4 as b on
a.customer_name=b.customer_name
order by customer_name;

--Exercise 1.2b
SELECT customer_name, count(customer_name) || ' multiple actors' as favorite_actor, count(customer_name) as num_favorite_actor
from customer_actor4
group by customer_name
having count(customer_name) > 1
order by customer_name, num_favorite_actor;

--Exercise 1.3
--I created a signle fav actor view
create view single_fav_actor as
select a.customer_name, b.actor_name as favorite_actor, a.num_favorite_actor
from (select customer_name, num_favorite_actor
from (select customer_name, count(customer_name) as num_favorite_actor
from customer_actor4
group by customer_name) as sub
where num_favorite_actor=1) as a
left join customer_actor4 as b on
a.customer_name=b.customer_name
order by customer_name;

--then a multiple actor view
Create view mult_fav_actor as
SELECT customer_name, count(customer_name) || ' multiple actors' as favorite_actor, count(customer_name) as num_favorite_actor
from customer_actor4
group by customer_name
having count(customer_name) > 1
order by customer_name, num_favorite_actor;

--I unioned both of these
select customer_name, favorite_actor, num_favorite_actor
from single_fav_actor
union all
select customer_name, favorite_actor, num_favorite_actor
from mult_fav_actor
order by customer_name;


--Ex 1.4
Create view customer_favorite_actor as
select customer_name, favorite_actor, num_favorite_actor
from single_fav_actor
union all
select customer_name, favorite_actor, num_favorite_actor
from mult_fav_actor
order by customer_name;

--Exercise 1.5
/*select sub.customer_name, sub.num_rentals, sum(a.amount_paid) as total_amount_paid, 
sum(a.overdue_fine_total) as overdue_fine_total, avg(a.num_days_rented) as avg_days_rented,
avg(a.length) as avg_rental_length,
b.favorite_actor
from 
(select customer_name, count(customer_name) as num_rentals
from rental_details_2
group by customer_name
order by num_rentals desc) as sub
join customer_favorite_actor as b on sub.customer_name =b.customer_name
join rental_details_2 as a on sub.customer_name=a.customer_name
group by sub.customer_name, sub.num_rentals, b.favorite_actor
order by sub.customer_name;*/

Drop view if exists customer_metrics;
Create view customer_metrics as
select sub.customer_name, sub.num_rentals, sum(a.amount_paid) as total_amount_paid, 
sum(a.overdue_fine_total) as overdue_fine_total, avg(a.num_days_rented) as avg_days_rented, 
avg(a.length) as avg_rental_length,
b.favorite_actor
from 
(select customer_name, count(customer_name) as num_rentals
from rental_details_2
group by customer_name
order by num_rentals desc) as sub
join customer_favorite_actor as b on sub.customer_name =b.customer_name
join rental_details_2 as a on sub.customer_name=a.customer_name
group by sub.customer_name, sub.num_rentals, b.favorite_actor
order by sub.customer_name;

--Exercise 2
Drop view if exists customer_metrics2;
Create view customer_metrics2 as

with customer_favorite_actor as
(Select customer_name, favorite_actor from customer_favorite_actor),
customer_metrics as
(Select customer_name, num_rentals, total_amount_paid, 
overdue_fine_total, avg_days_rented, 
avg_rental_length from customer_metrics
group by customer_name, num_rentals, total_amount_paid, 
overdue_fine_total, avg_days_rented, 
avg_rental_length)

select * from customer_metrics
join customer_favorite_actor using (customer_name)
group by customer_name, num_rentals, total_amount_paid, 
overdue_fine_total, avg_days_rented, 
avg_rental_length, favorite_actor;

select * from customer_metrics2;


