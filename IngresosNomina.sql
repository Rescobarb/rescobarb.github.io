
CREATE OR REPLACE PROCEDURE ingresar_nomina (
    p_employee_id IN NUMBER,
    p_period_code IN VARCHAR2
)

/* Juan David Rodriguez
    02/03/26
    Procedimiento para calcular la nomina individual de cada empleado 
    tomando como referencia tres conceptos depago obligatorios 
*/ 
IS
    v_salary            employees.salary%TYPE;
    v_period_id         pay_periods.period_id%TYPE;
    v_sal_quincenal     NUMBER(12,2);

    v_seg_social        NUMBER(12,2);
    v_pension           NUMBER(12,2);
    v_renta             NUMBER(12,2);

    v_payslip_id        pay_payslips.payslip_id%TYPE;

    v_sal_base_id       pay_concepts.concept_id%TYPE;
    v_pc21_id           pay_concepts.concept_id%TYPE;
    v_pc22_id           pay_concepts.concept_id%TYPE;
    v_pc23_id           pay_concepts.concept_id%TYPE;

BEGIN

    -- Obtener period_id
    SELECT period_id
    INTO v_period_id
    FROM pay_periods
    WHERE period_code = p_period_code;

    -- Obtener salario
    SELECT salary
    INTO v_salary
    FROM employees
    WHERE employee_id = p_employee_id;

    v_sal_quincenal := v_salary / 2;

    -- Obtener conceptos
    SELECT concept_id INTO v_sal_base_id FROM pay_concepts WHERE code = 'SAL_BASE';
    SELECT concept_id INTO v_pc21_id FROM pay_concepts WHERE code = 'PC21';
    SELECT concept_id INTO v_pc22_id FROM pay_concepts WHERE code = 'PC22';
    SELECT concept_id INTO v_pc23_id FROM pay_concepts WHERE code = 'PC23';

    -- Calcular deducciones usando default_rate
    SELECT v_sal_quincenal * default_rate
    INTO v_seg_social
    FROM pay_concepts WHERE code = 'PC21';

    SELECT v_sal_quincenal * default_rate
    INTO v_pension
    FROM pay_concepts WHERE code = 'PC22';

    SELECT v_sal_quincenal * default_rate
    INTO v_renta
    FROM pay_concepts WHERE code = 'PC23';

    -- Insertar cabecera
    INSERT INTO pay_payslips
    (period_id, employee_id, gross_total, ded_total, net_total)
    VALUES
    (v_period_id, p_employee_id, 0, 0, 0)
    RETURNING payslip_id INTO v_payslip_id;

    -- Salario base
    INSERT INTO pay_payslip_lines
    (payslip_id, concept_id, qty, unit_value, line_total)
    VALUES
    (v_payslip_id, v_sal_base_id, 1, v_sal_quincenal, v_sal_quincenal);

    -- Deducciones obligatorias
    INSERT INTO pay_payslip_lines
    VALUES (DEFAULT, v_payslip_id, v_pc21_id, 1, -v_seg_social, -v_seg_social);

    INSERT INTO pay_payslip_lines
    VALUES (DEFAULT, v_payslip_id, v_pc22_id, 1, -v_pension, -v_pension);

    INSERT INTO pay_payslip_lines
    VALUES (DEFAULT, v_payslip_id, v_pc23_id, 1, -v_renta, -v_renta);

    -- Actualizar totales
    UPDATE pay_payslips
    SET gross_total = v_sal_quincenal,
        ded_total   = v_seg_social + v_pension + v_renta,
        net_total   = v_sal_quincenal - (v_seg_social + v_pension + v_renta)
    WHERE payslip_id = v_payslip_id;

    COMMIT;

END ingresar_nomina;
/

DECLARE

    -- Variable para guardar el id del empleado
    v_emp_id employees.employee_id%TYPE;

    -- Cursor explícito
    CURSOR c_empleados IS
        SELECT employee_id
        FROM employees;

BEGIN

    -- Abrir cursor
    OPEN c_empleados;

    LOOP
        -- Traer siguiente empleado
        FETCH c_empleados INTO v_emp_id;

        -- Salir cuando no haya más registros
        EXIT WHEN c_empleados%NOTFOUND;

        -- Llamar tu procedimiento ya creado
        ingresar_nomina(v_emp_id, '20260201');

    END LOOP;

    -- Cerrar cursor
    CLOSE c_empleados;

END;
/

DROP PROCEDURE ingresar_nomina;

