-- RN 001

DELIMITER //
CREATE OR REPLACE TRIGGER t_limiteDeudaCliente
BEFORE INSERT ON lineaspedido FOR EACH ROW
	BEGIN
	
	DECLARE pedId INT;
	SET pedId = NEW.pedidoId;
		
	if (f_deuda((SELECT pedidos.clienteId
		FROM pedidos
		WHERE id = pedId))) + NEW.precioUnitario >= 4000 then
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT =
			'La deuda que tiene el cliente con Kumafu no puede ser superior a 4000 euros';
	END if;
END //
DELIMITER ;
