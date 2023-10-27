select *
from port..CovidDeaths
order by 3, 4

select *
from port..CovidVaccinations
order by 3, 4


select location, date, total_cases, new_cases, total_deaths, population
from port..CovidDeaths
order by 1, 2



--looking for total cases vs deaths

select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as deathpercentage
from port..CovidDeaths
where location like '%A%'
order by 1, 2

--looking at the total cases against population

select location, date, total_cases, population, (total_cases/population)*100
from port..CovidDeaths
order by 1,2

--looking at countries with highest case rate against population

select location, population,date, max(total_cases) as highinfec, max((total_cases/population))*100 as populationinfected
from port..CovidDeaths
--where location like '%_nd%'
group by location, population, date
order by populationinfected desc

--hihest death count per population
select location, population, max(total_deaths) as highestdeath, max(total_deaths/population)*100 as deathcount
from port..CovidDeaths
group by location, population, date
order by deathcount desc

--higest death by continent 
select continent, max(total_deaths) as contdeathrate
from port..CovidDeaths
group by continent
order by contdeathrate asc

--global numbers
select date, sum(new_cases) as totalbyday, sum(cast (new_deaths as int))
from port..CovidDeaths
group by date 
order by 1,2

--combining deaths and vaccination data
select *
from port..CovidDeaths cd
join port..CovidVaccinations cv
on cd.location = cv.location and cd.date = cv.date

--looking at total pop and vac
select cd.continent, cd.population, cd.date, cv.new_vaccinations, cd.location
from port..CovidDeaths cd
join port..CovidVaccinations cv
on cd.location = cv.location and cd.date = cv.date
order by 2

--partion by location
select cd.continent, cd.population, cd.date, cd.location, cv.new_vaccinations, sum(convert(int,cv.new_vaccinations)) over (partition by cd.location order by cd.date, cd.location)
from port..CovidDeaths cd
join port..CovidVaccinations cv
on cd.location = cv.location and cd.date = cv.date
order by 2


With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations
, SUM(CONVERT(int,cv.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
from port..CovidDeaths cd
join port..CovidVaccinations cv
on cd.location = cv.location and cd.date = cv.date
order by 2
)
Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac


