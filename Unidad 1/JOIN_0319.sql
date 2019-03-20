--debe mostrar el id y el nombre del departamento(de todos)
--debe mostrar la cantidad de trabajadores por departamentos
--debe mostrar el sueldo que paga c/u de los departamentos
--a cada departamento se le asignara un bono de 500 x empleado (VARIABLE BIND)
DECLARE
    V_ID departments.department_id%TYPE;
    V_NAME departments.department_name%TYPE;
    V_CANT_EMP INT;
    V_SALARY employees.salary%TYPE;
    V_MAX departments.department_id%TYPE;
    V_MIN departments.department_id%TYPE;
    V_BASE_BONO INT;
    V_BONO INT;
BEGIN
    V_BASE_BONO := 500;
    
    SELECT MIN(DEPARTMENT_ID), MAX(DEPARTMENT_ID)
    INTO V_MIN, V_MAX
    FROM DEPARTMENTS;
    
    WHILE V_MIN <= V_MAX
        LOOP
            SELECT DEP.DEPARTMENT_ID,
                   DEP.DEPARTMENT_NAME,
                   COUNT(EMP.EMPLOYEE_ID),
                   SUM(EMP.SALARY)
            INTO V_ID,
                 V_NAME,
                 V_CANT_EMP,
                 V_SALARY
            FROM DEPARTMENTS DEP
                LEFT JOIN EMPLOYEES EMP ON DEP.DEPARTMENT_ID = EMP.DEPARTMENT_ID
            WHERE DEP.DEPARTMENT_ID = V_MIN
            GROUP BY DEP.DEPARTMENT_ID,
                     DEP.DEPARTMENT_NAME
            ORDER BY DEP.DEPARTMENT_ID;
            
            V_BONO := V_CANT_EMP * V_BASE_BONO;
            
            dbms_output.put_line('ID: ' || V_ID);
            dbms_output.put_line('NAME: ' || V_NAME);
            dbms_output.put_line('CANT EMP: ' || V_CANT_EMP);
            dbms_output.put_line('SALARY: ' || V_SALARY);
            dbms_output.put_line('BONO: ' || V_BONO);
            dbms_output.put_line('----------------------------');
    
            V_MIN := V_MIN + 10;
        END LOOP;
END; 
