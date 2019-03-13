--Bloque
BEGIN
    --merge into <tabla> <alias>
    MERGE INTO COPIA_EMPLEADOS COP_EMP
    --using <tabla> <alias>
    USING EMPLOYEES EMP
        --on <(alias.columna = alias.columna)>
        ON (COP_EMP.EMPLOYEE_ID = EMP.EMPLOYEE_ID)
        WHEN MATCHED THEN 
            UPDATE SET
                COP_EMP.FIRST_NAME = EMP.FIRST_NAME,
                COP_EMP.LAST_NAME = EMP.LAST_NAME,
                COP_EMP.DEPARTMENT_ID = EMP.DEPARTMENT_ID
        WHEN NOT MATCHED THEN
            INSERT VALUES(EMP.EMPLOYEED_ID, EMP.FIRST_NAME,
                          EMP.LAST_NAME, EMP.EMAIL,
                          EMP.PHONE_NUMBER, EMP.HIRE_DATE,
                          EMP.JOB_ID, EMP.SALARY,
                          EMP.COMMISSION_PCT, EMP.MANAGER_ID,
                          EMP.DEPARTMENT_ID)
END;

--MERGE INTO: declaración para seleccionar 1 o mas filas de una tabla
--USING: clausula que específica la funte de los datos a comparar
--WHEN MATCHED THEN: clausula que condiciona en caso de que encuentre coincidencias
--UPDATED SET: sentencia que actualiza los datos selecionados
--WHEN NOT MATCHED THEN: clausula que condiciona en caso de que no encuentre coincidencias
--INSERT VALUES: sentencia que insetar campos a la tabla específicada
