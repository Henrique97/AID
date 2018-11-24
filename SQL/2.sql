/*
all_employees(emp_no, birth_date, first_name, last_name, gender, hire_date, title, report_to)
all_departments(dept_no, dept_name)
all_dept_emp(emp_no, dept_no, from_date, to_date)
*/

-- Auxiliar views
create or replace view employees.curr_dept_emp(emp_no, dept_no, from_date, to_date) as
    select emp_no, dept_no, from_date, to_date
    from employees.dept_emp
    where from_date <= current_date and to_date >= current_date;

create or replace view employees.curr_dept_manager(emp_no, dept_no) as
    select emp_no, dept_no
    from employees.dept_manager
    where from_date <= current_date and to_date >= current_date;

create or replace view adventureworks.curr_dept_emp(EmployeeID, DepartmentID, ShiftID, StartDate, EndDate, ModifiedDate) as
    select EmployeeID, DepartmentID, ShiftID, StartDate, EndDate, ModifiedDate
    from adventureworks.employeedepartmenthistory
    where StartDate <= current_date and (EndDate is NULL or EndDate >= current_date);

-- Main views
-- The maximum emp_no from adventureworks is 290 and the minimum from employees is 10721, so there's no overlap
create or replace view all_employees(emp_no, birth_date, first_name, last_name, gender, hire_date, title, report_to) as
    (select a.emp_no, a.birth_date, a.first_name, a.last_name, a.gender, a.hire_date, d.title, c.emp_no as report_to
    from employees.employees as a,
        employees.curr_dept_emp as b,
        employees.curr_dept_manager as c,
        employees.titles as d
    where a.emp_no = b.emp_no and b.dept_no = c.dept_no
        and a.emp_no = d.emp_no)
    union
    (select a.EmployeeID, a.BirthDate, b.FirstName, b.LastName, a.Gender, a.HireDate, a.Title, a.ManagerID
    from adventureworks.employee as a,
        adventureworks.contact as b
    where a.ContactID = b.ContactID);

-- dept_no's from adventureworks are numeric and dept_no's from employees have a "d" prefix, so there's no overlap
create or replace view all_departments(dept_no, dept_name) as
    (select dept_no, dept_name from employees.departments)
    union
    (select DepartmentID, Name from adventureworks.department);

create or replace view all_dept_emp(emp_no, dept_no, from_date, to_date) as
    (select emp_no, dept_no, from_date, to_date from employees.curr_dept_emp)
    union
    (select EmployeeID, DepartmentID, StartDate, EndDate from adventureworks.curr_dept_emp);


-- Test
/*
select * from all_employees;
select * from all_departments;
select * from all_dept_emp;
*/
