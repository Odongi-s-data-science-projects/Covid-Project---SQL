**Data Source and Preparation**

This project utilized the COVID-19 dataset sourced from  https://ourworldindata.org/covid-deaths.


To structure the analysis for efficiency and clarity (matching the relational database setup), the original single source file was split into two primary datasets:

1. CovidDeaths.csv (26 Columns, 85,171 Rows)
Contains core metrics related to the spread and mortality of the virus. Key Columns: location, date, population, total_cases, and total_deaths.
2. CovidVaccinations.csv (37 Columns, 85,171 Rows)
Contains metrics related to testing, vaccinations, and various socioeconomic factors. Key Columns: location, date, total_vaccinations, new_vaccinations, stringency_index, and other demographic/health columns.

Both tables are joined using the location and date columns to perform the cumulative vaccination rate analysis within the SQL script.


**Description**

This repository contains a robust SQL script (Covid Project.sql) that performs in-depth data analysis on two major COVID-19 datasets (CovidDeaths and CovidVaccinations). The project demonstrates key data manipulation techniques, including complex table joins, rolling aggregates, Common Table Expressions (CTEs), Temporary Tables, and the creation of SQL Views for downstream visualization tools (like Tableau or Power BI).


**Key Analytical Areas**
1. Mortality Rate: Calculating the fatality rate (Death Percentage) globally and per country.
2. Infection Spread: Determining the percentage of the population infected over time.
3. Vaccination Progress: Calculating the Rolling Count of people vaccinated and the percentage of the population that has received at least one dose.
4. Advanced SQL Techniques: Utilization of CTEs, Temp Tables, and Views for efficient querying and data preparation.
5. Data Preparation: Final steps include creating a persistent View to make the complex analysis easily accessible for visualization tools.


**Getting Started**

The project was conducted on PostgreSQL and Excel.


**Execution**
1. Load Data: Ensure your database instance has the CovidDeaths and CovidVaccinations tables loaded.
2. Execute the Script: Run the entire Covid Project.sql file in your database client.

The script will execute a series of analytical queries, perform complex calculations, and most importantly, create a persistent SQL View named PercentPopulationVaccinated that holds the final, analyzed data set ready for visualization.


**Detailed Project Steps (Insights)**
Here is the step-by-step breakdown of the analysis performed by Covid Project.sql:
1. Initial Data Display: Displaying the first 5 contents of the CovidDeaths table (excluding continent aggregates).
2. Mortality Rate Calculation (Kenya Example): Shows the likelihood (percentage) of dying from COVID-19 based on total cases.
3. Infection Rate Calculation (Kenya Example): Shows what percentage of the population has contracted COVID-19.
4. Global Mortality Counts (by Continent): Summarizing total deaths where continent is excluded but location is present (to get aggregate continent totals).
5. Data Preparation (Joining Tables): Joining the CovidDeaths (dea) and CovidVaccinations (vac) tables on location and date.
6. Rolling Vaccination Count: Looking at Total Population vs. Vaccination by calculating a running total of vaccinations (RollingPeopleVaccinated).
7. Calculating % Vaccinated (Using CTE): Uses a Common Table Expression (PopvsVac) to calculate the percentage of the population that is vaccinated using the rolling count.
8. Calculating % Vaccinated (Using Temp Table): Demonstrates the same calculation as above, but using a Temporary Table (PercentPopulationVaccinated).
9. Creating Final View for Visualization: Creating a persistent View (PercentPopulationVaccinated) to store the final analyzed data, making it easy to connect to BI tools without re-running complex calculations.
