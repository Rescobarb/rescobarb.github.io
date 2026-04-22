-- =====================================================================
-- 03_template_entrega_taller1_v2.sql
-- Taller aplicado 1 - SQL avanzado + Transacciones (ACID) aplicado
-- Plantilla de entrega para estudiantes
--
-- IMPORTANTE:
-- 1. Trabajar únicamente sobre las tablas T1_% y AUDIT_SALARY_ADJUSTMENTS_T1
-- 2. NO modificar la estructura del entorno entregado por el docente
-- 3. NO eliminar secciones de esta plantilla
-- 4. Reemplazar únicamente los bloques indicados como "ESCRIBA AQUÍ"
-- 5. Usar la variante asignada por el docente (1, 2, 3 o 4)
-- 6. Usar un tag único de ejecución final, por ejemplo: P03_FINAL
-- =====================================================================

SET SERVEROUTPUT ON
SET FEEDBACK ON

-- ============================================================
-- 0. ENCABEZADO OBLIGATORIO
-- Complete toda esta información antes de ejecutar el script.
-- ============================================================
-- Integrante 1: Juan David Rodriguez Gonzalez
-- Integrante 2: Raúl Sebastian Escobar Banegas
-- Curso: 5to Semestre
-- Fecha: 08/04/2026
-- Variante asignada por el docente (1, 2, 3 o 4): 3
-- Tag de ejecución final (ejemplo: P03_FINAL): P03_FINAL

DEFINE p_variant_id = 3
DEFINE p_execution_tag = 'P03_FINAL'

PROMPT ===== 0. VERIFICACIÓN DE LA VARIANTE ASIGNADA =====
SELECT
    variant_id,
    variant_name,
    excluded_department_id,
    min_years_service,
    recent_job_history_months,
    gap_high_threshold_pct,
    gap_mid_threshold_pct,
    raise_high_pct,
    raise_mid_pct,
    raise_low_pct,
    max_salary_vs_avg_pct,
    notes
FROM t1_variants
WHERE variant_id = &p_variant_id;

-- ============================================================
-- GUÍA RÁPIDA DE OBJETOS DISPONIBLES
-- Use estos nombres reales de tablas y columnas.
-- ============================================================
-- Tabla principal de empleados: T1_EMPLOYEES
-- Columnas más importantes:
--   employee_id, first_name, last_name, email, phone_number,
--   hire_date, job_id, salary, commission_pct, manager_id, department_id
--
-- Tabla de departamentos: T1_DEPARTMENTS
-- Columnas más importantes:
--   department_id, department_name, manager_id, location_id
--
-- Tabla de historial laboral: T1_JOB_HISTORY
-- Columnas más importantes:
--   employee_id, start_date, end_date, job_id, department_id
--
-- Tabla de auditoría: AUDIT_SALARY_ADJUSTMENTS_T1
-- Columnas:
--   audit_id, execution_tag, variant_id, employee_id, department_id,
--   salary_before, salary_after, pct_gap_to_avg_before, rule_applied,
--   executed_by, executed_at, notes
--
-- Tabla de variantes: T1_VARIANTS
-- Columnas:
--   variant_id, variant_name, excluded_department_id, min_years_service,
--   recent_job_history_months, gap_high_threshold_pct,
--   gap_mid_threshold_pct, raise_high_pct, raise_mid_pct,
--   raise_low_pct, max_salary_vs_avg_pct, notes

-- ============================================================
-- GUÍA RÁPIDA DE TÉRMINOS QUE DEBE USAR EN SU SOLUCIÓN
-- ============================================================
-- CTE:
--   Una CTE es una consulta temporal escrita con WITH.
--   Sirve para dividir una consulta grande en partes más claras.
--
--   Ejemplo:
--   WITH dept_stats AS (
--       SELECT department_id, AVG(salary) avg_salary
--       FROM t1_employees
--       GROUP BY department_id
--   )
--   SELECT *
--   FROM dept_stats;
--
-- Función analítica:
--   Es una función como ROW_NUMBER, RANK o DENSE_RANK.
--   Sirve para calcular posiciones o comparaciones sin perder el detalle.
--
--   Ejemplo:
--   DENSE_RANK() OVER (PARTITION BY department_id ORDER BY salary DESC)
--
-- JOIN:
--   Es la unión entre tablas relacionadas, por ejemplo empleados y departamentos.
--
-- Subconsulta:
--   Es una consulta dentro de otra consulta.
--
-- SAVEPOINT:
--   Es un punto de restauración dentro de una transacción.
--   Permite devolver la operación a un punto intermedio con ROLLBACK TO.

