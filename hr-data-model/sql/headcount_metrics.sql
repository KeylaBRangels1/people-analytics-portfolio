-- Headcount by department (current snapshot)

SELECT
  department,
  COUNT(employee_id) AS headcount
FROM workforce_snapshot
WHERE snapshot_date = CURRENT_DATE
GROUP BY department
ORDER BY headcount DESC;
