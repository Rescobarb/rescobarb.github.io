
INSERT INTO pay_concepts (code, name, concept_type, calc_method, default_rate, is_active) VALUES ('PC21','Seguro Social','DEDUCCION','PORCENTAJE',0.03,'Y');
INSERT INTO pay_concepts (code, name, concept_type, calc_method, default_rate, is_active) VALUES ('PC22','Fondo Pensiones','DEDUCCION','PORCENTAJE',0.07,'Y');
INSERT INTO pay_concepts (code, name, concept_type, calc_method, default_rate, is_active) VALUES ('PC23','Impuesto Renta','DEDUCCION','PORCENTAJE',0.10,'Y');
INSERT INTO pay_concepts (code, name, concept_type, calc_method, default_rate, is_active) VALUES ('PC24','Prestamo','DEDUCCION','FIJO',1,'Y');
INSERT INTO pay_concepts (code, name, concept_type, calc_method, default_rate, is_active) VALUES ('PC25','Anticipo','DEDUCCION','FIJO',1,'Y');
INSERT INTO pay_concepts (code, name, concept_type, calc_method, default_rate, is_active) VALUES ('PC26','Cuota Cooperativa','DEDUCCION','FIJO',50,'Y');
INSERT INTO pay_concepts (code, name, concept_type, calc_method, default_rate, is_active) VALUES ('PC27','Seguro Medico','DEDUCCION','FIJO',100,'Y');
INSERT INTO pay_concepts (code, name, concept_type, calc_method, default_rate, is_active) VALUES ('PC28','Seguro Vida','DEDUCCION','FIJO',80,'Y');
INSERT INTO pay_concepts (code, name, concept_type, calc_method, default_rate, is_active) VALUES ('PC29','Ausencia Injustificada','DEDUCCION','FIJO',1,'Y');
INSERT INTO pay_concepts (code, name, concept_type, calc_method, default_rate, is_active) VALUES ('PC30','Retencion Judicial','DEDUCCION','PORCENTAJE',0.15,'Y');

INSERT INTO pay_concepts (code, name, concept_type, calc_method, default_rate, is_active) VALUES ('PC31','Caja Ahorro','DEDUCCION','PORCENTAJE',0.05,'Y');
INSERT INTO pay_concepts (code, name, concept_type, calc_method, default_rate, is_active) VALUES ('PC32','Uniforme','DEDUCCION','FIJO',30,'Y');
INSERT INTO pay_concepts (code, name, concept_type, calc_method, default_rate, is_active) VALUES ('PC33','Herramientas','DEDUCCION','FIJO',40,'Y');
INSERT INTO pay_concepts (code, name, concept_type, calc_method, default_rate, is_active) VALUES ('PC34','Capacitacion','DEDUCCION','FIJO',60,'Y');
INSERT INTO pay_concepts (code, name, concept_type, calc_method, default_rate, is_active) VALUES ('PC35','Adelanto Vacaciones','DEDUCCION','FIJO',1,'Y');
INSERT INTO pay_concepts (code, name, concept_type, calc_method, default_rate, is_active) VALUES ('PC36','Multa Administrativa','DEDUCCION','FIJO',25,'Y');
INSERT INTO pay_concepts (code, name, concept_type, calc_method, default_rate, is_active) VALUES ('PC37','Descuento Tardanza','DEDUCCION','FIJO',1,'Y');
INSERT INTO pay_concepts (code, name, concept_type, calc_method, default_rate, is_active) VALUES ('PC38','Descuento Danos','DEDUCCION','FIJO',1,'Y');
INSERT INTO pay_concepts (code, name, concept_type, calc_method, default_rate, is_active) VALUES ('PC39','Plan Dental','DEDUCCION','FIJO',35,'Y');
INSERT INTO pay_concepts (code, name, concept_type, calc_method, default_rate, is_active) VALUES ('PC40','Seguro Complementario','DEDUCCION','FIJO',45,'Y');

INSERT INTO pay_concepts (code, name, concept_type, calc_method, default_rate, is_active) VALUES ('PC51','Descuento Sindicato','DEDUCCION','PORCENTAJE',0.02,'Y');
INSERT INTO pay_concepts (code, name, concept_type, calc_method, default_rate, is_active) VALUES ('PC52','Descuento Voluntario','DEDUCCION','FIJO',1,'Y');
INSERT INTO pay_concepts (code, name, concept_type, calc_method, default_rate, is_active) VALUES ('PC53','Embargo','DEDUCCION','PORCENTAJE',0.20,'Y');
INSERT INTO pay_concepts (code, name, concept_type, calc_method, default_rate, is_active) VALUES ('PC54','Plan Educativo','DEDUCCION','FIJO',70,'Y');
INSERT INTO pay_concepts (code, name, concept_type, calc_method, default_rate, is_active) VALUES ('PC55','Seguro Vehicular','DEDUCCION','FIJO',90,'Y');
INSERT INTO pay_concepts (code, name, concept_type, calc_method, default_rate, is_active) VALUES ('PC56','Donacion','DEDUCCION','FIJO',20,'Y');
INSERT INTO pay_concepts (code, name, concept_type, calc_method, default_rate, is_active) VALUES ('PC57','Retencion Extra','DEDUCCION','PORCENTAJE',0.05,'Y');
INSERT INTO pay_concepts (code, name, concept_type, calc_method, default_rate, is_active) VALUES ('PC58','Descuento Judicial','DEDUCCION','PORCENTAJE',0.18,'Y');
INSERT INTO pay_concepts (code, name, concept_type, calc_method, default_rate, is_active) VALUES ('PC59','Prestamo Hipotecario','DEDUCCION','FIJO',1,'Y');
INSERT INTO pay_concepts (code, name, concept_type, calc_method, default_rate, is_active) VALUES ('PC60','Prestamo Personal','DEDUCCION','FIJO',1,'Y');

INSERT INTO pay_concepts (code, name, concept_type, calc_method, default_rate, is_active) VALUES ('SAL_BASE', 'Salario Base', 'DEVENGO', 'FIJO', 1, 'Y');

COMMIT;

--------------------------------------------------------------------------------------------------------------------------------------------------------------------

INSERT INTO pay_payroll_types (CODE, DESCRIPTION) VALUES ('Quincenal', 'Pago quincenal de cada empleado');

--------------------------------------------------------------------------------------------------------------------------------------------------------------------

--pagos son quincenales los periodos de la fecha actual para atras 1 año pay_periods

DECLARE
    vn_period_id NUMBER := MAX(period_id);
    vd_start DATE := ADD_MONTHS(TRUNC(SYSDATE,'MM'), -12);
BEGIN

    WHILE vd_start < SYSDATE LOOP

        INSERT INTO pay_periods
        VALUES (
            vn_period_id,
            1,
            TO_CHAR(vd_start,'YYYYMM')||'A',
            TRUNC(vd_start,'MM'),
            TRUNC(vd_start,'MM') + 14,
            'CERRADO'
        );

        vn_period_id := vn_period_id + 1;

        INSERT INTO pay_periods
        VALUES (
            vn_period_id,
            1,
            TO_CHAR(vd_start,'YYYYMM')||'B',
            TRUNC(vd_start,'MM') + 15,
            LAST_DAY(vd_start),
            'CERRADO'
        );

        vn_period_id := vn_period_id + 1;

        vd_start := ADD_MONTHS(vd_start,1);

    END LOOP;

    COMMIT;

END;
/
----------------------------------------------------------------------------------------------------------


