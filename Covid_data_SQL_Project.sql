/*PART 1: Exploring the data*/

SELECT*FROM list_of_covid_deaths
SELECT * FROM covid_vaccination_data
----------------------------------------
SELECT country, date, total_cases, new_cases, total_deaths, population FROM list_of_covid_deaths
ORDER BY 1,2 
	
/*Let's check Total Cases vs Total Deaths by country
Shows the likelihood of dying if you contract Covid in any given country*/
	
SELECT country, date, total_cases, total_deaths, ((total_deaths/total_cases)*100)
AS death_percentage FROM list_of_covid_deaths
ORDER BY 1,2

SELECT DISTINCT country, continent FROM list_of_covid_deaths

/*This list has 255 entries and includes values that are not countries: different continents, World,
and economic statuses (eg. Low income). 
Here's how to separate them: */

SELECT DISTINCT country, continent FROM list_of_covid_deaths
WHERE continent is not NULL
ORDER BY 1

/*Next I'm checking the death rate based on total cases*/
SELECT country, date, total_cases, total_deaths, ((total_deaths/total_cases)*100)
AS death_percentage FROM list_of_covid_deaths
WHERE total_cases is not null
ORDER BY 5 desc

/*From here I want to see the death % per population. 
Based on that, Peru has currently the highest death % per population*/

SELECT country, date, population, total_deaths, MAX((total_deaths/population)*100) AS death_percentage
FROM list_of_covid_deaths
WHERE continent is not null
	and total_deaths is not null			
				
GROUP BY population, country, total_deaths, date
ORDER BY death_percentage desc

/*Let's look at the total cases vs. population by country.
This shows the percentage of the population that has gotten covid.
Note: some people might have contracted it multiple times*/

SELECT country, date, total_cases, population, ((total_cases/population)*100)
AS perc_cases_per_country FROM list_of_covid_deaths
WHERE total_cases is not null
ORDER BY 5 desc

/*Checking for countries with the highest infection rate according to their population*/

SELECT country, MAX(total_cases) AS highest_infection_country, population, MAX((total_cases/population)*100)
AS percent_population_infected FROM list_of_covid_deaths
GROUP BY population, country
ORDER BY percent_population_infected desc;

/*Looking for the countries with the highest death count per population*/
SELECT country, MAX(total_deaths) AS highest_mortality_country FROM list_of_covid_deaths
WHERE continent is not null
GROUP BY country
ORDER BY highest_mortality_country desc

/*Let's break it down by continent*/
SELECT continent, MAX(total_deaths) AS highest_mortality_continent FROM list_of_covid_deaths
WHERE continent is not null
GROUP BY continent
ORDER BY highest_mortality_continent desc

/*Sidenote: it seems like North America is only taking data from the USA and not from Canada and Mexico.*/
/*If we change the WHERE statement, we will get the correct numbers*/
	
SELECT country, MAX(total_deaths) AS highest_mortality_continent FROM list_of_covid_deaths
WHERE continent is null
GROUP BY country
ORDER BY highest_mortality_continent desc

/*Let's check the continents with the highest infection rate*/
SELECT country, MAX(total_cases) AS highest_infection_continent FROM list_of_covid_deaths
WHERE continent is null
GROUP BY country
ORDER BY highest_infection_continent desc;
/*Based on these two results we can see that the infection cases don't correlate with death cases.
Asia has the most infections, North America is 3rd in infections but 1st in deaths */

/*Looking at GLOBAL NUMBERS*/

SELECT date, SUM(new_cases) as total_new_cases, SUM(new_deaths) as total_new_deaths, SUM(new_deaths)/SUM(new_cases) as death_percentage
FROM list_of_covid_deaths
WHERE continent is not null and new_cases !=0 and new_deaths !=0
GROUP BY date
ORDER BY death_percentage desc
/*Sidenote: getting an error: division by zero. To eliminate, remove results that equal 0*/

/*Total cases across the world since Jan 2020 until today vs total deaths*/
SELECT SUM(new_cases) as total_new_cases, SUM(new_deaths) as total_new_deaths, SUM(new_deaths)/SUM(new_cases) as death_percentage
FROM list_of_covid_deaths
WHERE continent is not null and new_cases !=0 and new_deaths !=0
ORDER BY 1,2

/*JOINING DEATHS AND VACCINATIONS TABLES*/

