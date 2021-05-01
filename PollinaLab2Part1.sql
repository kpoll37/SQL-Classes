/* Exercise 1 Lab2 Part 1 */
/* select * from payment where payment_id = '17503'; */

select * from customer where customer_id = 341;

select * from staff where staff_id =2;

select * from rental where rental_id =1520;

/* Exercise 2 Lab2 Part 1 */

select customer_id, count(*) 
from payment group by customer_id
order by count(*) desc; 

select staff_id, count(*) 
from payment group by staff_id
order by count(*) desc;

select rental_id, count(*) 
from payment group by rental_id
order by count(*) desc;