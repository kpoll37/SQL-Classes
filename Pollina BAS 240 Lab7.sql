Drop view if exists customer_actor;
Create view customer_actor as
Select c.customer_id, c.first_name || ' ' || c.last_name as customer_name,
a.actor_id, a.first_name || ' ' || a.last_name as actor_name,
f.film_id, f.title as film_name
from rental as r
join customer as c on r.customer_id = c.customer_id
join inventory as i on r.inventory_id = i.inventory_id
join film as f on i.film_id = f.film_id
join film_actor as fa on f.film_id = fa.film_id
join actor as a on fa.actor_id = a.actor_id;

select * from customer_actor;

Drop view if exists customer_actor2;
Create view customer_actor2 as 
select distinct customer_name, actor_name, count(actor_name) as num_rentals
from customer_actor
group by customer_name, actor_name
order by customer_name, num_rentals desc;

select * from customer_actor2;

drop view if exists customer_actor3;
create view customer_actor3 as
(select distinct a.customer_name, actor_name, num_rentals, max_rentals
from customer_actor2 as a
join (
	select customer_name, max(num_rentals) as max_rentals
	from customer_actor2
	group by customer_name
	order by max_rentals) as b
on a.customer_name = b.customer_name
where num_rentals = max_rentals);

select * from customer_actor3;

drop view if exists customer_actor4;
Create view customer_actor4 as
(select distinct a.customer_name, actor_name, num_rentals, max_rentals
from customer_actor2 as a
join (
	select customer_name, max(num_rentals) 
	OVER (Partition by customer_name) as max_rentals
	from customer_actor2) as b
on a.customer_name = b.customer_name
where num_rentals = max_rentals
group by a.customer_name, actor_name, num_rentals, max_rentals
order by a.customer_name, max_rentals);