BEGIN
  INSERT INTO regions VALUES
      ( 10
      , 'Europe'
      );

  INSERT INTO regions VALUES
      ( 20
      , 'Americas'
      );

  INSERT INTO regions VALUES
      ( 30
      , 'Asia'
      );

  INSERT INTO regions VALUES
      ( 40
      , 'Oceania'
      );

  INSERT INTO regions VALUES
      ( 50
      , 'Africa'
      );
END;
/

REM *************************** insert data into the COUNTRIES table

Prompt ****** Populating COUNTRIES table ....

BEGIN
  INSERT INTO countries VALUES
      ( 'IT'
      , 'Italy'
      , 10
      );

  INSERT INTO countries VALUES
      ( 'JP'
      , 'Japan'
      , 30
      );

  INSERT INTO countries VALUES
      ( 'US'
      , 'United States of America'
      , 20
      );

  INSERT INTO countries VALUES
      ( 'CA'
      , 'Canada'
      , 20
      );

  INSERT INTO countries VALUES
      ( 'CN'
      , 'China'
      , 30
      );

  INSERT INTO countries VALUES
      ( 'IN'
      , 'India'
      , 30
      );

  INSERT INTO countries VALUES
      ( 'AU'
      , 'Australia'
      , 40
      );

  INSERT INTO countries VALUES
      ( 'ZW'
      , 'Zimbabwe'
      , 50
      );

  INSERT INTO countries VALUES
      ( 'SG'
      , 'Singapore'
      , 30
      );

  INSERT INTO countries VALUES
      ( 'GB'
      , 'United Kingdom of Great Britain and Northern Ireland'
      , 10
      );

  INSERT INTO countries VALUES
      ( 'FR'
      , 'France'
      , 10
      );

  INSERT INTO countries VALUES
      ( 'DE'
      , 'Germany'
      , 10
      );

  INSERT INTO countries VALUES
      ( 'ZM'
      , 'Zambia'
      , 50
      );

  INSERT INTO countries VALUES
      ( 'EG'
      , 'Egypt'
      , 50
      );

  INSERT INTO countries VALUES
      ( 'BR'
      , 'Brazil'
      , 20
      );

  INSERT INTO countries VALUES
      ( 'CH'
      , 'Switzerland'
      , 10
      );

  INSERT INTO countries VALUES
      ( 'NL'
      , 'Netherlands'
      , 10
      );

  INSERT INTO countries VALUES
      ( 'MX'
      , 'Mexico'
      , 20
      );

  INSERT INTO countries VALUES
      ( 'KW'
      , 'Kuwait'
      , 30
      );

  INSERT INTO countries VALUES
      ( 'IL'
      , 'Israel'
      , 30
      );

  INSERT INTO countries VALUES
      ( 'DK'
      , 'Denmark'
      , 10
      );

  INSERT INTO countries VALUES
      ( 'ML'
      , 'Malaysia'
      , 30
      );

  INSERT INTO countries VALUES
      ( 'NG'
      , 'Nigeria'
      , 50
      );

  INSERT INTO countries VALUES
      ( 'AR'
      , 'Argentina'
      , 20
      );

  INSERT INTO countries VALUES
      ( 'BE'
      , 'Belgium'
      , 10
      );
END;
/


REM *************************** insert data into the LOCATIONS table

Prompt ****** Populating LOCATIONS table ....

