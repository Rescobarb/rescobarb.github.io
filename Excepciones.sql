-- excepciones

SET SERVEROUTPUT ON

DECLARE 
    n1 NUMBER(9) := 3;
    n2 NUMBER(9) := 0;
    total NUMBER(9);
 
BEGIN 
    total := n1/n2;
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('Error');
END;
/

--------------------------------------------------------------------------------

DECLARE 
    n1 NUMBER(9);
    n_negativo EXCEPTION;
BEGIN 
    n1 := -2;
    IF n1 < 0 THEN
        RAISE n_negativo;
    END IF;
EXCEPTION
    WHEN n_negativo THEN
        dbms_output.put_line('Error');
    WHEN OTHER THEN
        dbms_output.put_line('Error DESCONOCIDO');
END;
/

--------------------------------------------------------------------------------

DECLARE 
    exc_country_non_registered EXCEPTION;
    vv_country VARCHAR2(50);
    vn_verificar NUMBER;
BEGIN
    vv_country := INITCAP('china');
    
    SELECT COUNT(*)
    INTO vn_verificar
    FROM COUNTRIES
    WHERE COUNTRY_NAME = vv_country;
    
    IF vn_verificar = 0 THEN
        RAISE exc_country_non_registered;
    ELSE
       dbms_output.put_line('El pais ' || vv_country || ' si existe'); 
    END IF;
EXCEPTION
    WHEN exc_country_non_registered THEN
        dbms_output.put_line('El pais no existe o no esta registrado');
END;
/