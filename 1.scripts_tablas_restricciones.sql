DROP TABLE if EXISTS Devoluciones;
DROP TABLE if EXISTS Pagos;
DROP TABLE if EXISTS LineasPedido;
DROP TABLE if EXISTS Pedidos;
DROP TABLE if EXISTS EstadosPedido;
DROP TABLE if EXISTS EstadosPago;
DROP TABLE if EXISTS Productos;
DROP TABLE if EXISTS Clientes;
DROP TABLE if EXISTS Empleados;
DROP TABLE if EXISTS Usuarios;


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

CREATE TABLE Productos (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(255) NOT NULL,
    descripcion TEXT,
    precioUnitario DECIMAL(10, 2) NOT NULL CHECK (precioUnitario >= 0),
    valoracion TEXT
);

CREATE TABLE EstadosPago (
	id INT PRIMARY KEY AUTO_INCREMENT,
   nombre VARCHAR(255) NOT NULL
);

CREATE TABLE EstadosPedido (
	id INT PRIMARY KEY AUTO_INCREMENT,
   nombre VARCHAR(255) NOT NULL
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

CREATE TABLE Pagos(
	id INT PRIMARY KEY AUTO_INCREMENT,
	pedidoId INT,
	importe INT CHECK(importe >= 0),
	FOREIGN KEY (pedidoId) REFERENCES pedidos(id)
		ON DELETE CASCADE
		ON UPDATE CASCADE
);

CREATE TABLE Devoluciones(
	id INT PRIMARY KEY AUTO_INCREMENT,
	pedidoId INT NOT NULL,
	fechaSolicitud DATE NOT NULL,
	descripcion TEXT,
	FOREIGN KEY (pedidoId) REFERENCES pedidos(id)
		ON UPDATE CASCADE
);
