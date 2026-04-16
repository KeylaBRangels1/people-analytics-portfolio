
-- ============================================================
-- Sample Data — BambooHR-Inspired HR Dataset
-- ============================================================
-- Realistic fictional data for a ~60-person remote-first tech company.
-- Covers 2022–2024 to allow meaningful trend analysis.
-- ============================================================

-- DEPARTMENTS
INSERT INTO departments VALUES
(1, 'Engineering',       'Remote'),
(2, 'People & Culture',  'Remote'),
(3, 'Sales',             'Remote'),
(4, 'Finance',           'Berlin'),
(5, 'Product',           'Remote'),
(6, 'Customer Success',  'Remote');

-- EMPLOYEES
-- Active employees
INSERT INTO employees VALUES
(1,  'Amara Osei',         'amara.osei@company.com',         '2021-03-01', NULL,         NULL,          1, 'Senior Software Engineer',        'Full-Time',  'Remote',  NULL),
(2,  'Lucas Ferreira',     'lucas.ferreira@company.com',     '2021-06-15', NULL,         NULL,          1, 'Engineering Manager',             'Full-Time',  'Remote',  NULL),
(3,  'Sophie Müller',      'sophie.muller@company.com',      '2022-01-10', NULL,         NULL,          2, 'People Systems Specialist',       'Full-Time',  'Remote',  NULL),
(4,  'Tomás Herrera',      'tomas.herrera@company.com',      '2022-03-01', NULL,         NULL,          3, 'Account Executive',               'Full-Time',  'Remote',  NULL),
(5,  'Yuki Tanaka',        'yuki.tanaka@company.com',        '2022-04-15', NULL,         NULL,          5, 'Product Manager',                 'Full-Time',  'Remote',  2),
(6,  'Fatima Al-Rashid',   'fatima.alrashid@company.com',    '2022-07-01', NULL,         NULL,          1, 'Software Engineer',               'Full-Time',  'Remote',  2),
(7,  'Piotr Kowalski',     'piotr.kowalski@company.com',     '2022-09-01', NULL,         NULL,          4, 'Financial Analyst',               'Full-Time',  'Berlin',  NULL),
(8,  'Isla MacLeod',       'isla.macleod@company.com',       '2022-10-15', NULL,         NULL,          6, 'Customer Success Manager',        'Full-Time',  'Remote',  NULL),
(9,  'Chidi Okafor',       'chidi.okafor@company.com',       '2023-01-16', NULL,         NULL,          1, 'Software Engineer',               'Full-Time',  'Remote',  2),
(10, 'Elena Vasquez',      'elena.vasquez@company.com',      '2023-02-01', NULL,         NULL,          5, 'Senior Product Manager',          'Full-Time',  'Remote',  NULL),
(11, 'Marcus Webb',        'marcus.webb@company.com',        '2023-03-01', NULL,         NULL,          3, 'Sales Development Rep',           'Full-Time',  'Remote',  NULL),
(12, 'Priya Nair',         'priya.nair@company.com',         '2023-04-03', NULL,         NULL,          2, 'HR Operations Manager',           'Full-Time',  'Remote',  3),
(13, 'Johan Lindqvist',    'johan.lindqvist@company.com',    '2023-05-15', NULL,         NULL,          1, 'DevOps Engineer',                 'Full-Time',  'Remote',  2),
(14, 'Aisha Diallo',       'aisha.diallo@company.com',       '2023-07-01', NULL,         NULL,          6, 'Customer Success Specialist',     'Full-Time',  'Remote',  8),
(15, 'Ravi Sharma',        'ravi.sharma@company.com',        '2023-09-01', NULL,         NULL,          1, 'Junior Software Engineer',        'Full-Time',  'Remote',  2),
(16, 'Clara Fontaine',     'clara.fontaine@company.com',     '2023-10-02', NULL,         NULL,          4, 'Senior Financial Analyst',        'Full-Time',  'Berlin',  NULL),
(17, 'Ngozi Eze',          'ngozi.eze@company.com',          '2024-01-15', NULL,         NULL,          3, 'Account Executive',               'Full-Time',  'Remote',  NULL),
(18, 'Daniel Park',        'daniel.park@company.com',        '2024-02-01', NULL,         NULL,          1, 'Software Engineer',               'Full-Time',  'Remote',  2),
(19, 'Beatriz Lopes',      'beatriz.lopes@company.com',      '2024-03-01', NULL,         NULL,          5, 'Product Analyst',                 'Full-Time',  'Remote',  10),
(20, 'Mikael Björk',       'mikael.bjork@company.com',       '2024-04-01', NULL,         NULL,          2, 'People Operations Specialist',    'Full-Time',  'Remote',  12),

