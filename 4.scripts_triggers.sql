-- RN 001

DELIMITER //
CREATE OR REPLACE TRIGGER t_limiteDeudaCliente
BEFORE INSERT ON lineaspedido FOR EACH ROW
	BEGIN
	
	DECLARE pedId INT;
	SET pedId = NEW.pedidoId;
		
	if (f_deuda((SELECT pedidos.clienteId
		FROM pedidos
		WHERE id = pedId))) + (NEW.precioUnitario * NEW.cantidadProducto) >= 4000 then
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT =
			'La deuda que tiene el cliente con Kumafu no puede ser superior a 4000 euros';
	END if;
END //
DELIMITER ;

-- RN 002

DELIMITER //
CREATE OR REPLACE TRIGGER t_limitePedidosEmpleadoInsert
BEFORE INSERT ON pedidos FOR EACH ROW
	BEGIN
	if (NEW.empleadoId IS NOT NULL AND NEW.fechaEntrega IS NULL) then
		if (f_pedidosEnCurso(NEW.empleadoId) >= 5) then
			SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT =
				'Un empleado no puede gestionar más de 5 pedidos en curso';
		END if;
	END if;
END //
DELIMITER ;

DELIMITER //
CREATE OR REPLACE TRIGGER t_limitePedidosEmpleadoUpdate
BEFORE UPDATE ON pedidos FOR EACH ROW
	BEGIN
	if (NEW.empleadoId IS NOT NULL AND NEW.fechaEntrega IS NULL
		AND (OLD.empleadoId IS NULL OR NEW.empleadoId <> OLD.empleadoId OR OLD.fechaEntrega IS NOT NULL)) then
		if (f_pedidosEnCurso(NEW.empleadoId) >= 5) then
			SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT =
				'Un empleado no puede gestionar más de 5 pedidos en curso';
		END if;
	END if;
END //
DELIMITER ;