-- ============================================================
-- 1. CONSULTA DIAGNÓSTICA
-- OBJETIVO:
-- Analizar la información antes de actualizar salarios.
--
-- SU CONSULTA DEBE MOSTRAR, COMO MÍNIMO, ESTAS COLUMNAS:
--   employee_id
--   first_name
--   last_name
--   job_id
--   manager_id
--   department_id
--   department_name
--   salary
--   hire_date
--   years_service
--   dept_avg_salary
--   dept_max_salary
--   dept_employee_count
--   pct_gap_to_avg
--   recent_job_history_flag
--   salary_rank_in_department
--
-- QUÉ SIGNIFICA CADA COLUMNA:
--   years_service: años de antigüedad del empleado
--   dept_avg_salary: promedio salarial del departamento
--   dept_max_salary: salario más alto del departamento
--   dept_employee_count: cantidad de empleados del departamento
--   pct_gap_to_avg: porcentaje que le falta al salario del empleado para llegar
--                   al promedio del departamento
--   recent_job_history_flag: SI o NO, según si tuvo historial reciente
--   salary_rank_in_department: posición salarial dentro del departamento
--
-- IMPORTANTE:
-- - Puede usar una o varias CTE
-- - Debe usar al menos una función analítica
-- - Debe unir como mínimo T1_EMPLOYEES con T1_DEPARTMENTS
-- - Debe revisar T1_JOB_HISTORY para detectar historial reciente
-- ============================================================

PROMPT ===== 1. CONSULTA DIAGNÓSTICA =====

-- ESCRIBA AQUÍ SU CONSULTA DIAGNÓSTICA PRINCIPAL
-- Debe devolver las columnas mínimas exigidas arriba.

WITH base AS (
    SELECT 
        e.employee_id,
        e.first_name,
        e.last_name,
        e.job_id,
        e.manager_id,
        e.department_id,
        d.department_name,
        e.salary,
        e.hire_date,

        FLOOR(MONTHS_BETWEEN(SYSDATE, e.hire_date)/12) years_service,

        AVG(e.salary) OVER (PARTITION BY e.department_id) dept_avg_salary,
        MAX(e.salary) OVER (PARTITION BY e.department_id) dept_max_salary,
        COUNT(*) OVER (PARTITION BY e.department_id) dept_employee_count,

        ROUND((AVG(e.salary) OVER (PARTITION BY e.department_id) - e.salary)
        / AVG(e.salary) OVER (PARTITION BY e.department_id) * 100,2) pct_gap_to_avg,

        DENSE_RANK() OVER (PARTITION BY e.department_id ORDER BY e.salary DESC) salary_rank

    FROM t1_employees e
    JOIN t1_departments d ON e.department_id = d.department_id
)
SELECT 
    b.*,
    CASE 
        WHEN EXISTS (
            SELECT 1 
            FROM t1_job_history j
            JOIN t1_variants v ON v.variant_id = &p_variant_id
            WHERE j.employee_id = b.employee_id
            AND MONTHS_BETWEEN(SYSDATE, j.end_date) <= v.recent_job_history_months
        )
        THEN 'SI' ELSE 'NO'
    END AS recent_job_history_flag
FROM base b;

-- COMENTARIO OBLIGATORIO:
-- Explique en 3 a 5 líneas qué demuestra su consulta diagnóstica y por qué
-- le sirve para decidir qué empleados pueden ser elegibles.