-- Terminated employees
(21, 'James Thornton',     'james.thornton@company.com',     '2022-02-01', '2022-11-30', 'Voluntary',   3, 'Account Executive',               'Full-Time',  'Remote',  NULL),
(22, 'Nadia Petrov',       'nadia.petrov@company.com',       '2022-05-01', '2023-03-31', 'Voluntary',   1, 'Software Engineer',               'Full-Time',  'Remote',  2),
(23, 'Omar Farouk',        'omar.farouk@company.com',        '2022-08-15', '2023-06-30', 'Involuntary', 6, 'Customer Success Specialist',     'Full-Time',  'Remote',  8),
(24, 'Sarah Collins',      'sarah.collins@company.com',      '2021-11-01', '2023-08-31', 'Voluntary',   2, 'HR Generalist',                   'Full-Time',  'Remote',  NULL),
(25, 'Kwame Asante',       'kwame.asante@company.com',       '2023-02-01', '2023-12-31', 'Voluntary',   4, 'Finance Manager',                 'Full-Time',  'Berlin',  NULL),
(26, 'Lena Hoffmann',      'lena.hoffmann@company.com',      '2023-04-01', '2024-01-31', 'Voluntary',   1, 'Senior Software Engineer',        'Full-Time',  'Remote',  2),
(27, 'Carlos Mendez',      'carlos.mendez@company.com',      '2023-06-01', '2024-03-31', 'Involuntary', 3, 'Sales Development Rep',           'Full-Time',  'Remote',  NULL),
(28, 'Anna Johansson',     'anna.johansson@company.com',     '2022-11-01', '2024-06-30', 'Voluntary',   5, 'Product Manager',                 'Full-Time',  'Remote',  NULL);

-- SALARY HISTORY
INSERT INTO salary_history VALUES
-- Active employees — current salary
(1,  1,  '2021-03-01', 72000,  'EUR', 'Annual', 'New Hire'),
(2,  1,  '2023-01-01', 78000,  'EUR', 'Annual', 'Merit Increase'),
(3,  2,  '2021-06-15', 90000,  'EUR', 'Annual', 'New Hire'),
(4,  2,  '2023-06-01', 98000,  'EUR', 'Annual', 'Promotion'),
(5,  3,  '2022-01-10', 58000,  'EUR', 'Annual', 'New Hire'),
(6,  3,  '2024-01-01', 63000,  'EUR', 'Annual', 'Merit Increase'),
(7,  4,  '2022-03-01', 55000,  'EUR', 'Annual', 'New Hire'),
(8,  4,  '2024-01-01', 60000,  'EUR', 'Annual', 'Merit Increase'),
(9,  5,  '2022-04-15', 82000,  'EUR', 'Annual', 'New Hire'),
(10, 6,  '2022-07-01', 62000,  'EUR', 'Annual', 'New Hire'),
(11, 6,  '2024-01-01', 67000,  'EUR', 'Annual', 'Merit Increase'),
(12, 7,  '2022-09-01', 60000,  'EUR', 'Annual', 'New Hire'),
(13, 8,  '2022-10-15', 65000,  'EUR', 'Annual', 'New Hire'),
(14, 8,  '2023-10-01', 70000,  'EUR', 'Annual', 'Merit Increase'),
(15, 9,  '2023-01-16', 64000,  'EUR', 'Annual', 'New Hire'),
(16, 10, '2023-02-01', 88000,  'EUR', 'Annual', 'New Hire'),
(17, 11, '2023-03-01', 48000,  'EUR', 'Annual', 'New Hire'),
(18, 12, '2023-04-03', 72000,  'EUR', 'Annual', 'New Hire'),
(19, 13, '2023-05-15', 75000,  'EUR', 'Annual', 'New Hire'),
(20, 14, '2023-07-01', 52000,  'EUR', 'Annual', 'New Hire'),
(21, 15, '2023-09-01', 46000,  'EUR', 'Annual', 'New Hire'),
(22, 16, '2023-10-02', 76000,  'EUR', 'Annual', 'New Hire'),
(23, 17, '2024-01-15', 62000,  'EUR', 'Annual', 'New Hire'),
(24, 18, '2024-02-01', 65000,  'EUR', 'Annual', 'New Hire'),
(25, 19, '2024-03-01', 54000,  'EUR', 'Annual', 'New Hire'),
(26, 20, '2024-04-01', 55000,  'EUR', 'Annual', 'New Hire'),
-- Terminated employees — last salary on record
(27, 21, '2022-02-01', 54000,  'EUR', 'Annual', 'New Hire'),
(28, 22, '2022-05-01', 62000,  'EUR', 'Annual', 'New Hire'),
(29, 23, '2022-08-15', 48000,  'EUR', 'Annual', 'New Hire'),
(30, 24, '2021-11-01', 52000,  'EUR', 'Annual', 'New Hire'),
(31, 25, '2023-02-01', 85000,  'EUR', 'Annual', 'New Hire'),
(32, 26, '2023-04-01', 74000,  'EUR', 'Annual', 'New Hire'),
(33, 27, '2023-06-01', 46000,  'EUR', 'Annual', 'New Hire'),
(34, 28, '2022-11-01', 80000,  'EUR', 'Annual', 'New Hire');

-- JOB HISTORY
INSERT INTO job_history VALUES
(1,  1,  '2021-03-01', 1, 'Software Engineer',           'New Hire'),
(2,  1,  '2023-01-01', 1, 'Senior Software Engineer',    'Promotion'),
(3,  2,  '2021-06-15', 1, 'Senior Software Engineer',    'New Hire'),
(4,  2,  '2023-06-01', 1, 'Engineering Manager',         'Promotion'),
(5,  3,  '2022-01-10', 2, 'People Systems Specialist',   'New Hire'),
(6,  5,  '2022-04-15', 5, 'Product Manager',             'New Hire'),
(7,  8,  '2022-10-15', 6, 'Customer Success Specialist', 'New Hire'),
(8,  8,  '2023-10-01', 6, 'Customer Success Manager',    'Promotion'),
(9,  10, '2023-02-01', 5, 'Product Manager',             'New Hire'),
(10, 10, '2023-09-01', 5, 'Senior Product Manager',      'Promotion');
