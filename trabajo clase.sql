INSERT INTO employees (
    employee_id,
    first_name,
    last_name,
    email,
    phone_number,
    hire_date,
    job_id,
    salary,
    commission_pct,
    manager_id,
    department_id
)
SELECT
    1000 + LEVEL AS employee_id,
    'Nombre' || LEVEL AS first_name,
    'Apellido' || LEVEL AS last_name,
    'EMP' || LEVEL AS email, -- UNIQUE garantizado
    '300-555-' || LPAD(LEVEL,4,'0') AS phone_number,
    DATE '2020-01-01' + MOD(LEVEL, 365) AS hire_date,
    'IT_PROG' AS job_id,
    3000 + MOD(LEVEL, 7000) AS salary, -- Siempre > 0
    NULL AS commission_pct,
    100 AS manager_id,
    10 AS department_id
FROM dual
CONNECT BY LEVEL <= 5000;

COMMIT;

INSERT INTO pay_concepts (
    code,
    name,
    concept_type,
    calc_method,
    default_rate,
    is_active
)
SELECT
    'CONC' || LEVEL AS code,
    'Concepto Nómina ' || LEVEL AS name,
    CASE 
        WHEN MOD(LEVEL,2) = 0 THEN 'DEVENGO'
        ELSE 'DEDUCCION'
    END AS concept_type,
    CASE MOD(LEVEL,5)
        WHEN 0 THEN 'FIJO'
        WHEN 1 THEN 'PORCENTAJE'
        WHEN 2 THEN 'POR_HORA'
        WHEN 3 THEN 'POR_DIA'
         ELSE 'FIJO'
    END AS calc_method,
    ROUND(DBMS_RANDOM.VALUE(1,50),2) AS default_rate,
    'Y' AS is_active
FROM dual
CONNECT BY LEVEL <= 80;

COMMIT;

SELECT * FROM pay_concepts