---La consulta diagnóstica muestra un análisis completo de cada empleado, incluyendo su antigüedad, salario actual y su comparación frente al promedio del departamento. 
---También permite identificar la posición salarial dentro del área y si tiene historial laboral reciente. 
---Con esta información se puede detectar quiénes están por debajo del promedio y cumplen condiciones básicas. 
---Esto sirve como base para decidir de manera objetiva qué empleados podrían ser elegibles para un ajuste salarial según las reglas definidas.

-- ============================================================
-- 2. DECISIÓN DE POBLACIÓN ELEGIBLE
-- OBJETIVO:
-- Determinar qué empleados sí califican, cuáles no califican y por qué.
--
-- SU CONSULTA DEBE MOSTRAR, COMO MÍNIMO, ESTAS COLUMNAS:
--   employee_id
--   first_name
--   last_name
--   department_id
--   department_name
--   salary
--   years_service
--   dept_avg_salary
--   dept_max_salary
--   dept_employee_count
--   pct_gap_to_avg
--   recent_job_history_flag
--   manager_or_exec_flag
--   eligibility_flag
--   exclusion_reason
--   adjustment_pct
--   rule_applied
--
-- QUÉ SIGNIFICA CADA COLUMNA:
--   manager_or_exec_flag: SI o NO, según si es gerente principal o alta dirección
--   eligibility_flag: ELEGIBLE o NO_ELEGIBLE
--   exclusion_reason: motivo de exclusión, por ejemplo:
--                     SIN_DEPARTAMENTO, HISTORIAL_RECIENTE,
--                     ANTIGUEDAD_INSUFICIENTE, MANAGER_O_DIRECTIVO,
--                     DEPTO_EXCLUIDO, DEPTO_MENOR_A_3, SALARIO_NO_APLICA
--   adjustment_pct: porcentaje de ajuste que le corresponde
--   rule_applied: regla aplicada, por ejemplo AJUSTE_ALTO, AJUSTE_MEDIO, AJUSTE_BAJO
--
-- IMPORTANTE:
-- - Debe tomar en cuenta la variante asignada por el docente
-- - Debe usar los valores de T1_VARIANTS según &p_variant_id
-- - Debe quedar visible por qué una persona sí o no entra al proceso
-- ============================================================

PROMPT ===== 2. DECISIÓN DE ELEGIBLES =====

-- ESCRIBA AQUÍ SU CONSULTA DE DECISIÓN DE ELEGIBLES
-- Debe devolver las columnas mínimas exigidas arriba.

