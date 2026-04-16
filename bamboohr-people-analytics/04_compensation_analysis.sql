-- ============================================================
-- People Analytics — Compensation Analysis Queries
-- ============================================================
-- Based on BambooHR export structure (salary_history table).
-- Covers: current salary distribution, pay bands by level,
--         salary growth, gender pay gap proxy, compa-ratio.
-- Author: Keyla Rangel Santana | People Systems & HRIS Specialist
-- ============================================================


-- ------------------------------------------------------------
-- 1. CURRENT SALARY PER ACTIVE EMPLOYEE
-- ------------------------------------------------------------
-- Uses a subquery to get only the most recent salary record
-- per employee (latest effective_date). Excludes terminated employees.
-- ------------------------------------------------------------

WITH latest_salary AS (
    SELECT DISTINCT ON (employee_id)
        employee_id,
        salary_amount,
        effective_date,
        change_reason
    FROM salary_history
    ORDER BY employee_id, effective_date DESC
)
SELECT
    e.employee_id,
    e.full_name,
    e.job_title,
    d.department_name,
    ls.salary_amount          AS current_salary_eur,
    ls.effective_date         AS salary_since,
    ls.change_reason          AS last_change_reason
FROM employees e
JOIN departments d    ON e.department_id = d.department_id
JOIN latest_salary ls ON e.employee_id   = ls.employee_id
WHERE e.termination_date IS NULL
ORDER BY ls.salary_amount DESC;


-- ------------------------------------------------------------
-- 2. SALARY DISTRIBUTION BY DEPARTMENT
-- ------------------------------------------------------------
-- Min, max, average and median salary per department.
-- Identifies pay spread and outliers within teams.
-- ------------------------------------------------------------

WITH latest_salary AS (
    SELECT DISTINCT ON (employee_id)
        employee_id,
        salary_amount
    FROM salary_history
    ORDER BY employee_id, effective_date DESC
)
SELECT
    d.department_name,
    COUNT(e.employee_id)                        AS headcount,
    MIN(ls.salary_amount)                       AS min_salary,
    MAX(ls.salary_amount)                       AS max_salary,
    ROUND(AVG(ls.salary_amount), 0)             AS avg_salary,
    ROUND(PERCENTILE_CONT(0.5)
        WITHIN GROUP (ORDER BY ls.salary_amount)::DECIMAL, 0) AS median_salary
FROM employees e
JOIN departments d    ON e.department_id = d.department_id
JOIN latest_salary ls ON e.employee_id   = ls.employee_id
WHERE e.termination_date IS NULL
GROUP BY d.department_name
ORDER BY avg_salary DESC;


-- ------------------------------------------------------------
-- 3. SALARY BANDS BY JOB LEVEL
-- ------------------------------------------------------------
-- Groups job titles into levels (Junior / Mid / Senior / Lead/Manager)
-- using pattern matching. Shows pay spread per level.
-- Useful for auditing pay equity across levels.
-- ------------------------------------------------------------

WITH latest_salary AS (
    SELECT DISTINCT ON (employee_id)
        employee_id,
        salary_amount
    FROM salary_history
    ORDER BY employee_id, effective_date DESC
),
leveled AS (
    SELECT
        e.employee_id,
        e.job_title,
        ls.salary_amount,
        CASE
            WHEN e.job_title ILIKE '%Manager%'
              OR e.job_title ILIKE '%Lead%'     THEN '4 - Manager / Lead'
            WHEN e.job_title ILIKE '%Senior%'   THEN '3 - Senior'
            WHEN e.job_title ILIKE '%Junior%'   THEN '1 - Junior'
            ELSE                                     '2 - Mid'
        END AS job_level
    FROM employees e
    JOIN latest_salary ls ON e.employee_id = ls.employee_id
    WHERE e.termination_date IS NULL
)
SELECT
    job_level,
    COUNT(*)                            AS headcount,
    MIN(salary_amount)                  AS band_min,
    MAX(salary_amount)                  AS band_max,
    ROUND(AVG(salary_amount), 0)        AS avg_salary,
    ROUND(PERCENTILE_CONT(0.5)
        WITHIN GROUP (ORDER BY salary_amount)::DECIMAL, 0) AS median_salary
FROM leveled
GROUP BY job_level
ORDER BY job_level;


