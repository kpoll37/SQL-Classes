--Exercise 1

select rental_id, amount from payment
where rental_id = 4591;

select rental_id, sum(amount) as total_amount from payment
group by rental_id;

SELECT a.rental_id, a.rental_date, a.return_date,
	b.film_id, b.store_id, 
	c.first_name AS staff_name, 
	d.first_name || ' ' || d.last_name AS customer_name,
	e.title, e.rental_duration, e.rental_rate, e.length, e.replacement_cost, e.rating,
	g.name AS category_name,
	h.total_amount AS amount_paid
FROM rental AS a 
JOIN inventory AS b ON a.inventory_id = b.inventory_id
JOIN staff AS c ON a.staff_id = c.staff_id
JOIN customer AS d ON a.customer_id = d.customer_id
JOIN film AS e ON b.film_id = e.film_id
JOIN film_category AS f ON e.film_id = f.film_id
JOIN category AS g ON f.category_id = g.category_id
LEFT JOIN (select rental_id, sum(amount) as total_amount 
		   from payment group by rental_id) as h ON a.rental_id = h.rental_id;

Drop view if exists rental_details;
Create view rental_details as
SELECT a.rental_id, a.rental_date, a.return_date,
	b.film_id, b.store_id, 
	c.first_name AS staff_name, 
	d.first_name || ' ' || d.last_name AS customer_name,
	e.title, e.rental_duration, e.rental_rate, e.length, e.replacement_cost, e.rating,
	g.name AS category_name,
	h.total_amount AS amount_paid
FROM rental AS a 
JOIN inventory AS b ON a.inventory_id = b.inventory_id
JOIN staff AS c ON a.staff_id = c.staff_id
JOIN customer AS d ON a.customer_id = d.customer_id
JOIN film AS e ON b.film_id = e.film_id
JOIN film_category AS f ON e.film_id = f.film_id
JOIN category AS g ON f.category_id = g.category_id
LEFT JOIN (select rental_id, sum(amount) as total_amount 
		   from payment group by rental_id) as h ON a.rental_id = h.rental_id;
		   
select * from rental_details;

--Exercise 2;

select rental_id, return_date - rental_date as num_days_rented
from rental_details
where rental_id=2;

SELECT *,
	return_date - rental_date as num_days_rented,
	extract(day from return_date - rental_date) - rental_duration as num_days_overdue,
	(amount_paid - rental_rate) as overdue_fine_total,
	round(amount_paid / rental_duration, 2) as rental_rate_per_day,
	to_char(rental_date, 'day') as rental_weekday, 
	date_part('hour',rental_date) as rental_hour,
	to_char(rental_date, 'month') as rental_month,
	date_part('year',rental_date) as rental_year,
	date_part('day',rental_date) as rental_day
FROM rental_details;

SELECT *,
	case when rental_hour < 12 then 'morning'
		when rental_hour >= 12 and rental_hour < 17 then 'afternoon'
		when rental_hour >= 17 and rental_hour < 20 then 'evening'
		else 'late night'
		end as rental_time_of_day,
	overdue_fine_total / (case when num_days_overdue = 0 then 1 else num_days_overdue end) as overdue_fine_per_day
FROM 	(SELECT *, 
	return_date - rental_date as num_days_rented,
	extract(day from return_date - rental_date) - rental_duration as num_days_overdue,
	(amount_paid - rental_rate) as overdue_fine_total,
	round(amount_paid / rental_duration, 2) as rental_rate_per_day,
	to_char(rental_date, 'day') as rental_weekday, 
	date_part('hour',rental_date) as rental_hour,
	to_char(rental_date, 'month') as rental_month,
	date_part('year',rental_date) as rental_year,
	date_part('day',rental_date) as rental_day
FROM rental_details) as fd;

/*Exercise2*/

DROP VIEW IF EXISTS rental_details_2;
CREATE VIEW rental_details_2 AS
SELECT *,
	case when rental_hour < 12 then 'morning'
		when rental_hour < 17 then 'afternoon'
		when rental_hour < 20 then 'evening'
		else 'late night'
		end as rental_time_of_day,
	overdue_fine_total / (case when num_days_overdue = 0 then 1 else num_days_overdue end) as overdue_fine_per_day
FROM 	(
	SELECT *,
		return_date - rental_date as num_days_rented,
		extract(day from return_date - rental_date) -  rental_duration as num_days_overdue,
		amount_paid - rental_rate as overdue_fine_total,
		round(rental_rate / rental_duration, 2) as rental_rate_per_day,
		to_char(rental_date, 'day') as rental_weekday, 
		date_part('hour',rental_date) as rental_hour,
		to_char(rental_date, 'month') as rental_month,
		date_part('year',rental_date) as rental_year,
		date_part('day',rental_date) as rental_day
	FROM rental_details 
	) as fd;

select * from rental_details_2;