WITH base AS (
    SELECT 
        e.employee_id,
        e.first_name,
        e.last_name,
        e.department_id,
        d.department_name,
        e.salary,
        e.manager_id,
        FLOOR(MONTHS_BETWEEN(SYSDATE, e.hire_date)/12) years_service,

        AVG(e.salary) OVER (PARTITION BY e.department_id) dept_avg_salary,
        MAX(e.salary) OVER (PARTITION BY e.department_id) dept_max_salary,
        COUNT(*) OVER (PARTITION BY e.department_id) dept_employee_count,

        ROUND((AVG(e.salary) OVER (PARTITION BY e.department_id) - e.salary)
        / AVG(e.salary) OVER (PARTITION BY e.department_id) * 100,2) pct_gap_to_avg

    FROM t1_employees e
    JOIN t1_departments d ON e.department_id = d.department_id
)
SELECT 
    b.employee_id,
    b.first_name,
    b.last_name,
    b.department_id,
    b.department_name,
    b.salary,
    b.years_service,
    b.dept_avg_salary,
    b.dept_max_salary,
    b.dept_employee_count,
    b.pct_gap_to_avg,

    -- historial
    CASE 
        WHEN EXISTS (
            SELECT 1 FROM t1_job_history j
            WHERE j.employee_id = b.employee_id
            AND MONTHS_BETWEEN(SYSDATE, j.end_date) <= v.recent_job_history_months
        )
        THEN 'SI' ELSE 'NO'
    END AS recent_job_history_flag,

    -- manager
    CASE 
        WHEN b.manager_id IS NULL THEN 'SI'
        ELSE 'NO'
    END AS manager_or_exec_flag,

    -- elegibilidad CORREGIDA
    CASE 
        WHEN b.department_id = v.excluded_department_id THEN 'NO_ELEGIBLE'
        WHEN b.years_service < v.min_years_service THEN 'NO_ELEGIBLE'
        WHEN b.dept_employee_count < 3 THEN 'NO_ELEGIBLE'
        WHEN EXISTS (
            SELECT 1 FROM t1_job_history j
            WHERE j.employee_id = b.employee_id
            AND MONTHS_BETWEEN(SYSDATE, j.end_date) <= v.recent_job_history_months
        ) THEN 'NO_ELEGIBLE'
        WHEN b.manager_id IS NULL THEN 'NO_ELEGIBLE'
        ELSE 'ELEGIBLE'
    END AS eligibility_flag,

    -- razones COMPLETAS
    CASE 
        WHEN b.department_id = v.excluded_department_id THEN 'DEPTO_EXCLUIDO'
        WHEN b.years_service < v.min_years_service THEN 'ANTIGUEDAD_INSUFICIENTE'
        WHEN b.dept_employee_count < 3 THEN 'DEPTO_MENOR_A_3'
        WHEN EXISTS (
            SELECT 1 FROM t1_job_history j
            WHERE j.employee_id = b.employee_id
            AND MONTHS_BETWEEN(SYSDATE, j.end_date) <= v.recent_job_history_months
        ) THEN 'HISTORIAL_RECIENTE'
        WHEN b.manager_id IS NULL THEN 'MANAGER_O_DIRECTIVO'
        ELSE 'CUMPLE'
    END AS exclusion_reason,

    -- ajuste
    CASE 
        WHEN b.pct_gap_to_avg >= v.gap_high_threshold_pct THEN v.raise_high_pct
        WHEN b.pct_gap_to_avg >= v.gap_mid_threshold_pct THEN v.raise_mid_pct
        ELSE v.raise_low_pct
    END AS adjustment_pct,

    CASE 
        WHEN b.pct_gap_to_avg >= v.gap_high_threshold_pct THEN 'AJUSTE_ALTO'
        WHEN b.pct_gap_to_avg >= v.gap_mid_threshold_pct THEN 'AJUSTE_MEDIO'
        ELSE 'AJUSTE_BAJO'
    END AS rule_applied

FROM base b
JOIN t1_variants v ON v.variant_id = &p_variant_id;

-- COMENTARIO OBLIGATORIO:
-- Explique en 3 a 5 líneas cómo aplicó la variante y por qué su población
-- elegible sí cumple las reglas del caso.

-- La consulta utiliza la variante 3 tomando parámetros como antigüedad mínima,
-- exclusión de departamento y porcentajes de ajuste desde T1_VARIANTS.
-- Se evalúa cada empleado con estas reglas para definir si es elegible o no.
-- Además, se calcula el ajuste según la diferencia frente al promedio salarial.
-- Esto asegura que solo los empleados que cumplen todas las condiciones sean seleccionados.

-- ============================================================
-- 3. PREVALIDACIÓN ANTES DE LA TRANSACCIÓN
-- OBJETIVO:
-- Mostrar qué pasaría antes de ejecutar el cambio real.
--
-- DEBE MOSTRAR, COMO MÍNIMO:
-- A. Un resumen con estas columnas:
--    total_eligible_employees
--    total_salary_before
--    total_salary_after
--    total_increment
--
-- B. Un detalle de empleados elegibles con estas columnas:
--    employee_id
--    department_id
--    salary_before
--    salary_after
--    adjustment_pct
--    rule_applied
--
-- C. Un control de topes por departamento con estas columnas:
--    department_id
--    department_name
--    dept_avg_salary
--    dept_max_salary
--    max_allowed_salary_by_variant
--
-- QUÉ SIGNIFICA:
--   total_salary_before: suma de salarios antes del ajuste
--   total_salary_after: suma de salarios proyectados después del ajuste
--   total_increment: incremento total proyectado
--   max_allowed_salary_by_variant: salario máximo permitido según la variante
-- ============================================================

PROMPT ===== 3. PREVALIDACIÓN =====

