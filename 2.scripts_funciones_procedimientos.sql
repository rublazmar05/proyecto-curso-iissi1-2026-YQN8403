DELIMITER //
CREATE OR REPLACE FUNCTION precioTotal(pedId INT)
RETURNS DECIMAL(10, 2)
	BEGIN
	RETURN IFNULL((SELECT SUM(cantidadProducto * precioUnitario)
		FROM lineaspedido
		WHERE pedidoId = pedId), 0);
	END;
//
DELIMITER ;

DELIMITER //
CREATE OR REPLACE FUNCTION importePorPagar(pedId INT)
RETURNS DECIMAL(10, 2)
	BEGIN
	DECLARE pagado DECIMAL(10, 2);
	 SET pagado = (SELECT SUM(pagos.importe)
	 	FROM pagos
	 	WHERE pagos.pedidoId = pedId);
	RETURN precioTotal(pedId) - pagado;
	END;
//
DELIMITER ;

DELIMITER //
CREATE OR REPLACE FUNCTION estadoPago(pedId INT)
RETURNS DECIMAL(10, 2)
	BEGIN
	DECLARE pagado VARCHAR(255);
	 SET pagado = 'PENDIENTE';
	 if (importePorPagar(pedId) = 0) then
	 	SET pagado = 'COMPLETO';
	END if;
	RETURN pagado;
	END;
//
DELIMITER ;
