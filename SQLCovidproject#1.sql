/*Covid-19 SQL Data Exploration Project */
 /* Project: This Covid-19 dataset was compiled by ourworldindata.org using the World Health Organization(WHO) Covid-19 data spanning from 1.3.2020-5.10.23 */
 /* Purpose: The motivation for this project was to explore the global death, infection, and vaccination rates during the COVID-19 pandemic 
     and to determine which countries were affected the most by the COVID-19 Pandemic */ 
 /* I analyzed countries by their total deaths, reported infections, total vaccinations, and population */
/* Programmer: Patrick Lutz */
/* Date: 9/19/23 */
/* Visualized on Tableau at: https://public.tableau.com/app/profile/patrick.lutz/viz/CovidDashboard1_16859910334760/Dashboard1
/* Skills Used: Joins, CTEs, Temp tables, Window Functions, Aggregate Functions, creating views, Converting data types */

/*In Excel I reformatted and split the original dataset into two separate datasets (coviddeathdata1, covidvacdata1) in order to avoid having to JOIN on every query */
/*run a query on both datasets to make sure they look right*/
select *
from PortfolioProject..coviddeathdata1
where continent is not null
order by 3,4


select *
from PortfolioProject..covidvacdata1
where continent is not null
order by 3,4


/* select the data that we are going to be using*/
select Location, date, total_cases, new_cases, total_deaths, population
from PortfolioProject..coviddeathdata1
-- Looking at my home country, United States
where continent is not null
and location like '%states%'
order by 1,2


/* Had trouble dividing datatype bigint by another bigint so I changed totaldeaths to a "Float"*/
ALTER TABLE PortfolioProject..coviddeathdata1
    ALTER COLUMN total_deaths FLOAT NULL;

/*Looking at total cases vs. Total Deaths*/
/*Shows likelihood of dying if you contract covid in the U.S.*/
select  Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from PortfolioProject..coviddeathdata1
-- Looking at my home country, United States
where location like '%states%'
and continent is not null
order by 1,2

--A person has a 1.09% chance of dying if they contract covid in the U.S. today not factoring in if they've been vaccinated or not
--The deathpercentage peaked at a 6.13% of dying if you contracted covid in the U.S. on 5.09.2020*/

 /*Create View of Death Percentage for Tableau visualization*/
Create VIEW DeathPercentage AS
select  Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from PortfolioProject..coviddeathdata1
-- Looking at my home country, United States
where location like '%states%'
and continent is not null



-- What was the percent chance of dying if you contracted covid in 2020 versus 2021 versus 2022? What about before vaccinations are available and after?
select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from PortfolioProject..coviddeathdata1
-- Looking at my home country, United States
where location like '%states%'
and date like '2020%'
and continent is not null
order by 1,2

--In 2020 , in the U.S. the final percent likelihood of dying from covid if contracted was a 1.8% chance of dying

select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from PortfolioProject..coviddeathdata1
-- Looking at my home country, United States
where location like '%states%'
and date like '2021%'
and continent is not null
order by 1,2
  
--In 2021, in the U.S. the percent chance of dying if you contract covid was 1.5%

select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from PortfolioProject..coviddeathdata1
-- Looking at my home country, United States
where location like '%states%'
and date like '2022%'
and continent is not null
order by 1,2

--In 2022, the percent likelihood of dying from covid if you contract it was 1.09 percent

--------------------------------------------------------------------------------------------------------------------------------------

--What's the total percent of the population killed from covid for each country? (i.e. population/total deaths*100)
-- 0.33% of population killed in the U.S.
select Location, date, total_cases, total_deaths, population, (total_deaths/population)*100 as Percentpopkilled
from PortfolioProject..coviddeathdata1
-- Looking at my home country, United States
where location like '%states%'
and continent is not null
order by 1,2

/*Create View of Percent of Population killed in the U.S.*/
Create View Percentpopkilled AS
select Location, date, total_cases, total_deaths, population, (total_deaths/population)*100 as Percentpopkilled
from PortfolioProject..coviddeathdata1
-- Looking at my home country, United States
where location like '%states%'
and continent is not null


--What the total percent population killed from covid in france? .24% of the population
select Location, date, total_cases, total_deaths, population, (total_deaths/population)*100 as Percentpopkilled
from PortfolioProject..coviddeathdata1
where location like 'France%'
and continent is not null
order by 1,2