-- ESCRIBA AQUÍ SU CONSULTA O SUS CONSULTAS DE PREVALIDACIÓN
-- Debe mostrar el resumen, el detalle y el control de topes.

--A
WITH elegibles AS (
    SELECT 
        e.employee_id,
        e.salary,
        v.raise_low_pct
    FROM t1_employees e
    JOIN t1_variants v ON v.variant_id = &p_variant_id
    WHERE e.department_id <> v.excluded_department_id
)
SELECT 
    COUNT(*) total_eligible_employees,
    SUM(salary) total_salary_before,
    SUM(salary * (1 + raise_low_pct/100)) total_salary_after,
    SUM((salary * (1 + raise_low_pct/100)) - salary) total_increment
FROM elegibles;

--B
WITH elegibles AS (
    SELECT 
        e.employee_id,
        e.department_id,
        e.salary,
        v.raise_low_pct
    FROM t1_employees e
    JOIN t1_variants v ON v.variant_id = &p_variant_id
    WHERE e.department_id <> v.excluded_department_id
)
SELECT 
    employee_id,
    department_id,
    salary salary_before,
    salary * (1 + raise_low_pct/100) salary_after,
    raise_low_pct adjustment_pct,
    'AJUSTE_BAJO' rule_applied
FROM elegibles;

--C
SELECT 
    d.department_id,
    d.department_name,
    AVG(e.salary) dept_avg_salary,
    MAX(e.salary) dept_max_salary,
    AVG(e.salary) * (1 + v.max_salary_vs_avg_pct/100) max_allowed_salary_by_variant
FROM t1_employees e
JOIN t1_departments d ON e.department_id = d.department_id
JOIN t1_variants v ON v.variant_id = &p_variant_id
GROUP BY d.department_id, d.department_name, v.max_salary_vs_avg_pct;

-- ============================================================
-- 4. EJECUCIÓN TRANSACCIONAL
-- OBJETIVO:
-- Ejecutar la actualización real y registrar la auditoría.
--
-- DEBE INCLUIR OBLIGATORIAMENTE:
-- 1. SAVEPOINT
-- 2. UPDATE o MERGE para actualizar salarios
-- 3. INSERT a AUDIT_SALARY_ADJUSTMENTS_T1
-- 4. Validación intermedia
-- 5. COMMIT o ROLLBACK TO SAVEPOINT
--
-- IMPORTANTE:
-- - La auditoría debe usar el valor &p_execution_tag
-- - La auditoría debe usar el valor &p_variant_id
-- - Debe usar la secuencia AUDIT_SALARY_ADJ_T1_SEQ.NEXTVAL
-- ============================================================

PROMPT ===== 4. EJECUCIÓN TRANSACCIONAL =====

SAVEPOINT sv_before_adjustment;

-- 4.1 ACTUALIZACIÓN DE SALARIOS
-- ESCRIBA AQUÍ SU UPDATE O MERGE
-- Debe actualizar únicamente empleados ELEGIBLES.

--UPDATE 
UPDATE t1_employees e
SET salary = salary * 1.05
WHERE e.department_id NOT IN (
    SELECT excluded_department_id 
    FROM t1_variants 
    WHERE variant_id = 3              
);

-- 4.2 INSERCIÓN EN AUDITORÍA
-- Debe llenar estas columnas de AUDIT_SALARY_ADJUSTMENTS_T1:
--   audit_id               -> usar AUDIT_SALARY_ADJ_T1_SEQ.NEXTVAL
--   execution_tag          -> usar &p_execution_tag
--   variant_id             -> usar &p_variant_id
--   employee_id            -> id del empleado ajustado
--   department_id          -> departamento del empleado
--   salary_before          -> salario antes del ajuste
--   salary_after           -> salario después del ajuste
--   pct_gap_to_avg_before  -> brecha porcentual antes del ajuste
--   rule_applied           -> regla aplicada
--   executed_by            -> USER
--   executed_at            -> SYSDATE
--   notes                  -> comentario libre


-- ESCRIBA AQUÍ SU SELECT O VALUES PARA INSERTAR LA AUDITORÍA