BEGIN
  INSERT INTO locations VALUES
      ( 1000
      , '1297 Via Cola di Rie'
      , '00989'
      , 'Roma'
      , NULL
      , 'IT'
      );

  INSERT INTO locations VALUES
      ( 1100
      , '93091 Calle della Testa'
      , '10934'
      , 'Venice'
      , NULL
      , 'IT'
      );

  INSERT INTO locations VALUES
      ( 1200
      , '2017 Shinjuku-ku'
      , '1689'
      , 'Tokyo'
      , 'Tokyo Prefecture'
      , 'JP'
      );

  INSERT INTO locations VALUES
      ( 1300
      , '9450 Kamiya-cho'
      , '6823'
      , 'Hiroshima'
      , NULL
      , 'JP'
      );

  INSERT INTO locations VALUES
      ( 1400
      , '2014 Jabberwocky Rd'
      , '26192'
      , 'Southlake'
      , 'Texas'
      , 'US'
      );

  INSERT INTO locations VALUES
      ( 1500
      , '2011 Interiors Blvd'
      , '99236'
      , 'South San Francisco'
      , 'California'
      , 'US'
      );

  INSERT INTO locations VALUES
      ( 1600
      , '2007 Zagora St'
      , '50090'
      , 'South Brunswick'
      , 'New Jersey'
      , 'US'
      );

  INSERT INTO locations VALUES
      ( 1700
      , '2004 Charade Rd'
      , '98199'
      , 'Seattle'
      , 'Washington'
      , 'US'
      );

  INSERT INTO locations VALUES
      ( 1800
      , '147 Spadina Ave'
      , 'M5V 2L7'
      , 'Toronto'
      , 'Ontario'
      , 'CA'
      );

  INSERT INTO locations VALUES
      ( 1900
      , '6092 Boxwood St'
      , 'YSW 9T2'
      , 'Whitehorse'
      , 'Yukon'
      , 'CA'
      );

  INSERT INTO locations VALUES
      ( 2000
      , '40-5-12 Laogianggen'
      , '190518'
      , 'Beijing'
      , NULL
      , 'CN'
      );

  INSERT INTO locations VALUES
      ( 2100
      , '1298 Vileparle (E)'
      , '490231'
      , 'Bombay'
      , 'Maharashtra'
      , 'IN'
      );

  INSERT INTO locations VALUES
      ( 2200
      , '12-98 Victoria Street'
      , '2901'
      , 'Sydney'
      , 'New South Wales'
      , 'AU'
      );

  INSERT INTO locations VALUES
      ( 2300
      , '198 Clementi North'
      , '540198'
      , 'Singapore'
      , NULL
      , 'SG'
      );

  INSERT INTO locations VALUES
      ( 2400
      , '8204 Arthur St'
      , NULL
      , 'London'
      , NULL
      , 'GB'
      );

  INSERT INTO locations VALUES
      ( 2500
      , 'Magdalen Centre, The Oxford Science Park'
      , 'OX9 9ZB'
      , 'Oxford'
      , 'Oxford'
      , 'GB'
      );

  INSERT INTO locations VALUES
      ( 2600
      , '9702 Chester Road'
      , '09629850293'
      , 'Stretford'
      , 'Manchester'
      , 'GB'
      );

  INSERT INTO locations VALUES
      ( 2700
      , 'Schwanthalerstr. 7031'
      , '80925'
      , 'Munich'
      , 'Bavaria'
      , 'DE'
      );

  INSERT INTO locations VALUES
      ( 2800
      , 'Rua Frei Caneca 1360 '
      , '01307-002'
      , 'Sao Paulo'
      , 'Sao Paulo'
      , 'BR'
      );

  INSERT INTO locations VALUES
      ( 2900
      , '20 Rue des Corps-Saints'
      , '1730'
      , 'Geneva'
      , 'Geneve'
      , 'CH'
      );

  INSERT INTO locations VALUES
      ( 3000
      , 'Murtenstrasse 921'
      , '3095'
      , 'Bern'
      , 'BE'
      , 'CH'
      );

  INSERT INTO locations VALUES
      ( 3100
      , 'Pieter Breughelstraat 837'
      , '3029SK'
      , 'Utrecht'
      , 'Utrecht'
      , 'NL'
      );

  INSERT INTO locations VALUES
      ( 3200
      , 'Mariano Escobedo 9991'
      , '11932'
      , 'Mexico City'
      , 'Distrito Federal'
      , 'MX'
      );
END;
/


REM **************************** insert data into the DEPARTMENTS table

Prompt ****** Populating DEPARTMENTS table ....

REM disable integrity constraint to EMPLOYEES to load data

ALTER TABLE departments
  DISABLE CONSTRAINT dept_mgr_fk;

