select count(*) from actor;
select count(distinct actor_id) from actor;

select * from Rental;

select count(*) from Rental;
select count(distinct rental_id) from rental;

select *
from inventory
where inventory_id =1525;

select *
from customer
where customer_id = 459;

select * 
from staff
where staff_id = 1;

select * from rental
order by customer_id;

SELECT inventory_id, count(*) 
FROM rental
GROUP BY inventory_id;

select inventory_id, count(*)
from rental
group by inventory_id
order by count(*) desc;

select customer_id, count(*)
from rental
group by customer_id
order by count(*) desc;

select staff_id, count(*)
from rental
group by staff_id
order by count(*) desc;