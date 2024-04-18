Select location,date,total_cases,new_cases,total_deaths, population
From PortfolioProject.dbo.CovidDeaths
order by 1,2

-- total Casess VS total Deaths

Select location,date,total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From PortfolioProject.dbo.CovidDeaths
Where location like '%india'
order by 1,2

-- total Casess VS total Population

Select location,date,total_cases, population, (total_cases/population)*100 as InfectedPercentage
From PortfolioProject.dbo.CovidDeaths
Where location like '%india'
order by 1,2

-- Highest infection

Select location,population,max(total_cases), max((total_cases/population))*100 as InfectedPercentage
From PortfolioProject.dbo.CovidDeaths
group by location,population
order by InfectedPercentage desc

--Countries with highest Death Count

Select location,max(cast (total_deaths as int)) as TotalDeathCount
From PortfolioProject.dbo.CovidDeaths
where continent is not null
group by location
order by TotalDeathCount desc


--Continent with highest Death Count

Select continent,max(cast (total_deaths as int)) as TotalDeathCount
From PortfolioProject.dbo.CovidDeaths
where continent is not null
group by continent
order by TotalDeathCount desc

-- Global Numbers Total Casess

Select sum(total_cases) as TotalCasess ,sum (cast (total_deaths as int)) as TotalDeath, (sum (cast (total_deaths as int))/sum(total_cases))*100 as DeathPercentage
From PortfolioProject.dbo.CovidDeaths
Where continent is not null
order by 1,2

-- Global Numbers New Casess

Select sum(new_cases) as TotalCasess ,sum (cast (new_deaths as int)) as TotalDeath, (sum (cast (new_deaths as int))/sum(new_cases))*100 as DeathPercentage
From PortfolioProject.dbo.CovidDeaths
Where continent is not null
order by 1,2

Select *
From PortfolioProject.dbo.covidvaccinations

-- Total Population vs Vaccinations

Select dea.continent,dea.location,dea.date,dea.population, vac.new_vaccinations,
sum(convert(int,vac.new_vaccinations)) over (Partition by dea.location order by dea.location,dea.date) as RollingPeopleVaccinatinos
From PortfolioProject.dbo.CovidDeaths dea
Join PortfolioProject.dbo.CovidVaccinations vac
 on dea.location = vac.location
 and dea.date = vac.date
 where dea.continent is not null
 order by 2,3

 -- using CTC

with PopVSVacc (continent,location,date,population,new_vaccinations,RollingPeopleVaccinatinos)
as
(
Select dea.continent,dea.location,dea.date,dea.population, vac.new_vaccinations,
sum(convert(int,vac.new_vaccinations)) over (Partition by dea.location order by dea.location,dea.date) as RollingPeopleVaccinatinos
From PortfolioProject.dbo.CovidDeaths dea
Join PortfolioProject.dbo.CovidVaccinations vac
 on dea.location = vac.location
 and dea.date = vac.date
 where dea.continent is not null
 )
 Select *,(RollingPeopleVaccinatinos/population)* 100
 from PopVSVacc

 -- Using Temp Table

 Drop Table if exists #PercentagePopulationVaccinated
 Create Table #PercentagePopulationVaccinated
 (continent nvarchar(300),
 location nvarchar(300),
 date datetime,
 population numeric,
 new_vaccinations numeric,
 RollingPeopleVaccinatinos numeric,
 )

 insert into #PercentagePopulationVaccinated
Select dea.continent,dea.location,dea.date,dea.population, vac.new_vaccinations,
sum(convert(int,vac.new_vaccinations)) over (Partition by dea.location order by dea.location,dea.date) as RollingPeopleVaccinatinos
From PortfolioProject.dbo.CovidDeaths dea
Join PortfolioProject.dbo.CovidVaccinations vac
 on dea.location = vac.location
 and dea.date = vac.date
 where dea.continent is not null

 Select *,(RollingPeopleVaccinatinos/population)* 100
 from #PercentagePopulationVaccinated

 -- Creating View for Visulization

 Create view PercentagePopulationVaccinated as

 Select dea.continent,dea.location,dea.date,dea.population, vac.new_vaccinations,
sum(convert(int,vac.new_vaccinations)) over (Partition by dea.location order by dea.location,dea.date) as RollingPeopleVaccinatinos
From PortfolioProject.dbo.CovidDeaths dea
Join PortfolioProject.dbo.CovidVaccinations vac
 on dea.location = vac.location
 and dea.date = vac.date
 where dea.continent is not null