BEGIN
  INSERT INTO departments VALUES
      ( 10
      , 'Administration'
      , 200
      , 1700
      );

  INSERT INTO departments VALUES
      ( 20
      , 'Marketing'
      , 201
      , 1800
      );

  INSERT INTO departments VALUES
      ( 30
      , 'Purchasing'
      , 114
      , 1700
      );

  INSERT INTO departments VALUES
      ( 40
      , 'Human Resources'
      , 203
      , 2400
      );

  INSERT INTO departments VALUES
      ( 50
      , 'Shipping'
      , 121
      , 1500
      );

  INSERT INTO departments VALUES
      ( 60
      , 'IT'
      , 103
      , 1400
      );

  INSERT INTO departments VALUES
      ( 70
      , 'Public Relations'
      , 204
      , 2700
      );

  INSERT INTO departments VALUES
      ( 80
      , 'Sales'
      , 145
      , 2500
      );

  INSERT INTO departments VALUES
      ( 90
      , 'Executive'
      , 100
      , 1700
      );

  INSERT INTO departments VALUES
      ( 100
      , 'Finance'
      , 108
      , 1700
      );

  INSERT INTO departments VALUES
      ( 110
      , 'Accounting'
      , 205
      , 1700
      );

  INSERT INTO departments VALUES
      ( 120
      , 'Treasury'
      , NULL
      , 1700
      );

  INSERT INTO departments VALUES
      ( 130
      , 'Corporate Tax'
      , NULL
      , 1700
      );

  INSERT INTO departments VALUES
      ( 140
      , 'Control And Credit'
      , NULL
      , 1700
      );

  INSERT INTO departments VALUES
      ( 150
      , 'Shareholder Services'
      , NULL
      , 1700
      );

  INSERT INTO departments VALUES
      ( 160
      , 'Benefits'
      , NULL
      , 1700
      );

  INSERT INTO departments VALUES
      ( 170
      , 'Manufacturing'
      , NULL
      , 1700
      );

  INSERT INTO departments VALUES
      ( 180
      , 'Construction'
      , NULL
      , 1700
      );

  INSERT INTO departments VALUES
      ( 190
      , 'Contracting'
      , NULL
      , 1700
      );

  INSERT INTO departments VALUES
      ( 200
      , 'Operations'
      , NULL
      , 1700
      );

  INSERT INTO departments VALUES
      ( 210
      , 'IT Support'
      , NULL
      , 1700
      );

  INSERT INTO departments VALUES
      ( 220
      , 'NOC'
      , NULL
      , 1700
      );

  INSERT INTO departments VALUES
      ( 230
      , 'IT Helpdesk'
      , NULL
      , 1700
      );

  INSERT INTO departments VALUES
      ( 240
      , 'Government Sales'
      , NULL
      , 1700
      );

  INSERT INTO departments VALUES
      ( 250
      , 'Retail Sales'
      , NULL
      , 1700
      );

  INSERT INTO departments VALUES
      ( 260
      , 'Recruiting'
      , NULL
      , 1700
      );

  INSERT INTO departments VALUES
      ( 270
      , 'Payroll'
      , NULL
      , 1700
      );
END;
/

REM *************************** insert data into the JOBS table

Prompt ****** Populating JOBS table ....

BEGIN
  INSERT INTO jobs VALUES
      ( 'AD_PRES'
      , 'President'
      , 20080
      , 40000
      );
  INSERT INTO jobs VALUES
      ( 'AD_VP'
      , 'Administration Vice President'
      , 15000
      , 30000
      );

  INSERT INTO jobs VALUES
      ( 'AD_ASST'
      , 'Administration Assistant'
      , 3000
      , 6000
      );

  INSERT INTO jobs VALUES
      ( 'FI_MGR'
      , 'Finance Manager'
      , 8200
      , 16000
      );

  INSERT INTO jobs VALUES
      ( 'FI_ACCOUNT'
      , 'Accountant'
      , 4200
      , 9000
      );

  INSERT INTO jobs VALUES
      ( 'AC_MGR'
      , 'Accounting Manager'
      , 8200
      , 16000
      );

  INSERT INTO jobs VALUES
      ( 'AC_ACCOUNT'
      , 'Public Accountant'
      , 4200
      , 9000
      );
  INSERT INTO jobs VALUES
      ( 'SA_MAN'
      , 'Sales Manager'
      , 10000
      , 20080
      );

  INSERT INTO jobs VALUES
      ( 'SA_REP'
      , 'Sales Representative'
      , 6000
      , 12008
      );

  INSERT INTO jobs VALUES
      ( 'PU_MAN'
      , 'Purchasing Manager'
      , 8000
      , 15000
      );

  INSERT INTO jobs VALUES
      ( 'PU_CLERK'
      , 'Purchasing Clerk'
      , 2500
      , 5500
      );

  INSERT INTO jobs VALUES
      ( 'ST_MAN'
      , 'Stock Manager'
      , 5500
      , 8500
      );
  INSERT INTO jobs VALUES
      ( 'ST_CLERK'
      , 'Stock Clerk'
      , 2008
      , 5000
      );

  INSERT INTO jobs VALUES
      ( 'SH_CLERK'
      , 'Shipping Clerk'
      , 2500
      , 5500
      );

  INSERT INTO jobs VALUES
      ( 'IT_PROG'
      , 'Programmer'
      , 4000
      , 10000
      );

  INSERT INTO jobs VALUES
      ( 'MK_MAN'
      , 'Marketing Manager'
      , 9000
      , 15000
      );

  INSERT INTO jobs VALUES
      ( 'MK_REP'
      , 'Marketing Representative'
      , 4000
      , 9000
      );

  INSERT INTO jobs VALUES
      ( 'HR_REP'
      , 'Human Resources Representative'
      , 4000
      , 9000
      );

  INSERT INTO jobs VALUES
      ( 'PR_REP'
      , 'Public Relations Representative'
      , 4500
      , 10500
      );
