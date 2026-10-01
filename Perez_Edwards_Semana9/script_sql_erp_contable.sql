-- ============================================
-- 1. CREACIÓN DE BASE DE DATOS Y USUARIO
-- ============================================
CREATE DATABASE IF NOT EXISTS erp_contable_ep CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE erp_contable_ep;

-- Crear usuario específico (buena práctica de seguridad)
CREATE USER IF NOT EXISTS 'erp_user'@'localhost' IDENTIFIED BY 'erp2026';
GRANT ALL PRIVILEGES ON erp_contable_ep.* TO 'erp_user'@'localhost';
FLUSH PRIVILEGES;

-- ============================================
-- 2. TABLA DE CONTACTOS
-- ============================================
-- Almacena clientes y proveedores del ERP
CREATE TABLE IF NOT EXISTS contactos (
  id INT AUTO_INCREMENT PRIMARY KEY,          -- Identificador único autoincremental
  nombre VARCHAR(100) NOT NULL,               -- Nombre del contacto (obligatorio)
  rfc VARCHAR(13) UNIQUE NOT NULL,            -- RFC único para evitar duplicados
  tipo ENUM('Cliente', 'Proveedor') NOT NULL, -- Solo permite 'Cliente' o 'Proveedor'
  email VARCHAR(100),                         -- Correo electrónico (opcional)
  telefono VARCHAR(20),                       -- Teléfono (opcional)
  fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP -- Fecha automática de creación
);

-- ============================================
-- 3. TABLA DE MOVIMIENTOS (CAJA/BANCO)
-- ============================================
-- Registra ingresos y egresos de tesorería
CREATE TABLE IF NOT EXISTS movimientos (
  id INT AUTO_INCREMENT PRIMARY KEY,          -- Identificador único autoincremental
  concepto VARCHAR(200) NOT NULL,             -- Descripción del movimiento
  tipo ENUM('Ingreso', 'Egreso') NOT NULL,    -- Solo permite 'Ingreso' o 'Egreso'
  monto DECIMAL(10,2) NOT NULL CHECK (monto > 0), -- Monto con 2 decimales, siempre positivo
  fecha DATE NOT NULL,                        -- Fecha del movimiento (obligatoria)
  contacto_id INT,                            -- FK: referencia al contacto asociado
  fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- Fecha automática de creación
  -- Relación con la tabla contactos:
  -- Si se elimina un contacto, sus movimientos NO se borran, solo queda contacto_id = NULL
  FOREIGN KEY (contacto_id) REFERENCES contactos(id) ON DELETE SET NULL
);

-- ============================================
-- 4. DATOS DE PRUEBA (CON HUELLA DIGITAL)
-- ============================================
-- Limpiar tablas por si se corre de nuevo
TRUNCATE TABLE movimientos;
-- TRUNCATE TABLE contactos puede dar error por FK, mejor un DELETE
DELETE FROM movimientos;
DELETE FROM contactos;
ALTER TABLE contactos AUTO_INCREMENT = 1;
ALTER TABLE movimientos AUTO_INCREMENT = 1;

INSERT INTO contactos (nombre, rfc, tipo, email) VALUES
('Edwards Pérez', 'EP12345678RFC', 'Cliente', 'edwards@email.com'),
('Proveedor Global', 'PGL987654XYZ', 'Proveedor', 'ventas@global.com');

INSERT INTO movimientos (concepto, tipo, monto, fecha, contacto_id) VALUES
('Ajuste inicial Cédula: 32533151', 'Ingreso', 1500.00, '2026-09-15', 1),
('Compra de insumos', 'Egreso', 450.50, '2026-09-16', 2);
