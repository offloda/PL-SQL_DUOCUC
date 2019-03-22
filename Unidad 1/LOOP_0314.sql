-- <=5000 alto > 5000 bajo
DECLARE
    V_NOMBRE VARCHAR(20);
    V_APELLIDO VARCHAR(20);
    V_SALARIO EMPLOYEES.SALARY%TYPE;
    V_MIN EMPLOYEES.EMPLOYEE_ID%TYPE;
    V_MAX EMPLOYEES.EMPLOYEE_ID%TYPE;
    V_SALARIO_MAX NUMBER;
BEGIN
    V_SALARIO_MAX := 5000;
    
    SELECT MIN(EMPLOYEE_ID), MAX(EMPLOYEE_ID)
    INTO V_MIN, V_MAX
    FROM EMPLOYEES;
    
    WHILE V_MIN <= V_MAX
    LOOP
        SELECT FIRST_NAME, LAST_NAME, SALARY
        INTO V_NOMBRE, V_APELLIDO, V_SALARIO
        FROM EMPLOYEES
        WHERE EMPLOYEE_ID = V_MIN;
        
        IF V_SALARIO < V_SALARIO_MAX THEN
            dbms_output.put_line(
            'ID=' || V_MIN ||
            ' El empleado ' || V_NOMBRE ||' '|| V_APELLIDO ||
            ' tiene un salario de: $'||V_SALARIO ||
            ' Salario Bajo'
            );
        ELSE
            dbms_output.put_line(
            'ID=' || V_MIN ||
            ' El empleado ' || V_NOMBRE ||' '|| V_APELLIDO ||
            ' tiene un salario de: $'||V_SALARIO ||
            ' Salario Alto'
            );
        END IF;
        
        V_MIN := V_MIN + 1;
    END LOOP;
END;

WHILE V_I >= 0
        LOOP
            SELECT DEPARTMENT_ID, DEPARTMENT_NAME
            INTO V_ID, V_NOMBRE_DEPARTMENTS
            FROM DEPARTMENTS
            WHERE DEPARTMENT_ID = V_ID_DEP;
            
            SELECT COUNT(EMPLOYEE_ID) 
            INTO V_CANT_EMPLOYEES
            FROM EMPLOYEES 
            WHERE DEPARTMENT_ID = V_ID;
            
            V_CANT_EMPLOYEES :=+ V_CANT_EMPLOYEES;
            dbms_output.put_line('Department ID: ' || V_ID || ' Cant emp: ' || V_CANT_EMPLOYEES);
            V_I := V_I - 1;
            V_ID_DEP:= V_ID_DEP + 10;
        END LOOP;