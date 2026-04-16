
-- ============================================================
-- People Analytics — Headcount & Attrition Queries
-- ============================================================
-- Based on BambooHR export structure.
-- Covers: active headcount, monthly trends, attrition rate,
--         voluntary vs involuntary breakdown, attrition by department.
-- Author: Keyla Rangel Santana | People Systems & HRIS Specialist
-- ============================================================


-- ------------------------------------------------------------
-- 1. CURRENT ACTIVE HEADCOUNT BY DEPARTMENT
-- ------------------------------------------------------------
-- Counts employees with no termination date (active),
-- grouped by department. Baseline metric for any People dashboard.
-- ------------------------------------------------------------

SELECT
    d.department_name,
    COUNT(e.employee_id)    AS headcount,
    COUNT(CASE WHEN e.employment_type = 'Full-Time'  THEN 1 END) AS full_time,
    COUNT(CASE WHEN e.employment_type = 'Part-Time'  THEN 1 END) AS part_time,
    COUNT(CASE WHEN e.employment_type = 'Contractor' THEN 1 END) AS contractors
FROM employees e
JOIN departments d ON e.department_id = d.department_id
WHERE e.termination_date IS NULL
GROUP BY d.department_name
ORDER BY headcount DESC;


-- ------------------------------------------------------------
-- 2. MONTHLY HEADCOUNT TREND (2023–2024)
-- ------------------------------------------------------------
-- Reconstructs point-in-time headcount for each month:
-- an employee is counted if they were hired before month-end
-- and either still active or terminated after month-end.
-- Useful for tracking org growth over time.
-- ------------------------------------------------------------

WITH months AS (
    SELECT DATE_TRUNC('month', d)::DATE AS month_start
    FROM GENERATE_SERIES(
        '2023-01-01'::DATE,
        '2024-12-01'::DATE,
        INTERVAL '1 month'
    ) AS d
)
SELECT
    TO_CHAR(m.month_start, 'YYYY-MM')  AS month,
    COUNT(e.employee_id)               AS headcount
FROM months m
JOIN employees e
    ON e.hire_date <= (m.month_start + INTERVAL '1 month - 1 day')::DATE
    AND (
        e.termination_date IS NULL
        OR e.termination_date > (m.month_start + INTERVAL '1 month - 1 day')::DATE
    )
GROUP BY m.month_start
ORDER BY m.month_start;


-- ------------------------------------------------------------
-- 3. ANNUAL ATTRITION RATE BY YEAR
-- ------------------------------------------------------------
-- Standard formula: terminations in period / avg headcount × 100.
-- Avg headcount = (headcount at start + headcount at end) / 2.
-- Splits voluntary vs involuntary exits.
-- ------------------------------------------------------------

WITH yearly_data AS (
    SELECT
        EXTRACT(YEAR FROM termination_date)  AS year,
        COUNT(*)                             AS total_exits,
        COUNT(CASE WHEN termination_type = 'Voluntary'   THEN 1 END) AS voluntary_exits,
        COUNT(CASE WHEN termination_type = 'Involuntary' THEN 1 END) AS involuntary_exits
    FROM employees
    WHERE termination_date IS NOT NULL
    GROUP BY EXTRACT(YEAR FROM termination_date)
),
headcount_start AS (
    SELECT
        EXTRACT(YEAR FROM hire_date)  AS year,
        COUNT(*)                      AS hires_in_year
    FROM employees
    GROUP BY EXTRACT(YEAR FROM hire_date)
)
SELECT
    y.year::INT,
    y.total_exits,
    y.voluntary_exits,
    y.involuntary_exits,
    ROUND(
        y.total_exits::DECIMAL
        / NULLIF(h.hires_in_year, 0) * 100,
    1) AS attrition_rate_pct
FROM yearly_data y
LEFT JOIN headcount_start h ON y.year = h.year
ORDER BY y.year;


-- ------------------------------------------------------------
-- 4. ATTRITION BY DEPARTMENT (ALL TIME)
-- ------------------------------------------------------------
-- Shows which departments have the highest turnover.
-- Includes total headcount (ever employed) for context.
-- ------------------------------------------------------------

SELECT
    d.department_name,
    COUNT(e.employee_id)                                        AS total_ever_employed,
    COUNT(CASE WHEN e.termination_date IS NOT NULL THEN 1 END)  AS total_exits,
    COUNT(CASE WHEN e.termination_type = 'Voluntary'   THEN 1 END) AS voluntary,
    COUNT(CASE WHEN e.termination_type = 'Involuntary' THEN 1 END) AS involuntary,
    ROUND(
        COUNT(CASE WHEN e.termination_date IS NOT NULL THEN 1 END)::DECIMAL
        / COUNT(e.employee_id) * 100,
    1) AS attrition_rate_pct
FROM employees e
JOIN departments d ON e.department_id = d.department_id
GROUP BY d.department_name
ORDER BY attrition_rate_pct DESC;


-- ------------------------------------------------------------
-- 5. AVERAGE TENURE AT TERMINATION (BY DEPARTMENT)
-- ------------------------------------------------------------
-- How long, on average, did employees stay before leaving?
-- Useful for identifying retention risk by team.
-- ------------------------------------------------------------

SELECT
    d.department_name,
    COUNT(e.employee_id)                        AS exits,
    ROUND(AVG(
        EXTRACT(DAY FROM (e.termination_date - e.hire_date)) / 365.0
    ), 1)                                       AS avg_tenure_years,
    MIN(ROUND(
        EXTRACT(DAY FROM (e.termination_date - e.hire_date)) / 365.0, 1
    ))                                          AS min_tenure_years,
    MAX(ROUND(
        EXTRACT(DAY FROM (e.termination_date - e.hire_date)) / 365.0, 1
    ))                                          AS max_tenure_years
FROM employees e
JOIN departments d ON e.department_id = d.department_id
WHERE e.termination_date IS NOT NULL
GROUP BY d.department_name
HAVING COUNT(e.employee_id) >= 1
ORDER BY avg_tenure_years ASC;


-- ------------------------------------------------------------
-- 6. NEW HIRES VS EXITS PER QUARTER (2023–2024)
-- ------------------------------------------------------------
-- Compares hiring pace against attrition pace per quarter.
-- Net change = hires - exits. Negative = org is shrinking.
-- ------------------------------------------------------------

WITH quarters AS (
    SELECT
        TO_CHAR(hire_date, 'YYYY-"Q"Q')       AS quarter,
        COUNT(*)                               AS new_hires
    FROM employees
    WHERE hire_date BETWEEN '2023-01-01' AND '2024-12-31'
    GROUP BY TO_CHAR(hire_date, 'YYYY-"Q"Q')
),
exits AS (
    SELECT
        TO_CHAR(termination_date, 'YYYY-"Q"Q') AS quarter,
        COUNT(*)                                AS total_exits
    FROM employees
    WHERE termination_date BETWEEN '2023-01-01' AND '2024-12-31'
    GROUP BY TO_CHAR(termination_date, 'YYYY-"Q"Q')
)
SELECT
    COALESCE(q.quarter, e.quarter)  AS quarter,
    COALESCE(q.new_hires, 0)        AS new_hires,
    COALESCE(e.total_exits, 0)      AS exits,
    COALESCE(q.new_hires, 0) - COALESCE(e.total_exits, 0) AS net_change
FROM quarters q
FULL OUTER JOIN exits e ON q.quarter = e.quarter
ORDER BY quarter;
