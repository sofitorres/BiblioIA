-- TRIGGER 1A: Resta stock ante nuevos préstamos activos
DROP TRIGGER IF EXISTS trg_actualizar_stock_insert;
CREATE TRIGGER trg_actualizar_stock_insert
AFTER INSERT ON PRESTAMO
FOR EACH ROW
BEGIN
    DECLARE v_isbn VARCHAR(20);
    DECLARE v_stock_actual INT;
    
    SELECT isbn INTO v_isbn FROM EJEMPLAR WHERE id_ejemplar = NEW.id_ejemplar;
    SELECT stock_disponible INTO v_stock_actual FROM LIBRO WHERE isbn = v_isbn;
    
    IF NEW.estado = 'ACTIVO' AND v_stock_actual > 0 THEN
        UPDATE LIBRO SET stock_disponible = stock_disponible - 1 WHERE isbn = v_isbn;
    END IF;
END;

-- TRIGGER 1B: Devuelve stock cuando se asienta la devolución
DROP TRIGGER IF EXISTS trg_actualizar_stock_update;
CREATE TRIGGER trg_actualizar_stock_update
AFTER UPDATE ON PRESTAMO
FOR EACH ROW
BEGIN
    DECLARE v_isbn VARCHAR(20);
    
    SELECT isbn INTO v_isbn FROM EJEMPLAR WHERE id_ejemplar = NEW.id_ejemplar;
    
    IF OLD.estado <> 'DEVUELTO' AND NEW.estado = 'DEVUELTO' THEN
        UPDATE LIBRO SET stock_disponible = stock_disponible + 1 WHERE isbn = v_isbn;
    END IF;
END;

-- TRIGGER 2: Suspende al socio automáticamente al recibir una sanción
DROP TRIGGER IF EXISTS trg_estado_socio;
CREATE TRIGGER trg_estado_socio
AFTER INSERT ON SANCION
FOR EACH ROW
BEGIN
    UPDATE SOCIO SET estado = 'SUSPENDIDO' WHERE id_socio = NEW.id_socio;
END;

-- TRIGGER 3: Auditoría completa de préstamos (Usa CURRENT_USER())
DROP TRIGGER IF EXISTS trg_audit_prestamo_insert;
CREATE TRIGGER trg_audit_prestamo_insert
AFTER INSERT ON PRESTAMO
FOR EACH ROW
BEGIN
    INSERT INTO AUDITORIA_PRESTAMOS (id_prestamo, operacion, estado_anterior, estado_nuevo, usuario)
    VALUES (NEW.id_prestamo, 'INSERT', NULL, NEW.estado, CURRENT_USER());
END;

DROP TRIGGER IF EXISTS trg_audit_prestamo_update;
CREATE TRIGGER trg_audit_prestamo_update
AFTER UPDATE ON PRESTAMO
FOR EACH ROW
BEGIN
    INSERT INTO AUDITORIA_PRESTAMOS (id_prestamo, operacion, estado_anterior, estado_nuevo, usuario)
    VALUES (NEW.id_prestamo, 'UPDATE', OLD.estado, NEW.estado, CURRENT_USER());
END;

DROP TRIGGER IF EXISTS trg_audit_prestamo_delete;
CREATE TRIGGER trg_audit_prestamo_delete
AFTER DELETE ON PRESTAMO
FOR EACH ROW
BEGIN
    INSERT INTO AUDITORIA_PRESTAMOS (id_prestamo, operacion, estado_anterior, estado_nuevo, usuario)
    VALUES (OLD.id_prestamo, 'DELETE', OLD.estado, NULL, CURRENT_USER());
END;