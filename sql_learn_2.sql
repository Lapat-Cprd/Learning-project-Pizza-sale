create table pizza_sale (
	pizza_id int primary key,
	order_id int,
	pizza_name_id varchar(20),
	quantity	int,
	order_date	varchar(20),
	order_time	time,
	unit_price	float,
	total_price	float,
	pizza_size	varchar(5),
	pizza_category	varchar(15),
	pizza_ingredients	varchar(100),
	pizza_name	varchar(50)
);
--
update pizza_sale
set order_date=to_date(order_date,'DD-MM-YYYY');
--
ALTER TABLE pizza_sale
ALTER COLUMN pizza_size TYPE varchar(15);
--
ALTER TABLE pizza_sale
ALTER COLUMN order_date TYPE date;
--
UPDATE pizza_sale
SET pizza_size = CASE
    WHEN pizza_size = 'S' THEN 'Regular'
    WHEN pizza_size = 'M' THEN 'Medium'
    WHEN pizza_size = 'L' THEN 'Large'
    WHEN pizza_size = 'XL' THEN 'X-Large'
    WHEN pizza_size = 'XXL' THEN 'XX-Large'
    ELSE pizza_size
END;
--
ALTER TABLE pizza_sale
ADD COLUMN order_day_name TEXT;
--
update pizza_sale
set order_day_name = to_char(order_date, 'Dy');
--set order_day_name = to_char(order_date, 'FMDay'); จะได้เป็นmonday,thusday,..
ALTER TABLE pizza_sale 
ADD COLUMN order_day_number INT;
--
ALTER TABLE pizza_sale  
ADD COLUMN order_month_number INT,
ADD COLUMN order_month_name VARCHAR(15);
--
ALTER TABLE pizza_sale  
ADD COLUMN order_month_number INT

--
UPDATE pizza_sale
SET order_month_name = to_char(order_date, 'FMMon'),
    order_month_number = EXTRACT(MONTH FROM order_date);
--
select * from pizza_sale;
--KPI Requirement
--1.Total Revenue
select 
	sum(total_price) as total_revenue 
from pizza_sale;
--2.Average order value
select
	sum(total_price)/count(distinct order_id) as average_order_value
from pizza_sale;
--3.Total pizza sole
select
	sum(quantity) as total_pizza_asles
from pizza_sale;
--4.total_orders
select
	count(distinct order_id) as total_orders
from pizza_sale;
--5.average pizza per order
select
	cast(count(quantity) as decimal(10,2)) /
	cast (count(distinct order_id) 
	as decimal(10,2)) as avg_pizzas_per_order
from pizza_sale;

--chart requirement
--1.daily trend for total order
select 
	EXTRACT(dow FROM order_date) AS dow,
	to_char(order_date, 'FMDay') as order_day,
	count(distinct order_id) as total_order
from pizza_sale
group by 1,2 
order by 1;
--2.monthly trend for total order
select 
	EXTRACT(MONTH FROM order_date) AS moy,
	to_char(order_date, 'FMMonth') as order_Month,
	count(distinct order_id) as total_order
from pizza_sale
group by 1,2 
order by 1;
--3.percentage of sales by pizza category
select 
	pizza_category,
	cast (sum(total_price)as decimal(10,2)) as total_sale,
	cast (sum(total_price)*100 / (select sum(total_price) from pizza_sale)as decimal(10,2))as PCT
from pizza_sale
--where EXTRACT(MONTH FROM order_date)=EXTRACT(MONTH FROM current_date)-1
group by 1;
--4.percentage of sales by pizza size
select 
	pizza_size,
	cast (sum(total_price) as decimal(10,2)) as total_sale,
	cast (sum(total_price)*100 / (select sum(total_price) from pizza_sale where EXTRACT(QUARTER FROM order_date)=1)as decimal(10,2))as PCT
from pizza_sale
where EXTRACT(QUARTER FROM order_date)=1
group by 1 
order by PCT desc;
--where EXTRACT(MONTH FROM order_date)=EXTRACT(MONTH FROM current_date)-1
--6.Top 5 Best Seller by revenue, total quantity and total orders
select 
	pizza_name,
	cast (sum(Total_price)as decimal(10,2))as total_revenue,
	sum(quantity)as total_quantity,
	count(order_id)as total_order
from pizza_sale
group by 1
order by 2 desc
limit 5 ;
--7.Bottom 5 Best Seller by revenue, total quantity and total orders
select 
	pizza_name,
	cast (sum(Total_price)as decimal(10,2))as total_revenue,
	sum(quantity)as total_quantity,
	count(order_id)as total_order
from pizza_sale
group by 1
order by 2 asc
limit 5 ;
--
select order_month_name ,
    order_month_number
from pizza_sale
group by 1,2;