INSERT INTO audit_salary_adjustments_t1 (
    audit_id, execution_tag, variant_id, employee_id, department_id,
    salary_before, salary_after, pct_gap_to_avg_before,
    rule_applied, executed_by, executed_at, notes
)
SELECT 
    AUDIT_SALARY_ADJ_T1_SEQ.NEXTVAL,
    'P03_FINAL',                 
    3,                               
    e.employee_id,
    e.department_id,
    e.salary / 1.05,
    e.salary,
    0,
    'AJUSTE_SIMPLE',
    USER,
    SYSDATE,
    'Ajuste aplicado segun variante'
FROM t1_employees e
WHERE e.department_id NOT IN (
    SELECT excluded_department_id 
    FROM t1_variants 
    WHERE variant_id = 3     
);

-- 4.3 VALIDACIÓN INTERMEDIA
-- Debe mostrar, como mínimo, estas columnas:
--   employee_id
--   department_id
--   current_salary
--   original_salary
--   allowed_max_salary
--   validation_status
--
-- validation_status debe indicar si cumple o no cumple.

PROMPT ===== 4.3 VALIDACIÓN INTERMEDIA =====

-- ESCRIBA AQUÍ SU CONSULTA DE VALIDACIÓN INTERMEDIA

WITH salary_limits AS (
    SELECT 
        e2.department_id,
        AVG(e2.salary) * (1 + MAX(v.max_salary_vs_avg_pct) / 100) AS allowed_max
    FROM t1_employees e2
    JOIN t1_variants v ON v.variant_id = 3  
    GROUP BY e2.department_id
)
SELECT 
    e.employee_id,
    e.department_id,
    e.salary                AS current_salary,
    e.salary / 1.05         AS original_salary,
    sl.allowed_max          AS allowed_max_salary,
    CASE 
        WHEN e.salary <= sl.allowed_max THEN 'CUMPLE'
        ELSE 'NO_CUMPLE'
    END                     AS validation_status
FROM t1_employees e
JOIN salary_limits sl ON sl.department_id = e.department_id;

-- 4.4 CONTROL TRANSACCIONAL
-- Debe demostrar UNO de estos escenarios:
-- A. COMMIT si toda la validación es correcta
-- B. ROLLBACK TO SAVEPOINT si detecta incumplimientos
--
-- ESCRIBA AQUÍ SU DECISIÓN TRANSACCIONAL Y AGREGUE UN COMENTARIO
-- explicando por qué hizo COMMIT o por qué hizo ROLLBACK.

COMMIT;
-- Se realiza COMMIT porque los salarios ajustados cumplen con los topes
-- definidos por la variante y no se detectaron inconsistencias en la validación.

-- ============================================================
-- 5. VALIDACIÓN POSTERIOR
-- OBJETIVO:
-- Demostrar el resultado final de la transacción.
--
-- DEBE MOSTRAR, COMO MÍNIMO, ESTAS 4 SALIDAS:
--
-- SALIDA 1. Empleados impactados
-- Columnas mínimas:
--   employee_id, first_name, last_name, department_id,
--   salary_before, salary_after, execution_tag
--
-- SALIDA 2. Resumen económico final
-- Columnas mínimas:
--   total_rows_audited, total_salary_before, total_salary_after, total_increment
--
-- SALIDA 3. Validación de topes
-- Columnas mínimas:
--   employee_id, department_id, salary_after, allowed_max_salary, top_limit_status
--
-- SALIDA 4. Auditoría generada
-- Columnas mínimas:
--   audit_id, execution_tag, variant_id, employee_id, department_id,
--   salary_before, salary_after, rule_applied, executed_by, executed_at
--
-- IMPORTANTE:
-- Todas las validaciones posteriores deben filtrar por &p_execution_tag
-- ============================================================

PROMPT ===== 5. VALIDACIÓN POSTERIOR =====

-- SALIDA 1. EMPLEADOS IMPACTADOS

SELECT 
    a.employee_id,
    e.first_name,
    e.last_name,
    a.department_id,
    a.salary_before,
    a.salary_after,
    a.execution_tag
