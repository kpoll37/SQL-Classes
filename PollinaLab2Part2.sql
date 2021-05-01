/* Exercise 1 */

select f.title, f.rental_duration, f.rental_rate, f.length, f.replacement_cost, f.rating, c.name as category_name
from film as f
join film_category as fc on fc.film_id = f.film_id
join category as c on c.category_id = fc.category_id
order by 1;

/* Exercise 2 */

/* Note to self: use the primary keys! */
select c.first_name || ' ' || c.last_name as customer_name, f.title as film_name, r.rental_date,
r.return_date, p.amount as payment
from customer as c join rental as r on r.customer_id = c.customer_id
join payment as p on p.rental_id = r.rental_id
join inventory as i on i.inventory_id = r.inventory_id
join film as f on f.film_id = i.film_id
where c.first_name || ' ' || c.last_name = 'Roy Whiting';


/* Exercise 3 */

select c.first_name || ' ' || c.last_name as customer_name, sum(p.amount) as total_payment
from customer c join rental r on c.customer_id = r.customer_id
join payment p on p.rental_id = r.rental_id
join inventory i on i.inventory_id = r.inventory_id
join film f on f.film_id = i.film_id
group by c.first_name || ' ' || c.last_name 
order by c.first_name || ' ' || c.last_name;


