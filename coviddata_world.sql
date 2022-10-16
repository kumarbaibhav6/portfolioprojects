SELECT * 
FROM [Portfolio Project]..coviddeaths$
where continent is not null
order by 3,4 


--SELECT * 
--FROM [Portfolio Project]..covid_vaccinations$
--order by 3,4 

SELECT Location, date, total_cases, new_cases, total_deaths, population
FROM [Portfolio Project]..coviddeaths$
order by 1,2

--Looking at total cases vs total deaths
--Shows the likehood of dying if you get covid in your country
SELECT Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as death_percentage
FROM [Portfolio Project]..coviddeaths$
where location = 'India'
order by 1,2
--Looking at total cases vs population
--pecentage of population affected by covid
SELECT Location, date, total_cases, population, (total_cases/population)*100 as percentage_infected
FROM [Portfolio Project]..coviddeaths$
where location = 'India'
order by 1,2

--Looking at countries with high infection rates vs population
SELECT Location, MAX(total_cases) as highestinfection_count, population, MAX(total_cases/population)*100 as percentage_pop_infected
FROM [Portfolio Project]..coviddeaths$
--where location = 'India'
group by location,population
order by percentage_pop_infected desc

--Showing countries with highest death count per population
SELECT Location, MAX(CAST(total_deaths as int)) as totaldeathcount
FROM [Portfolio Project]..coviddeaths$
--where location = 'India'
where continent is not null
group by location
order by totaldeathcount desc

--ANALYSIS BY CONTINENT 
SELECT continent, MAX(CAST(total_deaths as int)) as totaldeathcount
FROM [Portfolio Project]..coviddeaths$
--where location = 'India'
where continent is not null
group by continent
order by totaldeathcount desc

--showing continents with highest death count

SELECT continent, MAX(CAST(total_deaths as int)) as totaldeathcount
FROM [Portfolio Project]..coviddeaths$
--where location = 'India'
where continent is not null
group by continent
order by totaldeathcount desc


--GLOBAL ANALYSIS

SELECT sum(new_cases) as totalcases,sum(cast(new_deaths as int)) as totaldeaths, sum(cast(new_deaths as int))/sum(new_cases)*100 as death_percentage
FROM [Portfolio Project]..coviddeaths$
where continent is not null
--group by date
order by 1,2

--USE CTE

With PopvsVac (Continent, location, date, population, new_vaccination, people_vaccinated)
as
(
select d.location, d.date, d.continent, d.population,v.new_vaccinations, sum(convert(bigint,v.new_vaccinations)) over (partition by d.location order by d.location,d.date) as people_vaccinated
from [Portfolio Project]..coviddeaths$ d
join covid_vaccinations$ v
on d.location= v.location
AND d.date=v.date
where d.continent is not null
--order by 1,2
)
select *, (people_vaccinated/population)*100
from PopvsVac


--Create view for data visualization

CREATE View
PercentPopulationVacc as 
select d.location, d.date, d.continent, d.population,v.new_vaccinations, sum(convert(bigint,v.new_vaccinations)) over (partition by d.location order by d.location,d.date) as people_vaccinated
from [Portfolio Project]..coviddeaths$ d
join covid_vaccinations$ v
on d.location= v.location
AND d.date=v.date
where d.continent is not null
--order by 1,2

Select * 
from PercentPopulationVacc
--Where location = 'India'