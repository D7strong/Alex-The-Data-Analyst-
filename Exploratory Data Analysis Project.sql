-- Exploratory Data Analysis

Select *
From layoffs_staging2;


Select Max(total_laid_off),max(percentage_laid_off)
From layoffs_staging2;

Select *
From layoffs_staging2
where percentage_laid_off = 1
order by funds_raised_millions DESC;

Select company, sum(total_laid_off)
From layoffs_staging2
group by company
order by 2 desc;

Select min(`date`), max(`date`)
from layoffs_staging2;

-- Amount of layoffs per country
Select country, sum(total_laid_off)
From layoffs_staging2
group by country
order by 2 desc;

-- Stage of Company
Select *
From layoffs_staging2;

Select stage, sum(total_laid_off)
From layoffs_staging2
group by stage
order by 1 desc;

Select country, Avg(percentage_laid_off )
From layoffs_staging2
group by country
order by 2 desc;

select substr(`date`,1,7) as `month`, sum(total_laid_off)
from layoffs_staging2
where substr(`date`,1,7) is not null
group by `month`
order by 1 asc
;


with rolling_total as
(
select substr(`date`,1,7) as `month`, sum(total_laid_off) as total_off
from layoffs_staging2
where substr(`date`,1,7) is not null
group by `month`
order by 1 asc
)

select `month`, total_off,
 sum(total_off) over(order by`month`) as rolling_total
from rolling_total
;



-- Looking at The Company(Hardest One)
Select country, sum(total_laid_off)
From layoffs_staging2
group by country
order by 2 desc;

Select company, YEAR(`date`), sum(total_laid_off)
From layoffs_staging2
group by company, Year(`date`)
order by 3 DESC
;


With company_year (company,years,total_laid_off) as
(
Select company, YEAR(`date`), sum(total_laid_off)
From layoffs_staging2
group by company, Year(`date`)
), Company_Year_Rank AS
(select *,Dense_Rank() Over (Partition BY  years order by total_laid_off DESC) as ranking
from company_year
where years is not null
)
select*
From company_year_rank
where ranking <= 5;
;