DROP TABLE if EXISTS devoluciones;
DROP TABLE if EXISTS pagos;
DROP TABLE if EXISTS lineasPedido;
DROP TABLE if EXISTS pedidos;
DROP TABLE if EXISTS estadosPedido;
DROP TABLE if EXISTS estadosPago;
DROP TABLE if EXISTS productos;
DROP TABLE if EXISTS clientes;
DROP TABLE if EXISTS empleados;
DROP TABLE if EXISTS usuarios;


CREATE TABLE Usuarios (
    id INT PRIMARY KEY AUTO_INCREMENT,
    email VARCHAR(255) UNIQUE NOT NULL,
    contraseña VARCHAR(255) NOT NULL,
    nombre VARCHAR(255) NOT NULL,
    telefono INT(15)
);

CREATE TABLE Empleados (
    id INT PRIMARY KEY AUTO_INCREMENT,
    fechaIncorporacion DATE NOT NULL,
    usuarioId INT NOT NULL,
    salario DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (usuarioId) REFERENCES Usuarios(id)
        ON DELETE CASCADE 
        ON UPDATE CASCADE
);

CREATE TABLE Clientes (
    id INT PRIMARY KEY AUTO_INCREMENT,
    usuarioId INT NOT NULL,
    direccionEnvio VARCHAR(255) NOT NULL,
    FOREIGN KEY (usuarioId) REFERENCES Usuarios(id)
        ON DELETE CASCADE 
        ON UPDATE CASCADE
);

CREATE TABLE Pedidos (
    id INT PRIMARY KEY AUTO_INCREMENT,
    fechaRealizacion DATE NOT NULL,
    fechaEnvio DATE,
    fechaEntrega DATE,
    direccionEntrega VARCHAR(255) NOT NULL,
    comentario TEXT,
    valoracion TEXT,
    clienteId INT NOT NULL,
    empleadoId INT,
    FOREIGN KEY (clienteId) REFERENCES Clientes(id) 
        ON DELETE RESTRICT 
        ON UPDATE RESTRICT,
    FOREIGN KEY (empleadoId) REFERENCES Empleados(id) 
        ON DELETE SET NULL 
        ON UPDATE SET NULL
);

CREATE TABLE Productos (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(255) NOT NULL,
    descripcion TEXT,
    precioUnitario DECIMAL(10, 2) NOT NULL CHECK (precioUnitario >= 0),
    valoracion TEXT
);

CREATE TABLE LineasPedido (
    id INT PRIMARY KEY AUTO_INCREMENT,
    pedidoId INT NOT NULL,
    productoId INT NOT NULL,
    cantidadProducto INT NOT NULL,
    precioUnitario DECIMAL(10, 2) NOT NULL CHECK (precioUnitario >= 0),
    FOREIGN KEY (pedidoId) REFERENCES Pedidos(id),
    FOREIGN KEY (productoId) REFERENCES Productos(id),
    UNIQUE (pedidoId, productoId)
);

CREATE TABLE pagos(
	id INT PRIMARY KEY AUTO_INCREMENT,
	importe INT CHECK(importe >= 0)
);
