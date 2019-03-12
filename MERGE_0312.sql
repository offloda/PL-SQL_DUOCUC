BEGIN
    MERGE INTO COPIA_EMPLEADOS COP_EMP
    USING EMPLOYEES EMP
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