SELECT * FROM list_of_covid_deaths dea
		JOIN covid_vaccination_data vac
		ON dea.country = vac.country
		AND dea.date = vac.date
		
/*Let's look at the total world population vs. vaccinations per day*/
	
SELECT dea.continent, dea.country, dea.date, dea.population, vac.new_vaccinations
FROM list_of_covid_deaths dea
		JOIN covid_vaccination_data vac
		ON dea.country = vac.country
		AND dea.date = vac.date
WHERE dea.continent is not null
Order by 1,2,3


/*Select rolling amounts of vaccinations in each country*/
	
SELECT dea.continent, dea.country, dea.date, dea.population, vac.new_vaccinations, SUM(vac.new_vaccinations)
OVER (Partition by dea.country ORDER BY dea.country, dea.date) as rolling_people_vaccinated
FROM list_of_covid_deaths dea
		JOIN covid_vaccination_data vac
		ON dea.country = vac.country
		AND dea.date = vac.date
WHERE dea.continent is not null
Order by 2,3

/*Using CTE to check rolling % of people vaccinated in relation to the population */

With PopvsVac (continent, country, date, population, new_vaccinations, rolling_people_vaccinated)
AS
(SELECT dea.continent, dea.country, dea.date, dea.population, vac.new_vaccinations, SUM(vac.new_vaccinations)
OVER (Partition by dea.country ORDER BY dea.country, dea.date) as rolling_people_vaccinated
FROM list_of_covid_deaths dea
		JOIN covid_vaccination_data vac
		ON dea.country = vac.country
		AND dea.date = vac.date
WHERE dea.continent is not null)

SELECT * FROM PopvsVac

/*Perform further calculations - find the % of the population vaccinated per country
Sidenote: when checking this data based on country, it appears that by July 2023, over 200% of the US population is vaccinated, 
which makes me think that new_vaccines does not count only unique vaccines but also includes boosters. */

With PopvsVac (continent, country, date, population, new_vaccinations, rolling_people_vaccinated)
AS
(SELECT dea.continent, dea.country, dea.date, dea.population, vac.new_vaccinations, SUM(vac.new_vaccinations)
OVER (Partition by dea.country ORDER BY dea.country, dea.date) as rolling_people_vaccinated
FROM list_of_covid_deaths dea
		JOIN covid_vaccination_data vac
		ON dea.country = vac.country
		AND dea.date = vac.date
WHERE dea.continent is not null and dea.country like '%States%')

SELECT *, (rolling_people_vaccinated/population)*100 FROM PopvsVac

/*Using TEMP TABLE to get same result*/

CREATE TABLE PercentPopulationVaccinated
(Continent text, country text, date date, population numeric, new_vaccinations numeric, rolling_people_vaccinated numeric);

INSERT INTO PercentPopulationVaccinated
SELECT dea.continent, dea.country, dea.date, dea.population, vac.new_vaccinations, SUM(vac.new_vaccinations)
OVER (Partition by dea.country ORDER BY dea.country, dea.date) as rolling_people_vaccinated
FROM list_of_covid_deaths dea
		JOIN covid_vaccination_data vac
		ON dea.country = vac.country
		AND dea.date = vac.date
WHERE dea.continent is not null

SELECT * FROM PercentPopulationVaccinated


/*Creating a view to store data for later visualizations*/
	
CREATE VIEW PopulationVaccinated as
SELECT dea.continent, dea.country, dea.date, dea.population, vac.new_vaccinations, SUM(vac.new_vaccinations)
OVER (Partition by dea.country ORDER BY dea.country, dea.date) as rolling_people_vaccinated
FROM list_of_covid_deaths dea
		JOIN covid_vaccination_data vac
		ON dea.country = vac.country
		AND dea.date = vac.date
WHERE dea.continent is not null

/*Next I'm looking at the information about health stats and poverty rate*/

SELECT country, population, extreme_poverty, cardiovasc_death_rate, diabetes_prevalence, female_smokers, male_smokers
FROM covid_vaccination_data
WHERE continent is not null and extreme_poverty is not null
ORDER BY 3
/*This shows that Japan has the lowest cardiovascular death rate while Benin has the lowest diabetes prevalence. 
Niger has the least female smokers and Ghana has the least male smokers. Madagascar has the highest extreme poverty rate */

/*Let's see the vaccinations per country*/

SELECT country, date, total_vaccinations FROM covid_vaccination_data
WHERE continent is not null
Order by 2

