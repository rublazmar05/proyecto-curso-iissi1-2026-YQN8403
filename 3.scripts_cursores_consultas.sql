-- Vista del precio total, la parte pagada y el estado del/de los pago/s

DROP VIEW if EXISTS preciototalypartepagada;

CREATE VIEW precioTotalYPartePagada AS
SELECT pedidos.id AS pedidoId,
SUM(lineaspedido.precioUnitario * lineaspedido.cantidadProducto) AS precioTotal,
ifNull(SUM(pagos.importe), 0) AS partePagada,
if(SUM(lineaspedido.precioUnitario * lineaspedido.cantidadProducto) =
	ifnull(SUM(pagos.importe), 0), 
	'COMPLETO', 'PENDIENTE') AS estadoPago
FROM pedidos
JOIN lineaspedido
ON pedidos.id = lineaspedido.pedidoId
LEFT JOIN pagos
ON pedidos.id = pagos.pedidoId
GROUP BY pedidos.id;

-- Vista de la deuda de cada cliente

CREATE OR REPLACE VIEW deudaClientes AS
SELECT clientes.id,
SUM(precioTotal - partePagada) AS deuda
FROM clientes
JOIN pedidos
ON clientes.id = pedidos.clienteId
JOIN preciototalypartepagada
ON pedidos.id = preciototalypartepagada.pedidoId
WHERE preciototalypartepagada.estadoPago = 'PENDIENTE'
GROUP BY clientes.id;
