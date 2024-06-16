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


-- note : most common item based on each customer , mtlb kaun sha jada khata hai
-- customer segment karna hai , most consumed item list , remove repeatives / less values 

with all_cust as 
(select customer_id , product_id , count(product_id) as order_count from sales group by customer_id
,product_id )

select customer_id , product_name 
from
(select c.customer_id , m.product_name , dense_rank() over(partition by customer_id order by order_count desc) 
 as rank from all_cust c
 join menu m using(product_id)) as fav WHERE rank = 1;
 
 --*****************************
 
 
 -- question 6 -> Which item was purchased first by the customer after they became a member?
 
select * from sales ; 
select * from members;
select * from menu ;


--> logic
-- customers ka date shay relation fhir product id shay join karke product_name nikal sakte hai 

WITH after_join AS (
    SELECT s.customer_id
        , m.product_name
        , DENSE_RANK() OVER(PARTITION BY s.customer_id ORDER BY s.order_date) AS first
    FROM sales s
    JOIN members mm ON s.customer_id = mm.customer_id
    JOIN menu m ON s.product_id = m.product_id
    WHERE s.order_date >= mm.join_date
)

SELECT customer_id
    , product_name
FROM after_join
WHERE first = 1;


-- 7. Which item was purchased just before the customer became a member?

WITH last_order_member AS (
    SELECT s.customer_id
        , m.product_name
        , DENSE_RANK() OVER(PARTITION BY s.customer_id ORDER BY s.order_date) AS last
    FROM sales s
    JOIN members mm ON s.customer_id = mm.customer_id
    JOIN menu m ON s.product_id = m.product_id
    WHERE s.order_date >= mm.join_date
)

SELECT customer_id
    , product_name
FROM last_order_member
WHERE last = 1;


-- 8. What is the total items and amount spent for each member before they became a member?

select * from sales ; 
select * from members;
select * from menu ;

-- order date is less then the joining date baki sum price total karke solve kar sakte hai

select s.customer_id , sum(m.price) as total_spend from sales s join menu m on
s.product_id = m.product_id 
join members mem on 
s.customer_id = mem.customer_id
where s.order_date < mem.join_date
group by s.customer_id order by s.customer_id;



--9 If each $1 spent equates to 10 points and sushi 
-- has a 2x points multiplier - how many points would each customer have?


select * from sales ; 
select * from members;
select * from menu ;

-- logic 
--> price attribute ka main role hai , ushme hum sushmi mai 20 ka multiply or baki mai 10 ka multiply
--> kar detay hai and simple three tables ko join kar detay hai then it will solve .


SELECT DISTINCT
    s.customer_id,
    SUM(CASE WHEN m.product_name = 'sushi' THEN 20 * m.price ELSE 10 * m.price END) OVER (PARTITION BY s.customer_id order by s.customer_id desc)  AS total_points
FROM
    sales s
    LEFT JOIN menu m ON m.product_id = s.product_id
    LEFT JOIN members mem ON mem.customer_id = s.customer_id;
 


-- solving using group by by removing the window function 

SELECT s.customer_id,  
    SUM(CASE WHEN order_date BETWEEN join_date AND DATE(join_date,'+6 Days') OR product_name = 'sushi' THEN 20 * price ELSE 10 * Price END) AS points     
    FROM sales s
    INNER JOIN members mem
    ON mem.customer_id = s.customer_id
    INNER JOIN menu m
    ON m.product_id = s.product_id
    WHERE order_date <= '2021-01-31'
    GROUP BY s.customer_id; 
	
	
	
	
	
	
-- 10 correct this query and its syntax

-- In the first week after a customer joins the program (including their join date) 
--they earn 2x points on all items, not just sushi 
-- how many points do customer A and B have at the end of January?
 
select * from sales ; 
select * from members;
select * from menu ; 


-- logic --> ishme 1 week ko include karke hum * 20 kar sakte hai har point par
-- sath mai else condition mai sushi item ko bhi include kar sakte hai 
-- writing the logical code for this one 

-- getting details of product sales in January 
select s.order_date ,s.customer_id , s.product_id from sales s  where order_date <= '2021-01-31'
group by s.customer_id, s.order_date ,s.product_id ;


--> getting the product details using this query .

select s.order_date ,s.customer_id , s.product_id , m.product_name from sales s join  menu m 
on m.product_id = s.product_id 
where order_date <= '2021-01-31'
group by s.customer_id, s.order_date ,s.product_id,m.product_name ;

-- case logic that we can used 
/* SUM(
        CASE 
            WHEN s.order_date BETWEEN mem.join_date AND mem.join_date + INTERVAL '6 days'
                 THEN 20 * m.price 
            WHEN m.product_name = 'sushi' 
                 THEN 20 * m.price 
            ELSE 10 * m.price 
        END
    ) AS points 
	*/ 
	
 
--> solving the main query to get the results 

select s.customer_id 
, SUM(
        CASE 
            WHEN s.order_date BETWEEN mem.join_date AND mem.join_date + INTERVAL '6 days'
                 THEN 20 * m.price 
            WHEN m.product_name = 'sushi' 
                 THEN 20 * m.price 
            ELSE 10 * m.price 
        END
    ) AS points 
from sales s join menu m 
on s.product_id = m.product_id
join members mem
on  s.customer_id = mem.customer_id 
group by s.customer_id ; 







 
 
 
 
 
 


