--What the total percent population killed from covid in the United Kingdom? 0.33% of the population killed
select Location, date, total_cases, total_deaths, population, (total_deaths/population)*100 as Percentpopkilled
from PortfolioProject..coviddeathdata1
where location like '%kingdom%'
and continent is not null
order by 1,2


/* Had trouble dividing datatype bigint by another bigint so I changed population to a "Float"*/
ALTER TABLE PortfolioProject..coviddeathdata1
    ALTER COLUMN population FLOAT NULL;

/*looking at total cases vs. population*/
/*Shows what percent of the population infected from covid */
select Location, date, population, total_cases, (total_cases/population)*100 as PercentInfected
from PortfolioProject..coviddeathdata1
where location like '%states%'
and continent is not null
order by 1,2

/*30.5% of the population in the U.S. has contracted Covid*/

/*Create View of Percent infected from Covid*/
create view PercentpopInfected AS
select Location, date, population, total_cases, (total_cases/population)*100 as PercentInfected
from PortfolioProject..coviddeathdata1
where location like '%states%'
and continent is not null


/*Looking at countries with highest infection rate compared to population*/
select Location, population, Max(total_cases) as HighestInfectionCount, Max((total_cases/population))*100 as PercentPopulationInfected
from PortfolioProject..coviddeathdata1
Group by Location,population
order by PercentpopulationInfected desc

--the highest percentage of population infected seems to be in the mediterranean with small countries like The Republic of Cyprus and San Marino.
--The lowest percentage infected seems to be in the countries of Africa and the Middle East with countries like Chad and Niger and Yemen. 
--Although this could be a reporting issue. 

/*Create view of Countries with the highest infection rate*/
Create view CountriesHighestInfection as
select Location, population, Max(total_cases) as HighestInfectionCount, Max((total_cases/population))*100 as PercentPopulationInfected
from PortfolioProject..coviddeathdata1
Group by Location,population


/*SHowing Countries with Highest Death Count*/
--U.S.A has highest death count, followed by Brazil, India, Russia
select Location, Max(cast(total_deaths as int)) as totalDeathCount
from PortfolioProject..coviddeathdata1
where continent is not NULL
Group by Location
order by TotalDeathcount desc

/*Create View of Countries with the highest death count*/
Create view CountriesHighestdeathcount as
select Location, Max(cast(total_deaths as int)) as totalDeathCount
from PortfolioProject..coviddeathdata1
where continent is not NULL
Group by Location


--Look at total death count as a percent of population
--Peru has the largest percent of pop. killed from covid at .64 percent meaning almost 1% of Peru was killed from covid
select Location, Max((cast(total_deaths as int))/population)*100 as totalDeathpercent
from PortfolioProject..coviddeathdata1
where continent is not NULL
Group by Location
order by TotalDeathpercent desc

/*Create view of the total percent of population killed by country*/
create View TotalPercentpopKilled as 
select Location, Max((cast(total_deaths as int))/population)*100 as totalDeathpercent
from PortfolioProject..coviddeathdata1
where continent is not NULL
Group by Location


--Showing continents with highest death count--
select location, Max(cast(total_deaths as int)) as totalDeathCount
from PortfolioProject..coviddeathdata1
where continent is NULL
Group by location
order by TotalDeathCount desc

--Europe has highest death count with Asia, North America, and S. America right behind it

/*Create View of Continents with the highest death Count*/
Create View ContinentsHighestDeathCount as
select location, Max(cast(total_deaths as int)) as totalDeathCount
from PortfolioProject..coviddeathdata1
where continent is NULL
Group by location

--What the percent of the World killed from covid? 
--Which continents had the highest percentage of their population killed from covid? 
select location, population, Max(cast(total_deaths as int)) as totalDeathCount, Max((cast(total_deaths as int))/population)*100 as Worlddeathpercent
from PortfolioProject..coviddeathdata1
where continent is NULL
group by location, population
order by totaldeathcount desc

/*0.09% of the world killed from covid
Europe had 0.28% of their population killed from covid
Africa had the lowest percentage of their population killed from covid at 0.02% killed*/

/*Create View of the percent of pop killed from covid Globally*/
Create View Globalpercentpopkilled as
select location, population, Max(cast(total_deaths as int)) as totalDeathCount, Max((cast(total_deaths as int))/population)*100 as Worlddeathpercent
from PortfolioProject..coviddeathdata1
where continent is NULL
group by location, population


----------------------------------------------------------------------------------------


