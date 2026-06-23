-- SP 1: Generación modular de sanciones por mora
DROP PROCEDURE IF EXISTS sp_generar_sancion;
CREATE PROCEDURE sp_generar_sancion(
    IN p_id_socio INT,
    IN p_tipo VARCHAR(50),
    IN p_dias_mora INT
)
BEGIN
    DECLARE v_dias_sancion INT;
    SET v_dias_sancion = p_dias_mora * 3;
    
    INSERT INTO SANCION (id_socio, tipo, fecha_inicio, fecha_fin, motivo)
    VALUES (
        p_id_socio, 
        p_tipo, 
        CURDATE(), 
        DATE_ADD(CURDATE(), INTERVAL v_dias_sancion DAY),
        CONCAT('Sanción automática por ', p_dias_mora, ' días de mora. Suspensión de ', v_dias_sancion, ' días.')
    );
END;

-- SP 2: Registro integral y seguro de préstamos
DROP PROCEDURE IF EXISTS sp_registrar_prestamo;
CREATE PROCEDURE sp_registrar_prestamo(
    IN p_id_socio INT,
    IN p_id_ejemplar INT
)
BEGIN
    DECLARE v_isbn VARCHAR(20);
    DECLARE v_stock_disponible INT;
    DECLARE v_estado_ejemplar VARCHAR(20) DEFAULT NULL;
    DECLARE v_estado_socio VARCHAR(20) DEFAULT NULL;
    DECLARE v_prestamos_activos INT DEFAULT 0;
    DECLARE v_sanciones_activas INT DEFAULT 0;

    SELECT estado_fisico, isbn INTO v_estado_ejemplar, v_isbn FROM EJEMPLAR WHERE id_ejemplar = p_id_ejemplar;
    IF v_isbn IS NOT NULL THEN
        SELECT stock_disponible INTO v_stock_disponible FROM LIBRO WHERE isbn = v_isbn;
    END IF;

    SELECT estado INTO v_estado_socio FROM SOCIO WHERE id_socio = p_id_socio;
    SELECT COUNT(*) INTO v_prestamos_activos FROM PRESTAMO WHERE id_socio = p_id_socio AND estado = 'ACTIVO';
    SELECT COUNT(*) INTO v_sanciones_activas FROM SANCION WHERE id_socio = p_id_socio AND CURDATE() BETWEEN fecha_inicio AND fecha_fin;

    IF v_estado_ejemplar IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: El ID del Ejemplar no existe en los registros.';
    ELSEIF v_estado_ejemplar = 'BAJA' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: El ejemplar se encuentra de BAJA por mal estado y no puede prestarse.';
    ELSEIF v_estado_socio IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: El ID del Socio no existe en la base de datos.';
    ELSEIF v_estado_socio <> 'ACTIVO' OR v_sanciones_activas > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: El socio posee sanciones activas o se encuentra suspendido actualmente.';
    ELSEIF v_prestamos_activos >= 3 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: El socio ya alcanzó el límite máximo de 3 préstamos activos simultáneos.';
    ELSEIF v_stock_disponible <= 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: No quedan unidades de este libro en el inventario disponible.';
    ELSE
        INSERT INTO PRESTAMO (id_socio, id_ejemplar, fecha_prestamo, fecha_vencimiento, fecha_devolucion, estado)
        VALUES (p_id_socio, p_id_ejemplar, CURDATE(), DATE_ADD(CURDATE(), INTERVAL 14 DAY), NULL, 'ACTIVO');
        SELECT 'Préstamo procesado con éxito. Se actualizaron stock y auditorías automáticamente.' AS Resultado;
    END IF;
END;

