--CANTIDAD DE EMPLEADOS POR DEPARTAMENTO
-- 500 por empleado
-- 2000 por no tener empleado
VARIABLE B_BONO NUMBER;
VARIABLE B_BONO1 NUMBER;

BEGIN
    :B_BONO := 500;
    :B_BONO1 := 2000;
END;

DECLARE
    V_DEP_NAME DEPARTMENTS.DEPARTMENT_NAME%TYPE;
    V_DEP_ID DEPARTMENTS.DEPARTMENT_ID%TYPE;
    V_CANT_EMP NUMBER;
    V_MAX NUMBER;
    V_MIN NUMBER;
    V_BONO NUMBER;
    V_OLD_DATE EMPLOYEES.HIRE_DATE%TYPE;
    V_CANT_ANIOS NUMBER;
BEGIN
    SELECT MIN(DEP.DEPARTMENT_ID), MAX(DEP.DEPARTMENT_ID)
    INTO V_MIN, V_MAX
    FROM DEPARTMENTS DEP;
    
    WHILE V_MIN <= V_MAX
    LOOP
        SELECT NVL(MIN(EMP.HIRE_DATE), SYSDATE)
        INTO V_OLD_DATE
        FROM EMPLOYEES EMP
        WHERE EMP.DEPARTMENT_ID = V_MIN;
        
        V_CANT_ANIOS := TRUNC(MONTHS_BETWEEN(SYSDATE, V_OLD_DATE)/12);
        
        SELECT DEP.DEPARTMENT_NAME,
               DEP.DEPARTMENT_ID,
               COUNT(EMP.EMPLOYEE_ID)
        INTO V_DEP_NAME,
             V_DEP_ID,
             V_CANT_EMP
        FROM DEPARTMENTS DEP
            LEFT JOIN EMPLOYEES EMP ON DEP.DEPARTMENT_ID =
                                       EMP.DEPARTMENT_ID
        WHERE DEP.DEPARTMENT_ID = V_MIN
        GROUP BY DEP.DEPARTMENT_NAME, DEP.DEPARTMENT_ID
        ORDER BY DEP.DEPARTMENT_ID;
        
        V_MIN:= V_MIN + 10;
        
        IF V_CANT_EMP > 0 THEN
            V_BONO := V_CANT_EMP * :B_BONO;
        ELSE
            V_BONO := :B_BONO1;
        END IF;
        
        dbms_output.put_line('ID DEPARTAMENTO: ' || V_DEP_ID);
        dbms_output.put_line('NOMBRE DEPARTAMENTO: ' || V_DEP_NAME);
        dbms_output.put_line('CANTIDAD DE EMPLEADOS POR DEPARTAMENTO: ' || V_CANT_EMP);
        dbms_output.put_line('BONO POR EMPLEADO: $' || V_BONO);
        dbms_output.put_line('CANTIDAD DE AÑOS: ' || V_CANT_ANIOS);
        dbms_output.put_line('---------------------------');
    END LOOP;
END;