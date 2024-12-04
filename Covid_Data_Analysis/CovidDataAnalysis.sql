


-- Initial dataset exploration
SELECT 
    Location, 
    Date, 
    Total_Cases, 
    New_Cases, 
    Total_Deaths, 
    Population
FROM PortfolioProject..CovidDeaths
WHERE Continent IS NOT NULL
ORDER BY Location, Date;



-- Likelihood of dying if infected with COVID-19
SELECT 
    Location, 
    Date, 
    Total_Cases, 
    Total_Deaths, 
    (CAST(Total_Deaths AS FLOAT) / CAST(Total_Cases AS FLOAT)) * 100 AS DeathPercentage
FROM PortfolioProject..CovidDeaths
WHERE Location LIKE '%States%'
  AND Continent IS NOT NULL
ORDER BY Location, Date;



-- Percentage of population infected with COVID-19
SELECT 
    Location, 
    Date, 
    Population, 
    Total_Cases,  
    (CAST(Total_Cases AS FLOAT) / CAST(Population AS FLOAT)) * 100 AS PercentPopulationInfected
FROM PortfolioProject..CovidDeaths
WHERE Continent IS NOT NULL
ORDER BY Location, Date;



-- Countries with the highest infection rate compared to population
SELECT 
    Location, 
    Population, 
    MAX(Total_Cases) AS HighestInfectionCount,  
    MAX(CAST(Total_Cases AS FLOAT) / CAST(Population AS FLOAT)) * 100 AS PercentPopulationInfected
FROM PortfolioProject..CovidDeaths
GROUP BY Location, Population
ORDER BY PercentPopulationInfected DESC;



-- Countries with the highest death count
SELECT 
    Location, 
    MAX(CAST(Total_Deaths AS INT)) AS TotalDeathCount
FROM PortfolioProject..CovidDeaths
WHERE Continent IS NOT NULL
GROUP BY Location
ORDER BY TotalDeathCount DESC;



-- Continents with the highest death count
SELECT 
    Continent, 
    MAX(CAST(Total_Deaths AS INT)) AS TotalDeathCount
FROM PortfolioProject..CovidDeaths
WHERE Continent IS NOT NULL
GROUP BY Continent
ORDER BY TotalDeathCount DESC;



-- Global COVID-19 statistics
SELECT 
    SUM(New_Cases) AS Total_Cases, 
    SUM(CAST(New_Deaths AS INT)) AS Total_Deaths, 
    (SUM(CAST(New_Deaths AS INT)) * 1.0 / SUM(New_Cases)) * 100 AS DeathPercentage
FROM PortfolioProject..CovidDeaths
WHERE Continent IS NOT NULL;



-- Vaccination data with cumulative calculations
SELECT 
    dea.Continent, 
    dea.Location, 
    dea.Date, 
    dea.Population, 
    vac.New_Vaccinations,
    SUM(CAST(vac.New_Vaccinations AS FLOAT)) 
        OVER (
            PARTITION BY dea.Location 
            ORDER BY dea.Date
        ) AS CumulativeVaccinations
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
    ON dea.Location = vac.Location
    AND dea.Date = vac.Date
WHERE dea.Continent IS NOT NULL
ORDER BY dea.Location, dea.Date;



-- Using a CTE to calculate vaccination percentage
WITH PopulationVaccination AS (
    SELECT 
        dea.Continent, 
        dea.Location, 
        dea.Date, 
        dea.Population, 
        vac.New_Vaccinations,
        SUM(CAST(vac.New_Vaccinations AS FLOAT)) 
            OVER (
                PARTITION BY dea.Location 
                ORDER BY dea.Date
            ) AS CumulativeVaccinations
    FROM PortfolioProject..CovidDeaths dea
    JOIN PortfolioProject..CovidVaccinations vac
        ON dea.Location = vac.Location
        AND dea.Date = vac.Date
    WHERE dea.Continent IS NOT NULL
)
SELECT 
    Continent, 
    Location, 
    Date, 
    Population, 
    New_Vaccinations, 
    CumulativeVaccinations, 
    (CumulativeVaccinations * 1.0 / Population) * 100 AS VaccinationPercentage
FROM PopulationVaccination
ORDER BY Location, Date;



-- Create a view to store vaccination data for visualization
CREATE VIEW PercentPopulationVaccinated AS
SELECT 
    dea.Continent, 
    dea.Location, 
    dea.Date, 
    dea.Population, 
    vac.New_Vaccinations,
    SUM(CAST(vac.New_Vaccinations AS FLOAT)) 
        OVER (
            PARTITION BY dea.Location 
            ORDER BY dea.Date
        ) AS CumulativeVaccinations
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
    ON dea.Location = vac.Location
    AND dea.Date = vac.Date
WHERE dea.Continent IS NOT NULL;
