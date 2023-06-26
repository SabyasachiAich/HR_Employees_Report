Create database HR;

Use HR;

/* Import Data using Table Data Import Wizard*/

Select *
from hr_table;

/* ~~Data Cleaning:~~ */

/*Change the column name id to employee_id*/
Alter table hr_table
change column id employee_id varchar(20);

describe hr_table;

Select birthdate
from hr_table;

Set sql_safe_updates = 0;

/*Changing the text data type to Varchar*/
Alter table hr_table
modify column first_name varchar(50);

Alter table hr_table
modify column last_name varchar(50);

Alter table hr_table
modify column gender varchar(20);

Alter table hr_table
modify column race varchar(50);

Alter table hr_table
modify column department varchar(50);

Alter table hr_table
modify column jobtitle varchar(50);

Alter table hr_table
modify column location varchar(50);

Alter table hr_table
modify column location_city varchar(50);

Alter table hr_table
modify column location_state varchar(50);

/*Changing birthdate and hiredate format to default date*/
update hr_table
set birthdate = str_to_date(birthdate, '%d-%m-%Y');

Alter table hr_table
modify column birthdate date;

update hr_table
set hire_date = str_to_date(hire_date, '%d-%m-%Y');

Alter table hr_table
modify column hire_date date;

Select *
from hr_table;

describe hr_table;

/*Changing termdate format to default date */
Update hr_table
Set termdate = date(str_to_date(termdate, '%Y-%m-%d %H:%i:%s UTC'))
where termdate is not null and termdate !='';

Set SQL_MODE = '';

Alter table hr_table
modify column termdate date;

Select termdate
from hr_table;

Select *
from hr_table;

/*Finding Age from birthdate*/
Alter table hr_table
Add column Age int(3);

select *
from hr_table;

select age
from hr_table;

Update hr_table
Set Age = timestampdiff(YEAR, birthdate, curdate());

Select birthdate, age
from hr_table;

Select max(age) as Oldest_employee_age, min(age) as Youngest_employee_age
from hr_table;
/* ~~End of Data Cleaning~~ */

/* ~~Analysis~~ */
Select *
from hr_table;

/*Questions:*/
-- Q1. What is the Gender wise breakdown of employees in the company? --

Select gender, count(*) as total_employees
from hr_table
where termdate = '0000-00-00'
group by gender;
 
-- Q2. What is the Race/Ethnicity wise breakdown of employees in the company? --

Select race, count(*) as total_employees
from hr_table
where termdate = '0000-00-00'
group by race
order by Total_Employees desc;

-- Q3. What is the Age distribution of employees in the company? --

/*Employees per age*/
Select Age, count(*) as Total_Employees
from hr_table
where termdate = '0000-00-00'
group by age
order by age;

/* Employees per Age Distribution Distribution (Creating Age Distribution)*/
Select
	Case
		When age >= 20 and age <= 24 Then '20-24'
        When age >= 25 and age <= 29 Then '25-29'
        When age >= 30 and age <= 34 Then '30-34'
        When age >= 35 and age <= 39 Then '35-39'
        When age >= 40 and age <= 44 Then '40-44'
        When age >= 45 and age <= 49 Then '45-49'
        When age >= 50 and age <= 54 Then '50-54'
        else '54+'
	End as age_group,
    count(*) as total_employees
from hr_table
where termdate = '0000-00-00'
group by Age_Group
order by Age_Group;

-- Q4. What is the Age distribution of employees by their gender in the company? --

Select
	Case
		When age >= 20 and age <= 24 Then '20-24'
        When age >= 25 and age <= 29 Then '25-29'
        When age >= 30 and age <= 34 Then '30-34'
        When age >= 35 and age <= 39 Then '35-39'
        When age >= 40 and age <= 44 Then '40-44'
        When age >= 45 and age <= 49 Then '45-49'
        When age >= 50 and age <= 54 Then '50-54'
        else '54+'
	End as age_group, gender,
    count(*) as total_employees
from hr_table
where termdate = '0000-00-00'
group by Age_Group, Gender
order by Age_Group, Gender;

-- Q5. How many employees work at head quarters versus remote location? --

Select location, count(*) as total_employees
from hr_table
where  termdate = '0000-00-00'
group by location;

-- Q6. What is the Average length of employment for employees who has been terminated? --
Select round(avg(datediff(termdate, hire_date))/365, 0) as avg_length_of_employment_in_years
from hr_table
where termdate != '0000-00-00' and termdate <= curdate();

-- Q7. How does the gender distribution vary accross departments and job titles? --
Select department, gender, jobtitle, count(employee_id) as total_employees
from hr_table
where termdate = '0000-00-00'
group by department, gender
order by department;

-- Q8. What is the distribution of job titles across the country? --
Select jobtitle, count(*) as total_employees
from hr_table
where termdate = '0000-00-00'
group by jobtitle
order by jobtitle;

-- Q9. Which department has the highest turnover rate? --

Select 
	department, 
    total_employees, 
    employees_terminated, 
    employees_terminated/total_employees as termination_rate
from (select department, 
	         count(*) as total_employees, 
             sum(case when termdate != '0000-00-00' and termdate <= curdate() then 1 else 0 end) as employees_terminated
	  from hr_table
      group by department) as subquery
order by termination_rate desc;

-- Q10. What is the distribution of employees accross locations by city and state? --

Select distinct location_city, count(*) as total_employee
from hr_table
where termdate = '0000-00-00'
group by location_city
order by total_employee desc;

Select distinct location_state, count(*) as total_employee
from hr_table
where termdate = '0000-00-00'
group by location_state
order by total_employee desc;

-- Q11. How has the company's employee count changed over timebased on hire and term dates? --

Select 
	year,
    hires, 
    terminations,
    hires - terminations as net_change,
    round((hires - terminations)/hires*100, 2) as net_change_percentage
from(select 
		year(hire_date) as year,
        count(*) as hires,
        sum(case when termdate != '0000-00-00' and termdate <= curdate() then 1 else 0 end) as terminations
        from hr_table
        group by year(hire_date)
        ) as subquery
order by year asc;


-- Q12. What is the tenure distribution for each department? --
Select department, round(avg(datediff(termdate, hire_date)/365), 0) as avg_tenure
from hr_table
where termdate != '0000-00-00' and termdate <= curdate() 
group by department;


/* ~~End of Analysis~~ */

