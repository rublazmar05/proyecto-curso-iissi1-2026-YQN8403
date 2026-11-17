INSERT INTO usuarios(email, contraseña, nombre, telefono)
VALUES
('elsapogeneroso@hotmail.com', 'Juan1308', 'Juan Hernández', '376493180'),
('vicguerodkumafu@gmail.com', 'Chi90dor_43', 'Víctor Guerra', '376493180');

INSERT INTO clientes(usuarioId, direccionEnvio)
VALUES
(1, 'Calle Miguel de Cervantes nº1');

INSERT INTO empleados(fechaIncorporacion, usuarioId, salario)
VALUES
('2020-10-02', 2, 19800);

INSERT INTO pedidos(fechaEnvio, fechaEntrega, direccionEntrega, comentario, valoracion, clienteId, empleadoId, fechaRealizacion)
VALUES
('2026-11-13', '2026-11-14', 'Calle Miguel de Cervantes nº1', 'Muy buen trato', 9, 1, 1, '2026-11-13');

INSERT INTO productos (nombre, descripcion, precioUnitario, valoracion)
VALUES
('Camisa Kumafu', 'Camiseta con el logo de Kumafu', 15.99, 8),
('Pantalón Kumafu', 'Pantalón con el logo de Kumafu', 21.99, 7),
('Chaqueta Kumafu', 'Chaqueta con el logo de Kumafu', 45.49, 9);

INSERT INTO lineaspedido(pedidoId, productoId, cantidadProducto, precioUnitario)
VALUES
(1, 3, 1, 45);
