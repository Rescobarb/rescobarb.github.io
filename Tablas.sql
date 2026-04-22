USE sys

CREATE TABLE AUDITORIA_PEDIDOS (
    id_auditoria INT AUTO_INCREMENT PRIMARY KEY,
    id_pedido INT,
    usuario_bd VARCHAR(50),
    fecha_evento DATETIME,
    accion VARCHAR(50)
);

CREATE TABLE CATEGORIA (
    id_categoria INT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL
);

CREATE TABLE CLIENTE (
    id_cliente INT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    fecha_registro DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE PEDIDO (
    id_pedido INT PRIMARY KEY,
    id_cliente INT,
    fecha_pedido DATETIME DEFAULT CURRENT_TIMESTAMP,
    estado VARCHAR(20) DEFAULT 'PENDIENTE',
    CONSTRAINT fk_ped_cli FOREIGN KEY (id_cliente) REFERENCES CLIENTE(id_cliente)
);

CREATE TABLE PRODUCTO (
    id_producto INT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    precio DECIMAL(10,2),
    stock INT,
    id_categoria INT,
    CONSTRAINT fk_prod_cat FOREIGN KEY (id_categoria) REFERENCES CATEGORIA(id_categoria)
);

CREATE TABLE DETALLE_PEDIDO (
    id_pedido INT,
    id_producto INT,
    cantidad INT,
    precio_unit DECIMAL(10,2),
    CONSTRAINT pk_detalle PRIMARY KEY (id_pedido, id_producto),
    CONSTRAINT fk_det_ped FOREIGN KEY (id_pedido) REFERENCES PEDIDO(id_pedido),
    CONSTRAINT fk_det_prod FOREIGN KEY (id_producto) REFERENCES PRODUCTO(id_producto)
);

CREATE TABLE HISTORICO_PRECIOS (
    id_producto INT,
    precio_anterior DECIMAL(10,2),
    precio_nuevo DECIMAL(10,2),
    fecha_cambio DATETIME,
    CONSTRAINT fk_hist_pre FOREIGN KEY (id_producto) REFERENCES PRODUCTO(id_producto)
);