There are mainly **three types** of subqueries, based on where they appear:

1. **Single-row subquery** → returns one value

   ```sql
   SELECT name FROM employees 
   WHERE salary = (SELECT MAX(salary) FROM employees);
   ```

2. **Multi-row subquery** → returns multiple values

   ```sql
   SELECT name FROM employees 
   WHERE dept_id IN (SELECT dept_id FROM departments WHERE location = 'NY');
   ```

3. **Correlated subquery** → runs once per row of outer query

   ```sql
   SELECT name 
   FROM employees e
   WHERE salary > (
       SELECT AVG(salary) FROM employees WHERE dept_id = e.dept_id
   );
   ```

You might also hear **inline views** (subquery in `FROM`) and **scalar subqueries** (returning one value anywhere in a statement).
