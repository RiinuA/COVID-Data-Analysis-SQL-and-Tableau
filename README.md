# Covid Data Analysis #
This repository contains SQL queries used to analyze COVID-19 data from two datasets: list_of_covid_deaths and covid_vaccination_data. The analysis focuses on various aspects such as total cases, deaths, vaccination rates, and their relation to various demographic and socio-economic factors.

Before importing tables to pgAdmin4, I took the following actions:
- Using Excel, I broke the dataset into two tables - list_of_covid_deaths and covid_vaccination_data
- Created tables and columns with correct data types in pgAdmin
- checked the column formats in each table to make sure they match

Skills used: JOIN, Creating TEMP tables, CTE, aggregated functions, converting data, creating VIEWS

## Data Sources ##

Original dataset: https://ourworldindata.org/covid-deaths

## Queries ##

The SQL queries in this project cover a wide range of analyses. Here are some of the key analyses performed:

Total COVID-19 cases and deaths by country and date.

- The likelihood of dying if you contract COVID-19 in any given country.
- The percentage of the population that has contracted COVID-19 by country.
- The countries with the highest infection and death rates.
- The continents with the highest infection and death rates.
- The total world population vs. vaccinations per day.
- The vaccination rates by country.
- The relationship between extreme poverty and COVID-19 death rate.

##### You can find all the SQL queries in the Covid_dada_SQL_Project.sql file in this repository. #####

## Results ##
The results of this analysis provide insights into the impact of COVID-19 on different countries and continents. 
They also highlight the progress of the vaccination campaign and its potential impact on the number of cases and deaths. 
Furthermore, they reveal correlations between socioeconomic factors like extreme poverty and the impact of the pandemic.


## Visualizations ##

The results of the SQL queries are used to create various visualizations that help in understanding the data better. The visualizations focus on:

#### Total Global Numbers #### 
This visualization provides a global view of the total number of COVID-19 cases and deaths. It helps to understand the overall impact of the pandemic globally.

#### Death Count by Continent #### 
This visualization shows the total number of COVID-19 deaths by continent. It helps to identify which continents have been most affected by the pandemic in terms of mortality.

#### COVID-19 Death % per Country ####
This visualization shows the percentage of COVID-19 deaths per country. It provides insights into the severity of the pandemic in different countries.

#### % Population Affected by COVID-19 ####
This visualization shows the percentage of the population that has been affected by COVID-19 in each country. It helps to understand the spread of the virus within different populations.

#### Relationship between Extreme Poverty and COVID-19 Death Rate ####
This visualization shows the relationship between the level of extreme poverty in a country and the COVID-19 death rate. Interestingly, the visualization suggests that there is no clear correlation between the poverty index and the death rate from COVID-19. This could be due to various factors, including the effectiveness of different countries' responses to the pandemic, the demographic makeup of their populations, and other socio-economic factors.

These visualizations are created in Tableau and can be found here: https://public.tableau.com/views/COVID-19DataAnalysis_16907553665210/Dashboard1?:language=en-GB&:display_count=n&:origin=viz_share_link 

## Contributing ##
Contributions to this project are welcome! If you have a suggestion for improving the queries or the analysis, please open an issue to discuss it. If you would like to contribute directly, feel free to make a pull request.
