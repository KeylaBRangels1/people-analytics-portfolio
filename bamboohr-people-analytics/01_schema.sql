
-- ============================================================
-- BambooHR-Inspired HR Dataset — Schema
-- ============================================================
-- Structure mirrors common BambooHR export fields and typical
-- HRIS data warehouse patterns (e.g. BambooHR → BigQuery/Snowflake).
-- Used for People Analytics queries: headcount, attrition, compensation.
-- Author: Keyla Rangel Santana | People Systems & HRIS Specialist
-- ============================================================

-- Departments
CREATE TABLE departments (
    department_id   INT PRIMARY KEY,
    department_name VARCHAR(100) NOT NULL,
    location        VARCHAR(100)          -- e.g. 'Remote', 'Berlin', 'London'
);

-- Employees (core table — mirrors BambooHR employee record export)
CREATE TABLE employees (
    employee_id       INT PRIMARY KEY,
    full_name         VARCHAR(150) NOT NULL,
    email             VARCHAR(150),
    hire_date         DATE         NOT NULL,
    termination_date  DATE,                   -- NULL = active employee
    termination_type  VARCHAR(50),            -- 'Voluntary', 'Involuntary', NULL
    department_id     INT REFERENCES departments(department_id),
    job_title         VARCHAR(150),
    employment_type   VARCHAR(50),            -- 'Full-Time', 'Part-Time', 'Contractor'
    location          VARCHAR(100),
    manager_id        INT REFERENCES employees(employee_id)
);

-- Salary history (mirrors BambooHR compensation table export)
CREATE TABLE salary_history (
    salary_id      INT PRIMARY KEY,
    employee_id    INT REFERENCES employees(employee_id),
    effective_date DATE         NOT NULL,
    salary_amount  DECIMAL(10,2) NOT NULL,
    currency       VARCHAR(10)  DEFAULT 'EUR',
    pay_frequency  VARCHAR(20),              -- 'Annual', 'Monthly'
    change_reason  VARCHAR(100)              -- 'New Hire', 'Merit Increase', 'Promotion', 'Adjustment'
);

-- Job history (tracks role/department changes — from BambooHR job info tab)
CREATE TABLE job_history (
    job_history_id  INT PRIMARY KEY,
    employee_id     INT REFERENCES employees(employee_id),
    effective_date  DATE        NOT NULL,
    department_id   INT REFERENCES departments(department_id),
    job_title       VARCHAR(150),
    change_type     VARCHAR(50)             -- 'New Hire', 'Transfer', 'Promotion', 'Demotion'
);
