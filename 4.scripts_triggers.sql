-- RN 001
DELIMITER //
CREATE OR REPLACE TRIGGER limiteDeudaCliente
BEFORE INSERT ON lineaspedido FOR EACH ROW
	BEGIN
	
	DECLARE pedId INT;
	SET pedId = NEW.pedidoId;
		
	if (SELECT deuda
	FROM deudaClientes
	WHERE deudaclientes.id = (SELECT pedidos.clienteId
		FROM pedidos
		WHERE pedidos.id = pedId)) + NEW.precioUnitario > 4000 then
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT =
			'La deuda que tiene el cliente con Kumafu no puede ser superior a 4000 euros';
	END if;
END //
DELIMITER ;