-- ------------------------------------------------------------
-- 4. SALARY INCREASE HISTORY PER EMPLOYEE
-- ------------------------------------------------------------
-- Shows each salary change, the amount and % increase,
-- and the reason. Uses LAG() window function to compare
-- current salary with previous record.
-- ------------------------------------------------------------

SELECT
    e.full_name,
    e.job_title,
    d.department_name,
    sh.effective_date,
    sh.change_reason,
    sh.salary_amount                                          AS new_salary,
    LAG(sh.salary_amount) OVER (
        PARTITION BY sh.employee_id
        ORDER BY sh.effective_date
    )                                                         AS previous_salary,
    sh.salary_amount - LAG(sh.salary_amount) OVER (
        PARTITION BY sh.employee_id
        ORDER BY sh.effective_date
    )                                                         AS increase_amount,
    ROUND(
        (sh.salary_amount - LAG(sh.salary_amount) OVER (
            PARTITION BY sh.employee_id
            ORDER BY sh.effective_date
        )) / NULLIF(LAG(sh.salary_amount) OVER (
            PARTITION BY sh.employee_id
            ORDER BY sh.effective_date
        ), 0) * 100,
    1)                                                        AS increase_pct
FROM salary_history sh
JOIN employees   e ON sh.employee_id   = e.employee_id
JOIN departments d ON e.department_id  = d.department_id
ORDER BY e.full_name, sh.effective_date;


-- ------------------------------------------------------------
-- 5. EMPLOYEES WITHOUT A SALARY REVIEW IN 18+ MONTHS
-- ------------------------------------------------------------
-- Flags active employees whose last salary change was
-- more than 18 months ago. Input for compensation review cycles.
-- ------------------------------------------------------------

WITH latest_salary AS (
    SELECT DISTINCT ON (employee_id)
        employee_id,
        salary_amount,
        effective_date
    FROM salary_history
    ORDER BY employee_id, effective_date DESC
)
SELECT
    e.employee_id,
    e.full_name,
    e.job_title,
    d.department_name,
    ls.salary_amount          AS current_salary_eur,
    ls.effective_date         AS last_review_date,
    DATE_PART('month', AGE(CURRENT_DATE, ls.effective_date))::INT
                              AS months_since_review
FROM employees e
JOIN departments d    ON e.department_id = d.department_id
JOIN latest_salary ls ON e.employee_id   = ls.employee_id
WHERE e.termination_date IS NULL
  AND ls.effective_date < CURRENT_DATE - INTERVAL '18 months'
ORDER BY months_since_review DESC;


-- ------------------------------------------------------------
-- 6. COMPA-RATIO BY DEPARTMENT
-- ------------------------------------------------------------
-- Compa-ratio = employee salary / department midpoint salary.
-- Ratio < 0.9  → underpaid vs peers
-- Ratio 0.9–1.1 → within band
-- Ratio > 1.1  → above band
-- ------------------------------------------------------------

WITH latest_salary AS (
    SELECT DISTINCT ON (employee_id)
        employee_id,
        salary_amount
    FROM salary_history
    ORDER BY employee_id, effective_date DESC
),
dept_midpoint AS (
    SELECT
        e.department_id,
        AVG(ls.salary_amount) AS midpoint
    FROM employees e
    JOIN latest_salary ls ON e.employee_id = ls.employee_id
    WHERE e.termination_date IS NULL
    GROUP BY e.department_id
)
SELECT
    e.full_name,
    e.job_title,
    d.department_name,
    ls.salary_amount                                           AS salary,
    ROUND(dm.midpoint, 0)                                      AS dept_midpoint,
    ROUND(ls.salary_amount / NULLIF(dm.midpoint, 0), 2)        AS compa_ratio,
    CASE
        WHEN ls.salary_amount / NULLIF(dm.midpoint, 0) < 0.90  THEN 'Below Band'
        WHEN ls.salary_amount / NULLIF(dm.midpoint, 0) > 1.10  THEN 'Above Band'
        ELSE 'Within Band'
    END                                                        AS band_position
FROM employees e
JOIN departments d    ON e.department_id  = d.department_id
JOIN latest_salary ls ON e.employee_id    = ls.employee_id
JOIN dept_midpoint dm ON e.department_id  = dm.department_id
WHERE e.termination_date IS NULL
ORDER BY compa_ratio ASC;
