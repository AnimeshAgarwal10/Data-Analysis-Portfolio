Select *
FROM [SQL portfolio]..CovidDeaths
where continent is not null
ORDER BY 3,4

Select *
FROM [SQL portfolio]..CovidVaccinations
ORDER BY 3,4

Select location, date, total_cases, new_cases, total_deaths, population
FROM [SQL portfolio]..CovidDeaths
where continent is not null
ORDER BY 1,2

--Looking at total cases vs total deaths
--Shows likelihood of dying of covid 19

Select location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
FROM [SQL portfolio]..CovidDeaths
Where location like '%India%' and continent is not null
ORDER BY 1,2

--Looking at total cases vs Population
--What % of population got covid

Select location, date, total_cases,population, (total_cases/population)*100 as AffectedPercentage
FROM [SQL portfolio]..CovidDeaths
Where location like '%India%' and continent is not null
ORDER BY 1,2


--Looking at countries with highest infection rate compared to population

Select location, max(total_cases) as Highestinfectioncount,population, max((total_cases/population))*100 as PopulationPercentage
FROM [SQL portfolio]..CovidDeaths
--Where location like '%India%'
Group by location,population
ORDER BY PopulationPercentage desc


--Showing countries with highest death count per population

Select location, max(cast(total_deaths as int)) as TotalDeathCount
FROM [SQL portfolio]..CovidDeaths
--Where location like '%India%'
Where continent is not null
Group by location
ORDER BY TotalDeathCount desc

--BREAKING THINGS DOWN BY CONTINENT
--Shwoing the continents with highest death count

Select continent, max(cast(total_deaths as int)) as TotalDeathCount
FROM [SQL portfolio]..CovidDeaths
--Where location like '%India%'
Where continent is not null
Group by continent
ORDER BY TotalDeathCount desc



--Global numbers

Select Sum(new_cases) as total_cases,Sum(cast(new_deaths as int)) as total_deaths,Sum(cast(new_deaths as int))/Sum(new_cases)*100 as DeathPercentage
FROM [SQL portfolio]..CovidDeaths
--Where location like '%India%' 
where continent is not null
--Group by date
ORDER BY 1,2

--Looking at total population vs vaccinations

Select dea.continent,dea.location,dea.date,population,vac.new_vaccinations
, sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location,
dea.date) as Total_vaccinations_till_date
from [SQL portfolio]..CovidDeaths dea
join [SQL portfolio]..CovidVaccinations vac
on dea.location=vac.location and dea.date=vac.date
where dea.continent is not null
order by 2,3

--USE CTE

with PopvsVac(continent,location,date,population,New_vaccinations,Total_vaccinations_till_date)
as 
(
Select dea.continent,dea.location,dea.date,population,vac.new_vaccinations
, sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location,
dea.date) as Total_vaccinations_till_date
from [SQL portfolio]..CovidDeaths dea
join [SQL portfolio]..CovidVaccinations vac
on dea.location=vac.location and dea.date=vac.date
where dea.continent is not null
--order by 2,3
)

select * ,(Total_vaccinations_till_date/population)*100
from PopvsVac


--TEMP TABLE

Drop table if exists #PercentageVaccinated
Create Table #PercentageVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccination numeric,
Total_vaccinations_till_date numeric
)

Insert into #PercentageVaccinated

Select dea.continent,dea.location,dea.date,population,vac.new_vaccinations
, sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location,
dea.date) as Total_vaccinations_till_date
from [SQL portfolio]..CovidDeaths dea
join [SQL portfolio]..CovidVaccinations vac
on dea.location=vac.location and dea.date=vac.date
where dea.continent is not null
--order by 2,3

select * ,(Total_vaccinations_till_date/population)*100
from #PercentageVaccinated





--CREATING VIEW TO STORE DATA FOR VISUALIZATIONS

create View PercentageVaccinated as
Select dea.continent,dea.location,dea.date,population,vac.new_vaccinations
, sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location,
dea.date) as Total_vaccinations_till_date
from [SQL portfolio]..CovidDeaths dea
join [SQL portfolio]..CovidVaccinations vac
on dea.location=vac.location and dea.date=vac.date
where dea.continent is not null
--order by 2,3

