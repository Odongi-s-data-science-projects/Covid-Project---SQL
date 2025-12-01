drop table if exists CovidDeaths;

create table CovidDeaths (
	iso_code varchar(40),
	continent varchar(40),
	location varchar(40),	
	date date,
	total_cases bigint,
	population bigint,
	new_cases bigint,
	new_cases_smoothed numeric,
	total_deaths bigint,
	new_deaths bigint,
	new_deaths_smoothed numeric,
	total_cases_per_million numeric,
	new_cases_per_million numeric,
	new_cases_smoothed_per_million numeric,
	total_deaths_per_million numeric,
	new_deaths_per_million numeric,
	new_deaths_smoothed_per_million numeric,
	reproduction_rate numeric,
	icu_patients bigint,
	icu_patients_per_million numeric,
	hosp_patients bigint,
	hosp_patients_per_million numeric,
	weekly_icu_admissions numeric,
	weekly_icu_admissions_per_million numeric,
	weekly_hosp_admissions numeric,
	weekly_hosp_admissions_per_million numeric
);



--Import the CovidDeaths csv file

-- Displaying the first 5 contents.

SELECT *
FROM coviddeaths
WHERE continent is not null; -- In the dataset continents appear as locations thus this line ensures they remain as continents.


--Selecting the data to be used.
SELECT location, date, new_cases, total_deaths, population
FROM coviddeaths
ORDER BY 1,2; --1,2 as in ordering by the 3rd and 4th column instead of typing column names.


--LOOKING AT TOTAL CASES VS TOTAL DEATHS
--Shows the likelihood % of dieing from covid in Kenya.
SELECT location, date, total_cases, total_deaths, population, (total_deaths::decimal/total_cases)*100 AS DeathPercentage
FROM coviddeaths
WHERE location like '%Kenya%'
ORDER BY 1,2;  -- '::decimal'is to ensure SQL does a floating-point division


--LOOKING AT TOTAL CASES VS POPULATION
--Shows what % of population has got Covid in Kenya.
SELECT location, date, total_cases, population, (total_cases::decimal/population)*100 AS PopulationInfectedPercentage
FROM coviddeaths
WHERE location like '%Kenya%'
ORDER BY 1,2;


--LOOKING AT COUNTRIES WITH HIGHEST INFECTION RATE COMPARED TO POPULATION
SELECT location, MAX(total_cases) AS HighestInfectionCount, population, MAX((total_cases::decimal/population)*100) AS PopulationInfectedPercentage
FROM coviddeaths
--WHERE location like '%Kenya%'
GROUP BY location, population
ORDER BY PopulationInfectedPercentage DESC;


--Showing Countries with the Highest Death Count per Population.
SELECT location, MAX(total_deaths) AS TotalDeathCount
FROM coviddeaths
--WHERE location like '%Kenya%'
WHERE continent is not null
GROUP BY location
ORDER BY TotalDeathCount DESC;




--LET'S BREAK THINGS DOWN BY CONTINENT.
--Showing the Continets with the Highest Death Counts.
SELECT location, MAX(total_deaths) AS TotalDeathCount
FROM coviddeaths
--WHERE location like '%Kenya%'
WHERE continent is null
GROUP BY location
ORDER BY TotalDeathCount DESC


--GLOBAL NUMBERS.
SELECT date, SUM(new_cases) AS TotalCases, SUM(new_deaths) AS TotalDeaths,SUM(new_deaths)/NULLIF(SUM(new_cases),0) AS DeathPercentage --NULLIF returns null instead of zero.
FROM coviddeaths
--WHERE location like '%Kenya%'
GROUP BY date
ORDER BY 1;




drop table if exists covidvaccinations;