END;
/


REM *************************** insert data into the EMPLOYEES table

Prompt ****** Populating EMPLOYEES table ....
   
   
INSERT INTO employees VALUES
      ( 100
      , 'Steven'
      , 'King'
      , 'SKING'
      , '1.515.555.0100'
      , TO_DATE('17-06-2013', 'dd-MM-yyyy')
      , 'AD_PRES'
      , 24000
      , NULL
      , NULL
      , 90
      );
      
      
BEGIN
   FOR i IN 101..5000 LOOP
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
      ) VALUES (
         i,
         'Nombre' || i,
         'Apellido' || i,
         'EMP' || i,
         '300' || LPAD(MOD(i,10000000),7,'0'),
         DATE '2000-01-01' + MOD(i,7000),

         CASE MOD(i,19)
            WHEN 0 THEN 'AD_PRES'
            WHEN 1 THEN 'AD_VP'
            WHEN 2 THEN 'AD_ASST'
            WHEN 3 THEN 'FI_MGR'
            WHEN 4 THEN 'FI_ACCOUNT'
            WHEN 5 THEN 'AC_MGR'
            WHEN 6 THEN 'AC_ACCOUNT'
            WHEN 7 THEN 'SA_MAN'
            WHEN 8 THEN 'SA_REP'
            WHEN 9 THEN 'PU_MAN'
            WHEN 10 THEN 'PU_CLERK'
            WHEN 11 THEN 'ST_MAN'
            WHEN 12 THEN 'ST_CLERK'
            WHEN 13 THEN 'SH_CLERK'
            WHEN 14 THEN 'IT_PROG'
            WHEN 15 THEN 'MK_MAN'
            WHEN 16 THEN 'MK_REP'
            WHEN 17 THEN 'HR_REP'
            ELSE 'PR_REP'
         END,

         3000 + MOD(i*53,15000),

         CASE
            WHEN MOD(i,4)=0 THEN ROUND(DBMS_RANDOM.VALUE(0.05,0.25),2)
            ELSE NULL
         END,

         100,

         (SELECT department_id
          FROM (
               SELECT department_id,
                      ROW_NUMBER() OVER (ORDER BY department_id) rn
               FROM departments
          )
          WHERE rn = MOD(i, (SELECT COUNT(*) FROM departments)) + 1)
      );
   END LOOP;

   COMMIT;
END;
/

REM ********* insert data into the JOB_HISTORY table

Prompt ****** Populating JOB_HISTORY table ....

INSERT INTO job_history (
    employee_id,
    start_date,
    end_date,
    job_id,
    department_id
)
SELECT employee_id,
       hire_date,
       SYSDATE,
       job_id,
       department_id
FROM employees
WHERE employee_id BETWEEN 101 AND 5000;

COMMIT;

REM enable integrity constraint to DEPARTMENTS

ALTER TABLE departments
  ENABLE CONSTRAINT dept_mgr_fk;


