DROP TABLE IF EXISTS Devoluciones;
DROP TABLE IF EXISTS Pagos;
DROP TABLE IF EXISTS LineasPedido;
DROP TABLE IF EXISTS Pedidos;
DROP TABLE IF EXISTS Productos;
DROP TABLE IF EXISTS Clientes;
DROP TABLE IF EXISTS Empleados;
DROP TABLE IF EXISTS Usuarios;


CREATE TABLE Usuarios (
    id INT PRIMARY KEY AUTO_INCREMENT,
    email VARCHAR(255) UNIQUE NOT NULL,
    contraseña VARCHAR(255) NOT NULL,
    nombre VARCHAR(255) NOT NULL,
    apellidos VARCHAR(255) NOT NULL,
    telefono VARCHAR(255) NOT NULL
);

CREATE TABLE Empleados (
    id INT PRIMARY KEY AUTO_INCREMENT,
    fechaIncorporacion DATE NOT NULL,
    usuarioId INT UNIQUE NOT NULL,
    salario DECIMAL(10, 2) NOT NULL CHECK (salario > 0),
    FOREIGN KEY (usuarioId) REFERENCES Usuarios(id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE Clientes (
    id INT PRIMARY KEY AUTO_INCREMENT,
    usuarioId INT UNIQUE NOT NULL,
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
    stock INT NOT NULL DEFAULT 0 CHECK (stock >= 0),
    valoracion INT(2) CHECK (valoracion >= 1 AND valoracion <= 10)
);

CREATE TABLE Pedidos (
    id INT PRIMARY KEY AUTO_INCREMENT,
    fechaRealizacion DATE NOT NULL DEFAULT (CURRENT_DATE()),
    fechaEnvio DATE,
    fechaEntrega DATE,
    comentario TEXT,
    valoracion INT(2) CHECK (valoracion >= 1 AND valoracion <= 10),
    clienteId INT NOT NULL,
    empleadoId INT,
    FOREIGN KEY (clienteId) REFERENCES Clientes(id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
    FOREIGN KEY (empleadoId) REFERENCES Empleados(id)
        ON DELETE SET NULL
        ON UPDATE CASCADE,
    CONSTRAINT chk_fechas_pedido CHECK (
        (fechaEnvio IS NULL OR fechaEnvio >= fechaRealizacion) AND
        (fechaEntrega IS NULL OR (fechaEnvio IS NOT NULL AND fechaEntrega >= fechaEnvio))
    )
);

CREATE TABLE LineasPedido (
    id INT PRIMARY KEY AUTO_INCREMENT,
    pedidoId INT NOT NULL,
    productoId INT NOT NULL,
    cantidadProducto INT NOT NULL CHECK (cantidadProducto > 0),
    precioUnitario DECIMAL(10, 2) NOT NULL CHECK (precioUnitario >= 0),
    FOREIGN KEY (pedidoId) REFERENCES Pedidos(id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (productoId) REFERENCES Productos(id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
    UNIQUE (pedidoId, productoId)
);

CREATE TABLE Pagos (
    id INT PRIMARY KEY AUTO_INCREMENT,
    pedidoId INT NOT NULL,
    importe DECIMAL(10, 2) NOT NULL CHECK (importe > 0),
    FOREIGN KEY (pedidoId) REFERENCES Pedidos(id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE Devoluciones (
    id INT PRIMARY KEY AUTO_INCREMENT,
    pedidoId INT UNIQUE NOT NULL,
    fechaSolicitud DATE NOT NULL,
    descripcion TEXT,
    FOREIGN KEY (pedidoId) REFERENCES Pedidos(id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);
