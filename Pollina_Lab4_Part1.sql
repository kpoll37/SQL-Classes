--Exercise #1
select o.*,
    p."ProductName",
	p."UnitPrice" as MSRP,
	s."CompanyName" as supplier,
	c."CategoryName",
    (o."UnitPrice" * o."Quantity") as sub_total,
    (p."UnitPrice" - o."UnitPrice") as unit_discount,
    ((p."UnitPrice" - o."UnitPrice")/(p."UnitPrice")) as percent_discount
from order_details as o
join products as p on o."ProductID" = p."ProductID"
join suppliers as s on p."SupplierID" = s."SupplierID"
join categories as c on p."CategoryID" = c."CategoryID";

drop view if exists order_details_joined;
create view order_details_joined as
select o.*,
    p."ProductName",
	p."UnitPrice" as MSRP,
	s."CompanyName" as supplier,
	c."CategoryName",
    (o."UnitPrice" * o."Quantity") as sub_total,
    (p."UnitPrice" - o."UnitPrice") as unit_discount,
    ((p."UnitPrice" - o."UnitPrice")/(p."UnitPrice")) as percent_discount
from order_details as o
join products as p on o."ProductID" = p."ProductID"
join suppliers as s on p."SupplierID" = s."SupplierID"
join categories as c on p."CategoryID" = c."CategoryID";

select * from order_details_joined;

--Exercise 2

drop view if exists orders_joined;
create view orders_joined as
select o."OrderID", o."OrderDate", o."ShippedDate", o."Freight",
    v.order_total,
    s."CompanyName" as shipper,
    e."FirstName" || ' ' || e."LastName" as employee,
    c."CompanyName" as customer,
    (o."ShippedDate" - o."OrderDate") as days_to_ship,
    (order_total + o."Freight") as order_plus_freight
from orders as o
join(
    select "OrderID", sum(sub_total) as order_total
    from order_details_joined
    group by "OrderID"
    ) as v on o."OrderID" = v."OrderID"
join shippers as s on o."ShipVia" = s."ShipperID"
join employees as e on o."EmployeeID" = e."EmployeeID"
join customers as c on o."CustomerID" = c."CustomerID"
order by "OrderID";

select * from orders_joined;