-- SP 3: Devolución física y cálculo automático de demoras
DROP PROCEDURE IF EXISTS sp_registrar_devolucion;
CREATE PROCEDURE sp_registrar_devolucion(
    IN p_id_prestamo INT
)
BEGIN
    DECLARE v_existe INT DEFAULT 0;
    DECLARE v_estado VARCHAR(20);
    DECLARE v_id_socio INT;
    DECLARE v_fecha_vencimiento DATE;
    DECLARE v_dias_mora INT DEFAULT 0;
    
    SELECT COUNT(*) INTO v_existe FROM PRESTAMO WHERE id_prestamo = p_id_prestamo;
    
    IF v_existe = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: El ID de préstamo ingresado no existe.';
    ELSE
        SELECT estado, id_socio, fecha_vencimiento 
        INTO v_estado, v_id_socio, v_fecha_vencimiento
        FROM PRESTAMO 
        WHERE id_prestamo = p_id_prestamo;
        
        IF v_estado = 'DEVUELTO' THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Aviso: Este préstamo ya fue asentado como DEVUELTO previamente.';
        ELSE
            IF CURDATE() > v_fecha_vencimiento THEN
                SET v_dias_mora = DATEDIFF(CURDATE(), v_fecha_vencimiento);
            END IF;
            
            UPDATE PRESTAMO 
            SET fecha_devolucion = CURDATE(), estado = 'DEVUELTO' 
            WHERE id_prestamo = p_id_prestamo;
            
            IF v_dias_mora > 0 THEN
                CALL sp_generar_sancion(v_id_socio, 'SUSPENSIÓN POR MORA', v_dias_mora);
                SELECT CONCAT('Devolución registrada con retraso de ', v_dias_mora, ' días. Se invocó la sanción.') AS Resultado;
            ELSE
                SELECT 'Devolución registrada a término con éxito.' AS Resultado;
            END IF;
        END IF;
    END IF;
END;

-- SP 4: Renovaciones de fechas sin demora o sanciones vigentes (Bonus)
DROP PROCEDURE IF EXISTS sp_renovar_prestamo;
CREATE PROCEDURE sp_renovar_prestamo(
    IN p_id_prestamo INT
)
BEGIN
    DECLARE v_existe INT DEFAULT 0;
    DECLARE v_estado VARCHAR(20);
    DECLARE v_socio_actual INT;
    DECLARE v_fecha_vencimiento DATE;
    DECLARE v_sanciones_activas INT DEFAULT 0;
    DECLARE v_estado_socio VARCHAR(20);
    
    SELECT COUNT(*) INTO v_existe FROM PRESTAMO WHERE id_prestamo = p_id_prestamo;
    
    IF v_existe = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: El ID de préstamo ingresado no existe.';
    ELSE
        SELECT estado, id_socio, fecha_vencimiento 
        INTO v_estado, v_socio_actual, v_fecha_vencimiento
        FROM PRESTAMO 
        WHERE id_prestamo = p_id_prestamo;
        
        SELECT estado INTO v_estado_socio FROM SOCIO WHERE id_socio = v_socio_actual;
        
        SELECT COUNT(*) INTO v_sanciones_activas 
        FROM SANCION 
        WHERE id_socio = v_socio_actual AND CURDATE() BETWEEN fecha_inicio AND fecha_fin;
        
        IF v_estado <> 'ACTIVO' THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: Solo se pueden renovar préstamos que estén actualmente en estado ACTIVO.';
        ELSEIF CURDATE() > v_fecha_vencimiento THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: El préstamo ya se encuentra vencido. No califica para renovación, debe devolverlo.';
        ELSEIF v_estado_socio <> 'ACTIVO' OR v_sanciones_activas > 0 THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: El socio no se encuentra habilitado en el sistema debido a sanciones activas.';
        ELSE
            UPDATE PRESTAMO 
            SET fecha_vencimiento = DATE_ADD(fecha_vencimiento, INTERVAL 14 DAY)
            WHERE id_prestamo = p_id_prestamo;
            
            SELECT 'Préstamo renovado con éxito por 14 días adicionales.' AS Resultado;
        END IF;
    END IF;
END;

-- Prueba 1: Socio intenta llevarse un ejemplar dado de baja (ID 8 es BAJA)
CALL sp_registrar_prestamo(3, 8);

-- Prueba 2: Socio suspendido intenta realizar un préstamo (Socio 4 está SUSPENDIDO)
CALL sp_registrar_prestamo(4, 2);

-- Prueba de Límite Máximo: Socio 6 saca 3 libros consecutivos sin problemas
CALL sp_registrar_prestamo(6, 1);
CALL sp_registrar_prestamo(6, 4);
CALL sp_registrar_prestamo(6, 6);

-- Intento de un cuarto préstamo para el Socio 1 (Debe rebotar por límite de 3)
CALL sp_registrar_prestamo(6, 10);