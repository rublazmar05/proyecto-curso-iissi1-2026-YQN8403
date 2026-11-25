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
	SET pagado = IFNULL((SELECT SUM(pagos.importe)
		FROM pagos
		WHERE pagos.pedidoId = pedId), 0);
	RETURN f_precioTotal(pedId) - pagado;
	END;
//
DELIMITER ;

DELIMITER //
CREATE OR REPLACE FUNCTION f_estadoPago(pedId INT)
RETURNS VARCHAR(255)
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
	RETURN IFNULL((SELECT SUM(f_importePorPagar(pedidos.id))
		FROM pedidos
		WHERE pedidos.clienteId = clId), 0);
	END;
//
DELIMITER ;

DELIMITER //
CREATE OR REPLACE FUNCTION f_estadoPedido(pedId INT)
RETURNS VARCHAR(255)
	BEGIN
	DECLARE fEnvio DATE;
	DECLARE fEntrega DATE;
	DECLARE est VARCHAR(255);

	SELECT fechaEnvio, fechaEntrega INTO fEnvio, fEntrega
	FROM pedidos
	WHERE id = pedId;

	if (fEntrega IS NOT NULL) then
		SET est = 'ENTREGADO';
	elseif (fEnvio IS NOT NULL) then
		SET est = 'EN_CAMINO';
	else
		SET est = 'PROCESANDO_PEDIDO';
	END if;

	RETURN est;
	END;
//
DELIMITER ;

DELIMITER //
CREATE OR REPLACE FUNCTION f_pedidosEnCurso(empId INT)
RETURNS INT
	BEGIN
	RETURN (SELECT COUNT(*)
		FROM pedidos
		WHERE pedidos.empleadoId = empId
		  AND f_estadoPedido(pedidos.id) <> 'ENTREGADO');
	END;
//
DELIMITER ;
