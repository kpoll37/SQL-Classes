--1.	Which customer (name):
--a.	Spent the most money?
select customer_name, sum(amount_paid) as total_amount
from rental_details_2
group by customer_name
order by sum(amount_paid) desc;

--b.	Had the most rentals?
select customer_name, count(*) 
from rental_details_2
group by customer_name
order by count desc;

--c.	Had the most in overdue fines?
select customer_name, sum(overdue_fine_total) as Total_Fines
from rental_details_2
group by customer_name
order by sum(overdue_fine_total) desc;

--d.	Rented the most comedy movies?
select category_name
from rental_details_2
group by category_name;

select customer_name, count(*) as Comedies
from rental_details_2
where category_name = 'Comedy'
group by customer_name
order by Comedies desc,customer_name desc;

--e.	Had the most rentals in June 2005?
select customer_name, rental_month, count(*) as June_Rentals
from rental_details_2
where trim(rental_month) = 'june'
group by 1,2
order by 3 desc, 1 ;

--f.	Had the highest average number of days rented?
select customer_name, avg(num_days_rented) as Average_Rental_Days
from rental_details_2
group by 1
order by 2 desc, 1 ;

--g.	Had the highest average movie length?
select customer_name, round(avg(length),2) as movie_length
from rental_details_2
group by 1
order by 2 desc, 1;

--2.	Which movie (name):
--a.	Had the most rentals?
select title, count(*)
from rental_details_2
group by title
order by count desc;

--b.	Made the most money?
select title, 
sum(amount_paid) as Money_made
from rental_details_2
group by title
order by 2 desc;

--c.	Had the most in overdue fines?
select title, sum(overdue_fine_total) as overdue_fines
from rental_details_2
group by title
order by 2 desc;

--d.	Had the highest average number of days rented?
select title, avg(num_days_rented) as AVG_Days_Rented
from rental_details_2
group by title
order by 2 desc;

--e.	Had the highest average movie length?
select title, round(avg(length),2) as movie_length
from rental_details_2
group by 1
order by 2 desc, 1;

--3.	Categories and Ratings
--a.	How many G rated movies are classified as Horror films?

select category_name, rating, count(distinct title)
from rental_details_2
where category_name = 'Horror' and rating = 'G'
group by category_name, rating
order by rating;
--b.	Which rating/category combo had the most rentals and made the most money?
select category_name, rating, count(*),
sum(amount_paid) as Money_made
from rental_details_2
group by category_name, rating
order by 3 desc,count desc;
--c.	Which rating/category combo had the highest average movie length?
select category_name, rating,
round(avg(length),2) as movie_length
from rental_details_2
group by category_name, rating
order by 3 desc;

--4.	Time of Day
--a.	What are the busiest times of day?
Select rental_time_of_day, count(*)
from rental_details_2
Group by rental_time_of_day
order by count desc;
