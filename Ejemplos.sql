
--------------------------------------------------------------------------------
-- Aumentar 10% a empleados de un departamento

DECLARE
    CURSOR c_emp IS
        SELECT employee_id, salary
        FROM employees
        WHERE department_id = 50;

    v_id employees.employee_id%TYPE;
    v_salary employees.salary%TYPE;

BEGIN
    OPEN c_emp;
    LOOP
        FETCH c_emp INTO v_id, v_salary;
        EXIT WHEN c_emp%NOTFOUND;

        UPDATE employees
        SET salary = v_salary * 1.10
        WHERE employee_id = v_id;

    END LOOP;
    CLOSE c_emp;

    COMMIT;
END;
/

--------------------------------------------------------------------------------

--FOR LOOP cursor automático
BEGIN
    FOR emp IN (
        SELECT employee_id, salary
        FROM employees
        WHERE department_id = 50
    ) LOOP

        UPDATE employees
        SET salary = emp.salary * 1.10
        WHERE employee_id = emp.employee_id;

    END LOOP;

    COMMIT;
END;
/

--------------------------------------------------------------------------------

--Aumento según rango salarial
BEGIN
    FOR emp IN (
        SELECT employee_id, salary
        FROM employees
    ) LOOP

        IF emp.salary < 5000 THEN
            UPDATE employees
            SET salary = emp.salary * 1.20
            WHERE employee_id = emp.employee_id;

        ELSIF emp.salary <= 10000 THEN
            UPDATE employees
            SET salary = emp.salary * 1.10
            WHERE employee_id = emp.employee_id;

        ELSE
            UPDATE employees
            SET salary = emp.salary * 1.05
            WHERE employee_id = emp.employee_id;
        END IF;

    END LOOP;

    COMMIT;
END;
/

--------------------------------------------------------------------------------

--Aumento solo si gana menos que el promedio
DECLARE
    v_promedio NUMBER;
BEGIN
    SELECT AVG(salary)
    INTO v_promedio
    FROM employees;

    UPDATE employees
    SET salary = salary * 1.15
    WHERE salary < v_promedio;

    COMMIT;
END;
/
--------------------------------------------------------------------------------

--Procedimiento almacenado

CREATE OR REPLACE PROCEDURE aumentar_salario_dep (
    p_dep_id NUMBER,
    p_porcentaje NUMBER
)
IS
BEGIN
    UPDATE employees
    SET salary = salary * (1 + p_porcentaje/100)
    WHERE department_id = p_dep_id;

    COMMIT;
END;
/

BEGIN
    aumentar_salario_dep(50, 10);
END;
/

--------------------------------------------------------------------------------

--Trigger que EVITA salarios muy altos, no permitir salario > 20000

CREATE OR REPLACE TRIGGER trg_limite_salario
BEFORE UPDATE OF salary ON employees
FOR EACH ROW
BEGIN
    IF :NEW.salary > 20000 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Salario excede el límite permitido');
    END IF;
END;
/

-- sin trigger
CREATE OR REPLACE PROCEDURE actualizar_salario (
    p_emp_id NUMBER,
    p_salary NUMBER
)
IS
BEGIN
    IF p_salary > 20000 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Salario excede el límite permitido');
    END IF;

    UPDATE employees
    SET salary = p_salary
    WHERE employee_id = p_emp_id;

    COMMIT;
END;
/
--------------------------------------------------------------------------------

--Aumento con validacion
CREATE OR REPLACE PROCEDURE aumentar_controlado (
    p_emp_id NUMBER,
    p_monto NUMBER
)
IS
    v_salario NUMBER;
BEGIN
    SELECT salary INTO v_salario
    FROM employees
    WHERE employee_id = p_emp_id;

    IF p_monto > 5000 THEN
        RAISE_APPLICATION_ERROR(-20002, 'Aumento demasiado alto');
    END IF;

    UPDATE employees
    SET salary = salary + p_monto
    WHERE employee_id = p_emp_id;

    COMMIT;
END;
/
--------------------------------------------------------------------------------

--Calcular aumento según salario (Funcion)

CREATE OR REPLACE FUNCTION calcular_aumento (
    p_salario NUMBER
) RETURN NUMBER
IS
BEGIN
    IF p_salario < 5000 THEN
        RETURN p_salario * 1.20;
    ELSIF p_salario <= 10000 THEN
        RETURN p_salario * 1.10;
    ELSE
        RETURN p_salario * 1.05;
    END IF;
END;
/

SELECT employee_id, salary, calcular_aumento(salary)
FROM employees;

UPDATE employees
SET salary = calcular_aumento(salary);

--------------------------------------------------------------------------------

-- Paquetes
CREATE OR REPLACE PACKAGE pkg_salarios AS

    FUNCTION calcular_aumento(p_salario NUMBER) RETURN NUMBER;

    PROCEDURE aumentar_empleado(p_emp_id NUMBER);

    PROCEDURE aumentar_departamento(p_dep_id NUMBER);

END pkg_salarios;
/

----------------------------------------------------  BODY
CREATE OR REPLACE PACKAGE BODY pkg_salarios AS

    FUNCTION calcular_aumento(p_salario NUMBER) RETURN NUMBER IS
    BEGIN
        IF p_salario < 5000 THEN
            RETURN p_salario * 1.20;
        ELSIF p_salario <= 10000 THEN
            RETURN p_salario * 1.10;
        ELSE
            RETURN p_salario * 1.05;
        END IF;
    END;

    PROCEDURE aumentar_empleado(p_emp_id NUMBER) IS
    BEGIN
        UPDATE employees
        SET salary = calcular_aumento(salary)
        WHERE employee_id = p_emp_id;
    END;

    PROCEDURE aumentar_departamento(p_dep_id NUMBER) IS
    BEGIN
        UPDATE employees
        SET salary = calcular_aumento(salary)
        WHERE department_id = p_dep_id;
    END;

END pkg_salarios;
/

------------------------------------------------------- USO
BEGIN
    pkg_salarios.aumentar_empleado(100);
END;
/