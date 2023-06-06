/* Queries used for Tableau proj */

--1. Global numbers: Total Cases, Total deaths, Percent Chance of dying if you contract Covid
select Sum(new_cases) as total_cases, sum(new_deaths) as total_deaths, sum(total_deaths)/sum(total_cases)*100 as deathpercentage
 from PortfolioProject..coviddeathdata1
 where continent is not NULL
 --group by date
order by 1,2

--2. Total deaths per continent
select location, Max(cast(total_deaths as int)) as totalDeathCount
from PortfolioProject..coviddeathdata1
where continent is NULL
 and location not in ('World', 'European Union', 'International', 'High Income', 'Upper middle income', 'Lower middle income','Low income')
Group by location
order by TotalDeathCount desc

--3. Percent of pop. infected per country
select Location, population, Max(total_cases) as HighestInfectionCount, Max((total_cases/population))*100 as PercentPopulationInfected
from PortfolioProject..coviddeathdata1
Group by Location,population
order by PercentpopulationInfected desc

--4. Percent of population infected per country and over time
select Location, population, date, Max(total_cases) as HighestInfectionCount, Max((total_cases/population))*100 as PercentPopulationInfected
from PortfolioProject..coviddeathdata1
Group by Location,population, date
order by PercentpopulationInfected desc