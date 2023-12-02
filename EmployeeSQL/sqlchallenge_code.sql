CREATE TABLE departments (
	dept_no VARCHAR(4) NOT NULL,
	dept_name VARCHAR(20),
	PRIMARY KEY (dept_no)
);

CREATE TABLE titles(
	title_id VARCHAR(5) NOT NULL,
	title VARCHAR(20),
	PRIMARY KEY (title_id)
);

CREATE TABLE employees(
	emp_no INT NOT NULL,
	emp_title_id VARCHAR(5),
	birth_date VARCHAR(10),
	first_name VARCHAR(35),
	last_name VARCHAR(35),
	sex VARCHAR(1),
	hire_date VARCHAR(10),
	PRIMARY KEY (emp_no),
	FOREIGN KEY (emp_title_id) REFERENCES titles(title_id)
);

CREATE TABLE dept_manager(
	dept_no VARCHAR(4),
	emp_no INT NOT NULL,
	PRIMARY KEY (emp_no),
	FOREIGN KEY (emp_no) REFERENCES employees(emp_no),
	FOREIGN KEY (dept_no) REFERENCES departments(dept_no)
);

CREATE TABLE salaries(
	emp_no INT NOT NULL,
	salary INT,
	PRIMARY KEY (emp_no),
	FOREIGN KEY (emp_no) REFERENCES employees(emp_no)
);

CREATE TABLE dept_emp(
	emp_no INT NOT NULL,
	dept_no VARCHAR(4),
	PRIMARY KEY (emp_no,dept_no),
	FOREIGN KEY (emp_no) REFERENCES employees(emp_no),
	FOREIGN KEY (dept_no) REFERENCES departments(dept_no)
);

/* 1. Employee number, last name, first name, sex, and salary of each employee */
SELECT employees.emp_no, employees.last_name, employees.first_name, employees.sex, salaries.salary
FROM employees
JOIN salaries
  ON employees.emp_no = salaries.emp_no;


/* 2. First name, last name, and hire date for employees who were hired in 1986 */
SELECT first_name, last_name, hire_date
FROM employees
WHERE RIGHT(hire_date, 4) = '1986';

/* 3. Manager of each department along with their department number, department name, employee number, last name, and first name */
SELECT dept_manager.dept_no, departments.dept_name, dept_manager.emp_no, employees.last_name, employees.first_name
FROM dept_manager
JOIN departments
  ON dept_manager.dept_no = departments.dept_no
JOIN employees
  ON dept_manager.emp_no = employees.emp_no;

/* 4. Department number for each employee along with that employee's employee number, last name, first name, and department name */
SELECT dept_emp.dept_no, dept_emp.emp_no, employees.last_name, employees.first_name, departments.dept_name
FROM dept_emp
JOIN employees
  ON dept_emp.emp_no = employees.emp_no
JOIN departments
  ON dept_emp.dept_no = departments.dept_no;

/* 5. First name, last name, and sex of each employee whose first name is Hercules and whose last name begins with the letter B */
SELECT first_name, last_name, sex
FROM employees
WHERE first_name = 'Hercules' AND last_name LIKE 'B%';

/* 6. each employee in the Sales department, including their employee number, last name, and first name */
SELECT emp_no, last_name, first_name
FROM employees
WHERE emp_no IN(
	SELECT emp_no
	FROM dept_emp
	WHERE dept_no IN (
		SELECT dept_no
		FROM departments
		WHERE dept_name = 'Sales'
	)
);

/* 7. Each employee in the Sales and Development departments, including their employee number, last name, first name, and department name */
SELECT dept_emp.emp_no, employees.last_name, employees.first_name, departments.dept_name
FROM dept_emp
JOIN employees
  ON dept_emp.emp_no = employees.emp_no
JOIN departments
  ON dept_emp.dept_no = departments.dept_no
WHERE dept_emp.dept_no IN (
	SELECT dept_no
	FROM departments
	WHERE dept_name = 'Sales' OR dept_name = 'Development'
);

/* 8. the frequency counts, in descending order, of all the employee last names */
SELECT last_name, COUNT(last_name) AS "count"
FROM employees
GROUP BY last_name
ORDER BY "count" DESC;