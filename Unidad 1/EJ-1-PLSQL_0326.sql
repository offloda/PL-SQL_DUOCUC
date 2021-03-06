VARIABLE B_BONO_1 NUMBER;
VARIABLE B_BONO_2 NUMBER;

BEGIN
    :B_BONO_1 := 250000;
    :B_BONO_2 := 125000;
END;

DECLARE
    V_RUT_PROFESOR PROFESOR.RUT%TYPE;
    V_NOMBRE_PROF PROFESOR.NOMBRE%TYPE;
    V_CANT_ASIGNATURAS NUMBER;
    V_SUELDO PROFESOR.SUELDO_BRUTO%TYPE;
    V_MONTO_AUM NUMBER;
    V_BONO_ASIG NUMBER;
    V_PORCENTAJE_DESCUENTO NUMBER;
    V_DESCUENTO_SOLIDARIO NUMBER;
    V_SUELDO_LIQUIDO NUMBER;
    V_MIN NUMBER;
    V_MAX NUMBER;
    V_PORCENTAJE_AUMENTO NUMBER;
BEGIN
    SELECT MIN(PRO.CODIGO), MAX(PRO.CODIGO)
    INTO V_MIN, V_MAX
    FROM PROFESOR PRO;
    
    WHILE V_MIN <= V_MAX
    LOOP
        SELECT PRO.RUT,
               PRO.SUELDO_BRUTO,
               PRO.NOMBRE,
               COUNT(CODIGO_SECCION)
        INTO V_RUT_PROFESOR,
             V_SUELDO,
             V_NOMBRE_PROF,
             V_CANT_ASIGNATURAS
        FROM PROFESOR PRO
            LEFT JOIN SECCION SEC ON PRO.CODIGO = SEC.CODIGO_PROFESOR
        WHERE PRO.CODIGO = V_MIN
        GROUP BY PRO.RUT, PRO.SUELDO_BRUTO, PRO.NOMBRE
        ORDER BY PRO.RUT;
        
        --OBTENER EL PORCENTAJE EN BASE AL RUT
        SELECT AUM.PORCENTAJE_AUMENTO
        INTO V_PORCENTAJE_AUMENTO
        FROM AUMENTO_PROFESOR AUM
        WHERE AUM.RUT_PROFESOR = V_RUT_PROFESOR;
        
                
        --AUMTO DE SUELDO POR BONO
        V_MONTO_AUM := V_SUELDO * (V_PORCENTAJE_AUMENTO / 100);
        
        --PORCENTAJE DE DESCUENTO EN BASE AL SUELDO
        SELECT DES.DESCUENTO
        INTO V_PORCENTAJE_DESCUENTO
        FROM DESCUENTO_SUELDO DES
        WHERE DES.VALOR_INFERIOR <= V_SUELDO AND DES.VALOR_SUPERIOR >= V_SUELDO;
        
        V_DESCUENTO_SOLIDARIO := V_SUELDO * (V_PORCENTAJE_DESCUENTO / 100);
        
        --BONO POR SECCION
        IF V_CANT_ASIGNATURAS > 3 THEN
            V_BONO_ASIG := :B_BONO_1;
        ELSE
            V_BONO_ASIG := :B_BONO_2;
        END IF;
        
        --SUELDO LIQUIDO
        V_SUELDO_LIQUIDO := V_SUELDO + V_BONO_ASIG + V_MONTO_AUM - V_DESCUENTO_SOLIDARIO;
        
        dbms_output.put_line('RUT: ' || V_RUT_PROFESOR);
        dbms_output.put_line('NOMBRE: ' || V_NOMBRE_PROF);
        dbms_output.put_line('CANTIDAD CURSOS: ' || V_CANT_ASIGNATURAS);
        dbms_output.put_line('SUELDO: $' || V_SUELDO);
        dbms_output.put_line('MONTO AUMENTO: $' || V_MONTO_AUM);
        dbms_output.put_line('BONO: $' || V_BONO_ASIG);
        dbms_output.put_line('DESCUENTO SOLIDARIO: $' || V_DESCUENTO_SOLIDARIO);
        dbms_output.put_line('SUELDO LIQUIDO: $' || V_SUELDO_LIQUIDO);
        dbms_output.put_line('---------------------------------');
        
        INSERT INTO RESUMEN VALUES(V_RUT_PROFESOR, V_NOMBRE_PROF, V_CANT_ASIGNATURAS, V_SUELDO, V_MONTO_AUM, V_BONO_ASIG, V_DESCUENTO_SOLIDARIO, V_SUELDO_LIQUIDO);
        COMMIT;
        
        V_MIN := V_MIN + 10;
    END LOOP;
END;

--SELECT * FROM RESUMEN;