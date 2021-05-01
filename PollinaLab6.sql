--Created View actor_data
Drop view if exists actor_data;
Create view actor_data as
select
a.actor_id, a.first_name||' '|| a.last_name as actorname, f.film_id, f.title, f.rating, c.name, r.rental_date,
p.amount, r.rental_id
from rental as r

left join payment as p on r.rental_id= p.rental_id
join inventory as i on r.inventory_id = i.inventory_id
join film as f on i.film_id=f.film_id
join film_category as fc on f.film_id = fc.film_id
left join film_actor as flac on f.film_id = flac.film_id
join category as c on fc.category_id = c.category_id
left join actor as a on a.actor_id = flac.actor_id;

--1. Which actor is in the most films?
Select actorname, count(distinct(title))
from actor_data
group by actorname
order by count desc;

--2. Which actor is in the most comedy films?
/* I run this to find out how comedy is typed:
select *
from actor_data; */

select distinct actorname, count(distinct (title))
from actor_data
where name = 'Comedy'
group by actorname
order by count desc;

--3.Which actor is in the most r-rated films?
select actorname, count(distinct(title))
from actor_data
where rating = 'R'
group by actorname
order by count desc;

--4. Which actor had the most rentals and made the most money?
Select actorname, times_rent, money_made 
from (select actorname, count(title) as times_rent, sum(amount) as money_made
				  from actor_data
	 group by actorname) as subquery
order by money_made desc;

/*select actorname, count(title) as times_rent, sum(amount) as money_made
from actor_data
group by actorname
order by money_made desc; */

--5. Which movie had the most actors?
select count(distinct(actorname)), title
from actor_data
group by title
order by count desc;