create table covidvaccinations (
	iso_code varchar(40),	
	continent varchar(40),
	location varchar(40),
	date date,
	new_tests bigint,
	total_tests bigint,
	total_tests_per_thousand numeric,
	new_tests_per_thousand numeric,
	new_tests_smoothed bigint,
	new_tests_smoothed_per_thousand numeric,
	positive_rate numeric,
	tests_per_case numeric,
	tests_units varchar(150),
	total_vaccinations bigint,
	people_vaccinated bigint,
	people_fully_vaccinated bigint,
	new_vaccinations bigint,
	new_vaccinations_smoothed bigint,
	total_vaccinations_per_hundred numeric,
	people_vaccinated_per_hundred numeric,
	people_fully_vaccinated_per_hundred numeric,
	new_vaccinations_smoothed_per_million bigint,
	stringency_index numeric,
	population_density numeric,
	median_age numeric,
	aged_65_older numeric,
	aged_70_older numeric,
	gdp_per_capita numeric,
	extreme_poverty numeric,
	cardiovasc_death_rate numeric,
	diabetes_prevalence numeric,
	female_smokers numeric,
	male_smokers numeric,
	handwashing_facilities numeric,
	hospital_beds_per_thousand numeric,
	life_expectancy numeric,
	human_development_index numeric
);





--Import the CovidVaccinations csv file.

--Display the first 5 contents.

SELECT *
FROM covidvaccinations;





--JOININGI THE TWO TABLES.
SELECT *
FROM coviddeaths dea --dea and vac are just aliases to save time.
JOIN covidvaccinations vac
	ON dea."location" = vac."location"
	AND dea.date = vac.date


--Looking at TOTAL POPULATION VS VACCINATION.
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, --For aggregate functions don't forget commas.
SUM(vac.new_vaccinations) OVER(PARTITION BY dea."location" ORDER BY dea."location", dea.date) AS RollingPeopleVaccinated
FROM coviddeaths dea --dea and vac are just aliases to save time.
JOIN covidvaccinations vac
	ON dea."location" = vac."location"
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
ORDER BY 2,3;



--STEP 1:USING CTE i.e creating a subquery
WITH PopvsVac (continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
AS(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, --For aggregate functions don't forget commas.
SUM(vac.new_vaccinations) OVER(PARTITION BY dea."location" ORDER BY dea."location", dea.date) AS RollingPeopleVaccinated
FROM coviddeaths dea --dea and vac are just aliases to save time.
JOIN covidvaccinations vac
	ON dea."location" = vac."location"
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
--ORDER BY 2,3
)
SELECT *,
(RollingPeopleVaccinated/population)*100
FROM PopvsVac;




--STEP 2: Using a TEMP TABLE i.e a table that exists for a duration.
DROP TABLE IF EXISTS PercentPopulationVaccinated;
CREATE TEMP TABLE PercentPopulationVaccinated(
continet VARCHAR,
location VARCHAR,
date DATE,
population BIGINT,
new_vaccinations BIGINT,
RollingPeopleVaccinated BIGINT
);

INSERT INTO PercentPopulationVaccinated
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, --For aggregate functions don't forget commas.
SUM(vac.new_vaccinations) OVER(PARTITION BY dea."location" ORDER BY dea."location", dea.date) AS RollingPeopleVaccinated
FROM coviddeaths dea --dea and vac are just aliases to save time.
JOIN covidvaccinations vac
	ON dea."location" = vac."location"
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL;
--ORDER BY 2,3

SELECT *,
(RollingPeopleVaccinated/population)*100
FROM PercentPopulationVaccinated;



--Creating view to store our data for later visualizations.
CREATE VIEW PercentPopulationVaccinated AS 
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, --For aggregate functions don't forget commas.
SUM(vac.new_vaccinations) OVER(PARTITION BY dea."location" ORDER BY dea."location", dea.date) AS RollingPeopleVaccinated
FROM coviddeaths dea --dea and vac are just aliases to save time.
JOIN covidvaccinations vac
	ON dea."location" = vac."location"
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL;
--ORDER BY 2,3



SELECT *
FROM PercentPopulationVaccinated;
 