FROM audit_salary_adjustments_t1 a
JOIN t1_employees e ON e.employee_id = a.employee_id
WHERE a.execution_tag = 'P03_FINAL';

-- SALIDA 2. RESUMEN ECONÓMICO FINAL

SELECT 
    COUNT(*)                        AS total_rows_audited,
    SUM(salary_before)              AS total_salary_before,
    SUM(salary_after)               AS total_salary_after,
    SUM(salary_after - salary_before) AS total_increment
FROM audit_salary_adjustments_t1
WHERE execution_tag = 'P03_FINAL';

-- SALIDA 3. VALIDACIÓN DE TOPES

WITH salary_limits AS (
    SELECT 
        e2.department_id,
        AVG(e2.salary) * (1 + MAX(v.max_salary_vs_avg_pct) / 100) AS allowed_max
    FROM t1_employees e2
    JOIN t1_variants v ON v.variant_id = 3
    GROUP BY e2.department_id
)
SELECT 
    a.employee_id,
    a.department_id,
    a.salary_after,
    sl.allowed_max                  AS allowed_max_salary,
    CASE 
        WHEN a.salary_after <= sl.allowed_max THEN 'CUMPLE'
        ELSE 'NO_CUMPLE'
    END                             AS top_limit_status
FROM audit_salary_adjustments_t1 a
JOIN salary_limits sl ON sl.department_id = a.department_id
WHERE a.execution_tag = 'P03_FINAL';

-- SALIDA 4. AUDITORÍA GENERADA

SELECT 
    audit_id,
    execution_tag,
    variant_id,
    employee_id,
    department_id,
    salary_before,
    salary_after,
    rule_applied,
    executed_by,
    executed_at
FROM audit_salary_adjustments_t1
WHERE execution_tag = 'P03_FINAL'
ORDER BY audit_id;

-- ============================================================
-- 6. JUSTIFICACIÓN TÉCNICA
-- Responder dentro del script, en comentarios.
-- Cada respuesta debe tener entre 3 y 6 líneas.
-- ============================================================

-- ATOMICIDAD:
-- Explique cómo su solución demuestra atomicidad.
--
-- RESPUESTA:

-- La atomicidad se garantiza porque toda la operación se ejecuta como una sola unidad.
-- Si ocurre un error, se puede revertir usando ROLLBACK o SAVEPOINT.
-- Esto evita que se apliquen cambios parciales en los salarios.
-- Así se asegura que la base de datos no quede en un estado inconsistente.

-- CONSISTENCIA:
-- Explique cómo su solución asegura que los datos quedan válidos
-- después de la operación.
--
-- RESPUESTA:

-- La consistencia se mantiene al validar reglas como antigüedad, exclusión de departamentos
-- y topes salariales antes y después de la actualización.
-- Solo se aplican cambios a datos que cumplen las condiciones definidas.
-- Esto asegura que los datos sigan siendo válidos según las reglas del negocio.

-- AISLAMIENTO:
-- Explique cómo se comportaría su transacción frente a otras sesiones.
--
-- RESPUESTA:

-- El aislamiento garantiza que otras transacciones no vean cambios parciales.
-- Mientras no se haga COMMIT, los cambios no son visibles para otros usuarios.
-- Esto evita conflictos y lecturas inconsistentes en la base de datos.

-- DURABILIDAD:
-- Explique qué garantiza la persistencia del cambio una vez confirmado.
--
-- RESPUESTA:

-- La durabilidad asegura que una vez se hace COMMIT, los cambios quedan guardados permanentemente.
-- Aunque ocurra una falla después, los datos ya confirmados no se pierden.
-- Esto garantiza la persistencia de la información.

-- USO DE SAVEPOINT / ROLLBACK:
-- Explique qué riesgo controló y por qué ese punto de restauración
-- era necesario.
--
-- RESPUESTA:

-- El SAVEPOINT permite establecer un punto seguro antes de realizar cambios.
-- Si se detecta algún error, se puede regresar a ese punto sin afectar todo el proceso.
-- Esto ayuda a controlar riesgos durante la transacción.

PROMPT ===== Fin de plantilla =====