--Daily total cases, total deaths and percent chance of dying if infected--
select date, Sum(new_cases) as total_cases, sum(new_deaths) as total_deaths, sum(total_deaths)/sum(total_cases)*100 as Dailydeathpercentage
 from PortfolioProject..coviddeathdata1
 where continent is not NULL
 group by date
 order by 1,2

 /*Create view of Global daily Death percentage*/ 
 create view GlobalDailyDeathpercentage as
 select date, Sum(new_cases) as total_cases, sum(new_deaths) as total_deaths, sum(total_deaths)/sum(total_cases)*100 as Dailydeathpercentage
 from PortfolioProject..coviddeathdata1
 where continent is not NULL
 group by date
-------------------------------------------------------------
-- Global cumulative cases, Cumulative deaths and percent likelihood of dying if contracted --
select Sum(new_cases) as total_cases, sum(new_deaths) as total_deaths, sum(total_deaths)/sum(total_cases)*100 as Globaldeathpercentage
 from PortfolioProject..coviddeathdata1
 where continent is not NULL
 order by 1,2

--joining coviddeathdata1 dataset and covidvacdate1 dataset and looking at it--
select *
from PortfolioProject..coviddeathdata1 dea 
join PortfolioProject..covidvacdata1 vac 
On dea.location = vac.location 
and dea.date = vac.date 

--utilizing a rolling sum function to show us total vaccinations compared to the population--
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(convert(float, vac.new_vaccinations)) over (partition by dea.location order by dea.location,dea.date) as RollingPeoplevaccinated 
--, (Rollingpeoplevaccinated/population)*100 --> cant use column that you just created in a new column--
from PortfolioProject..coviddeathdata1 dea 
join PortfolioProject..covidvacdata1 vac 
On dea.location = vac.location 
and dea.date = vac.date 
where dea.continent is not NULL
and dea.location like '%States%'
order by 2,3

-- Pretty accurate except new vaccination includes multiple doses of vaccines. 
--Thus the # of "RollingpeopleVaccinated" actually exceeds the population of a country

--Use CTE to find the percent of the population vaccinated in the U.S.
With PopvsVac (Continent, Location, date, Population, New_vaccinations, RollingPeoplevaccinated)
AS
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(convert(bigint, vac.new_vaccinations)) over (partition by dea.location order by dea.location,dea.date) as RollingPeoplevaccinated 
--, (Rollingpeoplevaccinated/population)*100 --> cant use column that you just created in a new column--
from PortfolioProject..coviddeathdata1 dea 
join PortfolioProject..covidvacdata1 vac 
On dea.location = vac.location 
and dea.date = vac.date 
where dea.continent is not NULL
and dea.Location like '%States%'
)

Select * , (Rollingpeoplevaccinated/Population)*100 as Percentvaccinated
from PopvsVac
order by 2,3

--Again, accurate except that the columnn New_Vaccinations includes multiple doses of vaccines. 
--Thus the percent vaccinated in the U.S. as of 5.10.23 is over 200%

-- Temp Table
--Just using a different method to look at the percentage of the population vaccinated by date in the U.S.
Drop Table if exists #percentpopulationVaccinated
Create Table #PercentPopulationVaccinated 
(
    Continent nvarchar(255),
    Location nvarchar(255),
    Date datetime,
    Population numeric,
    New_vaccinations numeric,
    RollingPeopleVaccinated NUMERIC
)
insert into #percentPopulationVaccinated
select dea.continent,dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(convert(bigint, vac.new_vaccinations)) over (partition by dea.location order by dea.location,dea.date) as RollingPeoplevaccinated 
from PortfolioProject..coviddeathdata1 dea 
join PortfolioProject..covidvacdata1 vac 
On dea.location = vac.location 
and dea.date = vac.date 
where dea.continent is not NULL
and dea.location like '%States%'

select * , (RollingPeopleVaccinated/population)*100 as Percentvaccinated
from #percentPopulationVaccinated
order by 2,3

--Same problem as before where the number of new vaccinations exceeds the population pretty quickly
--causing the percent of the U.S. to be vaccinated to be over 200% by 5.10.2023


--Looking at the percent pop. vaccinated in the U.S. for use in a view
select * , (RollingPeopleVaccinated/population)*100 as Percentvaccinated
from percentPopulationVaccinated
where location like '%States%'
order by 2,3

/*Create view for the cumulative Percentage of the United States vaccinated */
create view PercentVaccinated3 AS
select * , (RollingPeopleVaccinated/population)*100 as Percentvaccinated
from percentPopulationVaccinated
where location like '%States'
