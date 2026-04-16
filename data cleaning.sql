-- DATA CLEANING

select *
from layoffs;


create table new_data1
like layoffs;

select * 
from new_data1;

Insert new_data1
select *
from layoffs;

select  *,
row_number() over
( partition by industry, total_laid_off, percentage_laid_off, `date`) as row_num
from new_data1;

with duplicate_cte as 
(
select  *,
row_number() over
( partition by company, location, stage, country, funds_raised_millions, industry, total_laid_off, percentage_laid_off, `date`) as row_num
from new_data1
)
select *
from duplicate_cte
where row_num > 1;

select *
from new_data1
where company = 'Oda';

 CREATE TABLE `new_data2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

select * 
from new_data2;

insert into new_data2
select  *,
row_number() over
( partition by 
company, location, stage, country, funds_raised_millions, industry, total_laid_off, percentage_laid_off, `date`) as row_num
from new_data1;

delete 
from new_data2
where row_num > 1;

select *
from new_data2
where row_num > 1;

-- standardizing data


select company, trim(company)
from new_data2;

update new_data2
set company = trim(company);

select distinct industry
from new_data2
where industry like 'crypto%' ;

update  new_data2
set industry = 'crypto'
where industry like 'crypto%';

select distinct country
from new_data2
order by 1 ;

update new_data2
set country = 'United States'
where country like 'United States%'
;

select *
from new_data2;

update new_data2
set country = trim(country);

select `date`
from new_data2;

update new_data2
set `date` = str_to_date(`date`, '%m/%d/%Y')
;

alter table new_data2
modify column `date` date;

select *  
from new_data2
where total_laid_off is null
and percentage_laid_off is null;

update new_data2
set industry = null
where industry = '';

select *
from new_data2
where company = 'Airbnb';

select   t1.industry, t2.industry
from new_data2 t1
join new_data2 t2
 on t1.company = t2.company
where (t1.industry is null or t1.industry = '')
and t2.industry is not null;

update new_data2 t1
join new_data2 t2
   on t1.company = t2.company
set t1.industry = t2.industry
where t1.industry is null
and t2.industry is not null;

select * 
from new_data2
where industry is null
or industry = '';


delete  
from new_data2
where total_laid_off is null
and percentage_laid_off is null;


select *
from new_data2;

alter table new_data2
drop column row_num;

 