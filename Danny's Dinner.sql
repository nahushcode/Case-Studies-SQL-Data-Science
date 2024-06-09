--- Case studies Danny's Dinner 
-- tables : sales ,members ,menu
select * from sales ; 
select * from members;
select * from menu ;



-- What is the total amount each customer spent at the restaurant?
-- amount details of each customers 
-- resturnant details and relation with customer 
-- relation : sales 

select s.customer_id ,sum(m.price) as total from sales s join menu m 
on s.product_id = m.product_id group by s.customer_id ;


-- Find what orders are consumed by the customer_id A , name andl ist all of these products ? 

select m.product_name ,s.customer_id from sales s join menu m 
on s.product_id = m.product_id 
where s.customer_id = 'A' group by m.product_name,s.customer_id ;


--How many days has each customer visited the restaurant?

-- logic: sales table mai shay order date ka sum nikal lo , 


select customer_id , count(distinct(order_date)) from sales group by customer_id ;



-- What was the first item from the menu purchased by each customer?

select * from sales ; 
select * from members;
select * from menu ;

-- logic --> based on date we can find out the first product that have been sold during the time 



select s.customer_id , s.product_id ,m.product_name  from sales s join menu m on
m.product_id = s.product_id where s.order_date in 
(select min(order_date) from sales group by customer_id) ;


-- 4. What is the most purchased item on the menu and how many times was it purchased by all customers?

select max(product_count) as max_purchased_item , m.product_name
from
(select s.product_id , count(product_id) as product_count from sales s group by s.product_id) k
JOIN menu m ON k.product_id = m.product_id
WHERE k.product_count = (select max(product_count) from (select s.product_id , count(product_id) as product_count 
					 from sales s group by s.product_id)A2) -- rule ki bajah shay alias lagana padha 
group by m.product_name;


-- 5. Which item was the most popular for each customer?
--  Important question to solve 

select * from sales ; 
select * from members;
select * from menu ;


select customer_id , s.product_id ,m.product_name, count(s.product_id) as product_unit_consumed 
from sales s join menu m on m.product_id = s.product_id  
group by customer_id,s.product_id,m.product_name ;


-- note : most common item based on each customer , mtlb kaun sha jada khata hai
-- customer segment karna hai , most consumed item list , remove repeatives / less values 







 
 
 
 
 
 


























