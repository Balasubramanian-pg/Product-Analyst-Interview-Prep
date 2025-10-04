Here are a few that trip people up:

1. **Find the 2nd highest salary**

   ```sql
   SELECT MAX(salary)
   FROM employees
   WHERE salary < (SELECT MAX(salary) FROM employees);
   ```

2. **Get employees who earn more than their department’s average**

   ```sql
   SELECT name, salary, dept_id
   FROM employees e
   WHERE salary > (
       SELECT AVG(salary) FROM employees WHERE dept_id = e.dept_id
   );
   ```

3. **Find departments with no employees**

   ```sql
   SELECT dept_name
   FROM departments
   WHERE dept_id NOT IN (SELECT DISTINCT dept_id FROM employees);
   ```

4. **Use subquery in FROM (inline view)**

   ```sql
   SELECT dept_id, AVG(salary)
   FROM (SELECT * FROM employees WHERE active = 1) AS active_emps
   GROUP BY dept_id;
   ```

Would you like me to add real-world business-style ones too, like KPIs or sales-based subqueries?
