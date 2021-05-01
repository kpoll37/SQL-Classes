DROP TABLE IF EXISTS trips;

CREATE TABLE trips (truck_number integer, order_number integer, origin_id integer, origin_state char(2), ship_date timestamp,
    dest_id integer, dest_state char(2), arrive_date timestamp, mile_type char(6), miles integer);
COPY trips FROM 'C:\Users\stoli\Documents\BAS 240 NOT One Drive\trucking_data.csv' DELIMITER ',' CSV HEADER;

select * from trips;

Drop view if exists trips2;
Create view trips2 as

(Select *,
	  lag(truck_number,1) over (partition by truck_number order by ship_date) as prev_truck_number,
	  lag(arrive_date, 1) over () as prev_arrive_date,
	  lag(dest_id, 1) over() as prev_dest_id,
	  lag(mile_type,1) over() as prev_mile_type,
	  lag(miles, 1) over() as prev_miles,
	  lead(truck_number,1) over (partition by truck_number order by truck_number) as next_truck_number,
	  lead(ship_date, 1) over () as next_ship_date,
	  lead(origin_id, 1) over() as next_origin_id,
	  lead(mile_type,1) over() as next_mile_type,
	  lead(miles, 1) over() as next_miles
from trips);

select * from trips2;

--exercise2
drop view if exists trips3;
create view trips3 as
( select truck_number, order_number, origin_state, origin_id, dest_id, dest_state, ship_date,
arrive_date, mile_type, miles,  prev_miles as inc_miles, next_miles as out_miles, next_truck_number, next_ship_date, next_origin_id
from trips2
where truck_number = prev_truck_number and
ship_date = prev_arrive_date and
origin_id = prev_dest_id and
mile_type = 'Loaded' AND
prev_mile_type = 'Empty' AND

truck_number = next_truck_number and
arrive_date = next_ship_date and
dest_id = next_origin_id  and
next_mile_type = 'Empty');

select * from trips3;

--Exercise 2, #3a
select distinct(origin_id, dest_id), origin_id, dest_id,
arrive_date, mile_type, miles, inc_miles, out_miles, 
Round(AVG(inc_miles + out_miles), 4) as empty_miles
from trips3
group by truck_number, order_number, origin_id, origin_state, 
dest_id, dest_state, arrive_date, mile_type, miles, inc_miles, out_miles
order by Round(AVG(inc_miles + out_miles), 4) desc;


--Exercise 2, 3b
select distinct origin_id, count(origin_id), Round(avg(inc_miles),4) as avg_inc_miles from trips3
group by origin_id
		having Count(origin_id) > 5
order by Round(avg(inc_miles),4) desc limit 5;

--Excercise 2, 3c
select distinct dest_id, count(dest_id), Round(avg(out_miles),4) as avg_out_miles from trips3
group by dest_id
		having Count(dest_id) > 5
order by Round(avg(out_miles),4) desc limit 5;


/* worked but not needed...select distinct(sub.origin_id, sub.dest_id2), sub.origin_id, sub.dest_id2, sub.empty_miles  
from(
select origin_id, dest_id2, dest_state,  
origin_state, arrive_date2, mile_type, miles, inc_miles, out_miles, 
Round(AVG(inc_miles + out_miles), 4) as empty_miles
from trips3 
group by origin_id, origin_state, 
dest_id2, dest_state, arrive_date2, mile_type, miles, inc_miles, out_miles
) as sub
order by empty_miles desc;*/

/* Exercise 2
with trips2 as 

(select truck_number, origin_id, dest_id, ship_date,
arrive_date, mile_type, miles, inc_miles, out_miles, row_num, prev_row_num 
from (select truck_number, origin_id, dest_id, ship_date,
arrive_date, mile_type, miles, prev_miles as inc_miles, next_miles as out_miles,
row_number() over () as row_num,
row_number() over () -1 as prev_row_num
from
(select * from trips2 as a
where a.mile_type= 'Loaded' and a.prev_mile_type='Empty' 
and a.next_mile_type='Empty') as sub) as foo) 


Select a.truck_number, a.origin_id, a.dest_id, a.ship_date,
a.arrive_date, a.mile_type, a.miles, a.inc_miles, a.out_miles
from trips2 as a
join trips2 as b on a.row_num=b.prev_row_num*/

/* drop view if exists trips3;
create view trips3 as
(select truck_number, order_number, origin_state, origin_id, dest_id2, dest_id, dest_state, ship_date, arrive_date2,
arrive_date, mile_type, miles, inc_miles, out_miles 
from (select truck_number, order_number, origin_state, origin_id, dest_id, dest_state, ship_date,
arrive_date, mile_type, miles, prev_miles as inc_miles, next_miles as out_miles,
lead(ship_date, 1) over(partition by truck_number) as arrive_date2,
lead(origin_id, 1) over(partition by truck_number) as dest_id2
from
(select * from trips2 as a
where a.mile_type= 'Loaded' and a.prev_mile_type='Empty' 
and a.next_mile_type='Empty') as sub) as foo); */