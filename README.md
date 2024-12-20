# COVID-19 SQL Analysis

This repository contains an analysis of global COVID-19 data using SQL, covering insights on infection rates, mortality, and vaccination trends. The project demonstrates SQL proficiency through the use of various techniques, including data exploration, aggregation, window functions, Common Table Expressions (CTEs), and views.

---

## Project Overview

The goal of this project is to extract meaningful insights from COVID-19 data and prepare it for visualization. Key questions answered in this project include:

1. What is the likelihood of dying if you contract COVID-19 in a particular country?
2. Which countries have the highest infection rates compared to their population?
3. How do vaccination rates compare across countries and continents?

---

## Datasets

The analysis uses the following datasets:

1. **CovidDeaths**: Contains information about total cases, new cases, total deaths, and population by country and date.
2. **CovidVaccinations**: Contains data about vaccinations, including new vaccinations administered by country and date.

Both datasets were preloaded into SQL tables for analysis.

---

## Skills Demonstrated

- **Data Transformation**: Filtering data, creating derived columns.
- **Joins**: Combining datasets for deeper insights.
- **Window Functions**: Calculating cumulative values like total vaccinations by country.
- **Common Table Expressions (CTEs)**: Structuring complex calculations.
- **Views**: Preparing data for easy reuse and visualization.
- **Aggregations**: Identifying trends at global, continental, and country levels.

---

## SQL Queries Overview

### 1. Data Exploration

Extracted and filtered data to provide a clean base for analysis:

```sql
SELECT Location, Date, Total_Cases, New_Cases, Total_Deaths, Population
FROM PortfolioProject..CovidDeaths
WHERE Continent IS NOT NULL
ORDER BY Location, Date;




2. Mortality Analysis

Determined the likelihood of dying from COVID-19 for various countries:


SELECT Location, Date, Total_Cases, Total_Deaths, 
       (CAST(Total_Deaths AS FLOAT) / Total_Cases) * 100 AS DeathPercentage
FROM PortfolioProject..CovidDeaths
WHERE Continent IS NOT NULL;



3. Infection Rates

Analyzed which countries had the highest infection rates relative to their population:


SELECT Location, Population, 
       MAX(Total_Cases) AS HighestInfectionCount, 
       MAX(CAST(Total_Cases AS FLOAT) / Population) * 100 AS PercentPopulationInfected
FROM PortfolioProject..CovidDeaths
GROUP BY Location, Population
ORDER BY PercentPopulationInfected DESC;



4. Vaccination Analysis
Calculated cumulative vaccinations for each country and the percentage of the population vaccinated:

WITH PopulationVaccination AS (
    SELECT dea.Continent, dea.Location, dea.Date, dea.Population, 
           vac.New_Vaccinations, 
           SUM(CAST(vac.New_Vaccinations AS FLOAT)) 
               OVER (PARTITION BY dea.Location ORDER BY dea.Date) AS CumulativeVaccinations
    FROM PortfolioProject..CovidDeaths dea
    JOIN PortfolioProject..CovidVaccinations vac
        ON dea.Location = vac.Location AND dea.Date = vac.Date
    WHERE dea.Continent IS NOT NULL
)
SELECT Location, Date, Population, 
       (CumulativeVaccinations / Population) * 100 AS VaccinationPercentage
FROM PopulationVaccination
ORDER BY Location, Date;



---Insights Gained

1. The United States had one of the highest death percentages among countries with significant COVID-19 cases.

2. Small nations with smaller populations showed disproportionately high infection percentages.

3. Vaccination drives were uneven across continents, with some achieving over 60% population coverage and others lagging significantly.



---Future Work

Integrate these queries with visualization tools like Tableau or Power BI for better storytelling.
Expand the analysis to include time-series trends and forecasting using Python.



---License
This project is open-source and available for anyone to use, modify, or distribute.