/*We are going to see the vaccination rates by country. Excluding countries where vaccination rate 
is higher than population
as they have most likely vaccinated also non-residents*/
SELECT country, date, population, people_fully_vaccinated, MAX((people_fully_vaccinated/population)*100) as percentage_vaccinated
FROM covid_vaccination_data
WHERE country not in('World', 'Upper middle income', 'Lower middle income',
										   'European Union', 'Low income', 'High income' ) 
				and population > 100000
				and people_fully_vaccinated is not null
				and population > people_fully_vaccinated
GROUP BY population, country, date, people_fully_vaccinated
ORDER BY percentage_vaccinated desc

/*We will also exclude the following countries: UAE, Brunei, Qatar 
as per the data source their data includes non-residents*/

SELECT country, date, population, people_fully_vaccinated, MAX((people_fully_vaccinated/population)*100) as percentage_vaccinated
FROM covid_vaccination_data
WHERE country not in('World', 'Upper middle income', 'Lower middle income',
										   'European Union', 'Low income', 'High income', 'United Arab Emirates',
								'Brunei', 'Qatar') 
				and population > 100000
				and people_fully_vaccinated is not null
				and population > people_fully_vaccinated
				and country = 'China'
				
GROUP BY population, country, date, people_fully_vaccinated
ORDER BY percentage_vaccinated desc

/*We are going to see the vaccination rates by country. Excluding countries where vaccination rate 
is higher than population
as they have most likely vaccinated also non-residents*/
SELECT country, date, population, people_fully_vaccinated, MAX((people_fully_vaccinated/population)*100) as percentage_vaccinated
FROM covid_vaccination_data
WHERE country not in('World', 'Upper middle income', 'Lower middle income',
										   'European Union', 'Low income', 'High income' ) 
				and population > 100000
				and people_fully_vaccinated is not null
				and population > people_fully_vaccinated
GROUP BY population, country, date, people_fully_vaccinated
ORDER BY percentage_vaccinated desc

/*We will also exclude the following countries: UAE, Brunei, Qatar 
as per the data source their data includes non-residents*/

SELECT country, date, population, people_fully_vaccinated, MAX((people_fully_vaccinated/population)*100) as percentage_vaccinated
FROM covid_vaccination_data
WHERE country not in('World', 'Upper middle income', 'Lower middle income',
										   'European Union', 'Low income', 'High income', 'United Arab Emirates',
								'Brunei', 'Qatar') 
				and population > 100000
				and people_fully_vaccinated is not null
				and population > people_fully_vaccinated
				and country = 'China'
				
GROUP BY population, country, date, people_fully_vaccinated
ORDER BY percentage_vaccinated desc

--------------------------------------------------------------------------------------

/*PART 2 - let's get the tables ready for Data Visualization
I will be creating a dashboard with 5 tables to visualize the following:
- Total Global Numbers
- Death Count by Continent
- Covid Death % per Country
- % population affected by covid
- Relationship between extreme poverty and covid death rate*/

/*TABLE 1*/
SELECT SUM(new_cases) as total_new_cases, SUM(new_deaths) as total_new_deaths, SUM(new_deaths)/SUM(new_cases) as death_percentage
FROM list_of_covid_deaths
WHERE continent is not null and new_cases !=0 and new_deaths !=0
ORDER BY 1,2

/*Table 2*/
SELECT continent, MAX(total_deaths) AS highest_mortality_continent FROM list_of_covid_deaths
WHERE continent is not null
GROUP BY continent
ORDER BY highest_mortality_continent desc

/*TABLE 3*/
SELECT country, population, total_deaths, date, MAX((total_deaths/population)*100) AS death_percentage
FROM list_of_covid_deaths
WHERE country not in('World', 'Upper middle income', 'Lower middle income',
										   'European Union', 'Low income', 'High income')
				
GROUP BY population, country, total_deaths, date
ORDER BY death_percentage desc

/*TABLE 4*/
SELECT country, date, total_cases, population, ((total_cases/population)*100)
AS perc_cases_per_country FROM list_of_covid_deaths
WHERE total_cases is not null
ORDER BY 5 desc

/*TABLE 5*/
SELECT country, date, total_cases, population, ((total_cases/population)*100)
AS perc_cases_per_country FROM list_of_covid_deaths
WHERE total_cases is not null
ORDER BY 5 desc
