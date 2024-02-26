select * from AppleStore
------EDA
Select Count(Distinct id) as Unique_App
from AppleStore

--missing  values  from the whole data 
select count(*) null_values from AppleStore
where track_name is null OR user_rating is null OR prime_genre is null 


---- basic analysis 
select count(*) no_of_apps,prime_genre 
from AppleStore
group by prime_genre
order by count(*) desc


-------------insight(everything is  focoused on the user rating so it derive the  required result) 

---which app  has more rating #1
with cte as (select *,
Case when price>0 then 'paid' 
else 'free' 
end as app_type
from AppleStore)
select app_type,Round(AVG(user_rating),2) as ratings from cte
group by app_type

------------#2 analysis upon the language 

with lang_base as (select *,
case 
when lang_num<10 then '<10 language'
when lang_num between 10 and 30 then '10-30 language'
else '>30 language'
end  as lang_bin
from AppleStore
)

select  lang_bin,Round(avg(user_rating),2) rating_lang_wise from lang_base
group by lang_bin


----------#  top 10 and lower 10 genre  things 
---top 10
select TOP 10 prime_genre,Round(AVG(user_rating),2) avg_rating from AppleStore
group by prime_genre
order by AVG(user_rating)  desc
--bottom 10
select TOP 10 prime_genre,Round(AVG(user_rating),2) avg_rating from AppleStore
group by prime_genre
order by AVG(user_rating)  

---- now top app  name in  each genre 

with rating_cte as ( select * ,
rank()over(partition by prime_genre order by user_rating desc,rating_count_tot desc ) rn from 
AppleStore)

select prime_genre,user_rating,track_name from rating_cte
where rn=1
