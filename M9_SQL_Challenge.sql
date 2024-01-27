-- Creating new tables and setting PRIMARY KEYs and COMPOSITE KEYs :

CREATE TABLE departments (
  dept_no VARCHAR NOT NULL,
  dept_name VARCHAR NOT NULL,
  PRIMARY KEY (dept_no)
);

CREATE TABLE titles (
  title_id VARCHAR NOT NULL,
  title VARCHAR NOT NULL,
  PRIMARY KEY (title_id)
);

CREATE TABLE employees (
  emp_no INT,
  emp_title_id VARCHAR NOT NULL,
  birth_date VARCHAR NOT NULL,
  first_name VARCHAR NOT NULL,
  last_name VARCHAR NOT NULL,
  sex VARCHAR NOT NULL,
  hire_date VARCHAR NOT NULL,
  FOREIGN KEY (emp_title_id) REFERENCES titles (title_id),
  PRIMARY KEY (emp_no)
);

CREATE TABLE salaries (
  emp_no INT,
  salary INT,
  FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
  PRIMARY KEY (emp_no)
);

CREATE TABLE dept_manager (
  dept_no VARCHAR NOT NULL,
  emp_no INT,
  FOREIGN KEY (dept_no) REFERENCES departments (dept_no),
  FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
  PRIMARY KEY (emp_no, dept_no)
);

CREATE TABLE dept_emp (
  emp_no INT,
  dept_no VARCHAR NOT NULL,
  FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
  FOREIGN KEY (dept_no) REFERENCES departments (dept_no),
  PRIMARY KEY (emp_no, dept_no)
);

-- DROP TABLE departments;
-- DROP TABLE titles;
-- DROP TABLE employees;
-- DROP TABLE salaries;
-- DROP TABLE dept_manager;
-- DROP TABLE dept_emp;

-- Remember to specify the data types, primary keys, foreign keys, and other constraints.
-- For the primary keys, verify that the column is unique. Otherwise, create a composite key Links to an external site., which takes two primary keys to uniquely identify a row.
-- Be sure to create the tables in the correct order to handle the foreign keys.

-- DATA ANALYSIS:

-- 1) List the employee number, last name, first name, sex, and salary of each employee.

SELECT employees.emp_no, employees.last_name, employees.first_name, employees.sex, salaries.salary
FROM employees
INNER JOIN salaries ON salaries.emp_no = employees.emp_no

-- 2) List the first name, last name, and hire date for the employees who were hired in 1986.

SELECT employees.first_name, employees.last_name, employees.hire_date
FROM employees
WHERE SUBSTRING(hire_date, 7, 2) = '86';

-- 3) List the manager of each department along with their department number, department name, employee number, last name, and first name.

SELECT dept_manager.dept_no, departments.dept_name, titles.title, employees.emp_no, employees.last_name, employees.first_name
FROM departments
JOIN dept_manager ON dept_manager.dept_no = departments.dept_no
JOIN employees ON dept_manager.emp_no = employees.emp_no
JOIN titles ON titles.title_id = employees.emp_title_id
WHERE titles.title = 'Manager';

-- 4) List the department number for each employee along with that employee’s employee number, last name, first name, and department name.

SELECT departments.dept_no, employees.emp_no, employees.last_name, employees.first_name, departments.dept_name, titles.title
FROM employees
JOIN dept_emp ON employees.emp_no = dept_emp.emp_no
JOIN departments ON dept_emp.dept_no = departments.dept_no
JOIN titles ON titles.title_id = employees.emp_title_id

-- 5) List first name, last name, and sex of each employee whose first name is Hercules and whose last name begins with the letter B.

SELECT first_name, last_name, sex
FROM employees
WHERE first_name = 'Hercules' AND last_name LIKE 'B%';

-- 6) List each employee in the Sales department, including their employee number, last name, and first name.

SELECT employees.emp_no, employees.last_name, employees.first_name, departments.dept_name
FROM employees
JOIN dept_emp ON employees.emp_no = dept_emp.emp_no
JOIN departments ON dept_emp.dept_no = departments.dept_no
WHERE departments.dept_name = 'Sales';

-- 7) List each employee in the Sales and Development departments, including their employee number, last name, first name, and department name.

SELECT employees.emp_no, employees.last_name, employees.first_name, departments.dept_name
FROM employees
JOIN dept_emp ON employees.emp_no = dept_emp.emp_no
JOIN departments ON dept_emp.dept_no = departments.dept_no
WHERE departments.dept_name IN ('Sales', 'Development');

-- 8) List the frequency counts, in descending order, of all the employee last names (that is, how many employees share each last name).

SELECT last_name, COUNT(*) AS frequency
FROM employees
GROUP BY last_name
ORDER BY frequency DESC;
