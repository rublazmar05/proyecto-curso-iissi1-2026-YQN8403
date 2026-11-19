DELIMITER //
CREATE OR REPLACE FUNCTION f_precioTotal(pedId INT)
RETURNS DECIMAL(10, 2)
	BEGIN
	RETURN IFNULL((SELECT SUM(cantidadProducto * precioUnitario)
		FROM lineaspedido
		WHERE pedidoId = pedId), 0);
	END;
//
DELIMITER ;

DELIMITER //
CREATE OR REPLACE FUNCTION f_importePorPagar(pedId INT)
RETURNS DECIMAL(10, 2)
	BEGIN
	DECLARE pagado DECIMAL(10, 2);
	 SET pagado = (SELECT SUM(pagos.importe)
	 	FROM pagos
	 	WHERE pagos.pedidoId = pedId);
	RETURN f_precioTotal(pedId) - pagado;
	END;
//
DELIMITER ;

DELIMITER //
CREATE OR REPLACE FUNCTION f_estadoPago(pedId INT)
RETURNS DECIMAL(10, 2)
	BEGIN
	DECLARE pagado VARCHAR(255);
	 SET pagado = 'PENDIENTE';
	 if (f_importePorPagar(pedId) = 0) then
	 	SET pagado = 'COMPLETO';
	END if;
	RETURN pagado;
	END;
//
DELIMITER ;

DELIMITER //
CREATE OR REPLACE FUNCTION f_deuda(clId INT)
RETURNS DECIMAL(10, 2)
	BEGIN
	RETURN (SELECT SUM(f_importePorPagar(pedidos.id))
		FROM pedidos
		WHERE pedidos.clienteId = clId);
	END;
//
DELIMITER ;
