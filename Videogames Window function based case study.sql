

-- Practicing the exists questions .


--> question 1 -> 1. Find All Games Released in the Same Year as "Cyberpunk 2077"
select * from videogames limit 10;
-- same date 
select * from videogames where release_date  in(select release_date  from videogames where title = 'Cyberpunk 2077');

-- for same year 



select v1.* from videogames v1 join videogames v2 
on extract(year from v1.release_date) = extract(year from v2.release_date)
where v2.title = 'Cyberpunk 2077';


--> question 2 -> Find Games on the Same Platform as "Doom Eternal"

select * from videogames where platform in (select platform from videogames where title ='Doom Eternal' );  // based on subquery 

--> different approach to solve the problem using joins on the same table 

select * from videogames v where exists 
(select 1 from videogames v2 join videogames v on v2.platform = v.platform and v2.title = 'Doom Eternal') 





--> question 3 -> Write a SQL query to find the top 3 best-selling games in each genre, along with their sales rank within their genre.

--> filter query to divide the dataset based on the genre 
select * , rank() over(partition by genre order by sales desc) from videogames ; 	

--> finding the top three games for each genre  ?

select * from (select * , rank() over(partition by genre order by sales desc) as gamerank from videogames  ) m
where m.gamerank <4 
order by m.gamerank , genre ;


---> question - 4 -> Write a SQL query to rank games within each platform based on their sales, showing the top 3 games per platform.

ranking based on the sales 
select *,rank() over(partition by platform order by sales desc ) as sales  from videogames ;

-- finding the top 3 games in this one . 







