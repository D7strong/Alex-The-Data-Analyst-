-- Data Cleaning


select *
From layoffs
;

-- To Do List
-- 	Remove dulpicates
-- 	Standardize the Data
-- 	Null Values
-- 	Remove any Columns

Create Table layoffs_staging
Like layoffs
;

select *
From layoffs_staging
;

-- Separete Table to not work off raw data
-- will work of staging database going forward
Insert layoffs_staging
Select *
From layoffs;


-- Removing Dulpicates

-- 1. assiging duplicates id number
select *,
row_number() over(
Partition by company, industry, total_laid_off, percentage_laid_off, 'date') as row_num-- Date is a key work in mysq so uses''
From layoffs_staging
;

-- 2. Identifying Duplicates
with duplicate_CTE as
(
select *,
row_number() over(
Partition by company, location, industry, total_laid_off, percentage_laid_off, 
'date', stage, country, funds_raised_millions) as row_num
From layoffs_staging
)
select *
from duplicate_CTE
where row_num > 1
;

select *
from layoffs_staging
where company = 'Casper'
;

-- 3. Deleting Duplicates

with duplicate_CTE as
(
select *,
row_number() over(
Partition by company, location, industry, total_laid_off, percentage_laid_off, 
'date', stage, country, funds_raised_millions) as row_num
From layoffs_staging
)
select *
from duplicate_CTE
where row_num > 1
;

-- Creates another table
CREATE TABLE `layoffs_staging2` ( 
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL, 
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Called the duplicates to appear
select *
from layoffs_staging2 
where row_num > 1
;

insert into layoffs_staging2
select *,
row_number() over(
partition by company, location, industry, total_laid_off, percentage_laid_off, 
'date', stage, country, funds_raised_millions) as row_num
From layoffs_staging
;

-- Deletes duplicates
Delete
from layoffs_staging2
where row_num > 1
;

select *
from layoffs_staging2
;

-- Standardizind Data

select *
from layoffs_staging2
;

Update layoffs_staging2
set company =  trim(company)
;

select Distinct industry
from layoffs_staging2
order by 1
;

select distinct industry
from layoffs_stage2
;

update layoffs_staging2
set industry = 'Crypto'
where industry like 'Crypto%'
;

select distinct country, Trim(trailing '.' from country)
from layoffs_staging2
order by 1
;

update layoffs_staging2
set country = Trim(trailing '.' from country)
where country like 'United Stated%'
;

select `date`
From layoffs_staging2;

update layoffs_staging2
set `date` = str_to_date(`date`, '%m/%d/%Y')
;

Alter Table layoffs_staging2
modify column `date` date
;

select *
from layoffs_staging2;

-- NULL AND BLANK VALUES

select *
from layoffs_staging2
where total_laid_off is null
and percentage_laid_off is null;

-- Setting Blanks to Null
update layoffs_staging2
set industry = null
where industry = ''
;

select *
from layoffs_staging2
where industry is null
or industry = '';

select *
from layoffs_staging2
where company Like 'Bally%'
;

-- fills in the null with the matching filled companies
select *
From layoffs_staging2 as t1
join layoffs_staging2 as t2
	on t1.company = t2.company
where (t1.industry is null or t1.industry = '')
and t2.industry is not null
;

update layoffs_staging2 t1
join layoffs_staging2 as t2
	on t1.company = t2.company
set t1.industry = t2.industry
where t1.industry is null
and t2.industry is not null
;

select *
from layoffs_staging2
;

-- Remove Columns and Rows
select *
from layoffs_staging2
where total_laid_off is null
and percentage_laid_off is null;

Delete
from layoffs_staging2
where total_laid_off is null
and percentage_laid_off is null;

select *
from layoffs_staging2;

-- Finish

Alter Table layoffs_staging2
drop column row_num;