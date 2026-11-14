-- ==========================================================
-- FRESSIA — Datos de prueba
--
-- Cargar DESPUÉS de schema.sql (borra y vuelve a cargar todo).
-- Las fechas de los pedidos son relativas al momento de la carga,
-- así el panel siempre muestra ventas recientes.
--
-- Las fotos de los productos son de ejemplo (public/img/productos):
-- se reemplazan desde Panel → Productos.
--
-- Usuarios de prueba:
--   Cliente  demo@tienda.com   /  Demo1234
--   Admin    admin@tienda.com  /  Admin1234
--   Super    super@tienda.com  /  Super1234
--
-- Uso:  npm run db:instalar   (carga schema.sql + este archivo)
-- ==========================================================

USE tienda_velt;
SET NAMES utf8mb4;
SET time_zone = '-03:00';

SET FOREIGN_KEY_CHECKS = 0;
TRUNCATE TABLE notificaciones;
TRUNCATE TABLE arrepentimientos;
TRUNCATE TABLE pedido_items;
TRUNCATE TABLE pedidos;
TRUNCATE TABLE favoritos;
TRUNCATE TABLE especificaciones;
TRUNCATE TABLE producto_imagenes;
TRUNCATE TABLE producto_colores;
TRUNCATE TABLE productos;
TRUNCATE TABLE colores;
TRUNCATE TABLE subcategorias;
TRUNCATE TABLE categorias;
TRUNCATE TABLE cupones;
TRUNCATE TABLE usuarios;
SET FOREIGN_KEY_CHECKS = 1;
ALTER TABLE pedidos AUTO_INCREMENT = 1001;

-- ── Usuarios ─────────────────────────────────────────────
INSERT INTO usuarios (id, nombre, apellido, email, telefono, password, google_id, rol, newsletter) VALUES
  (1, 'Cliente', 'Demo', 'demo@tienda.com', '385 555 4444', '$2b$10$jX3V6AhKp.Par41X/kOWfelfguSzaU4z/IZkvYOv0UHGBQ/6Rl2Oy', NULL, 'cliente', 1),
  (2, 'Admin', 'Fressia', 'admin@tienda.com', NULL, '$2b$10$OUwf1N16MEgHBa5jhFt6K.cGjo4yUyiF/cOwUOBsyttSBQqgwMRYq', NULL, 'admin', 0),
  (3, 'Ana', 'Pérez', 'ana.perez@gmail.com', NULL, NULL, 'demo-ana.perez@gmail.com', 'cliente', 0),
  (4, 'Super', 'Admin', 'super@tienda.com', NULL, '$2b$10$AhElj/1kwG2mSrQCEpRKI.eaaUIicEpYgvqxK2sckmrfVXodWJpke', NULL, 'superadmin', 0);

-- ── Categorías, subcategorías y colores ──────────────────
INSERT INTO categorias (id, nombre, slug, orden) VALUES
  (1, 'Ropa', 'ropa', 1),
  (2, 'Accesorios', 'accesorios', 2),
  (3, 'Vestidos', 'vestidos', 3),
  (4, 'Bolsos', 'bolsos', 4);

INSERT INTO subcategorias (id, categoria_id, nombre, slug, orden) VALUES
  (1, 1, 'Tops', 'tops', 1),
  (2, 1, 'Conjuntos', 'conjuntos', 2),
  (3, 1, 'Jeans', 'jeans', 3),
  (4, 1, 'Blusas', 'blusas', 4),
  (5, 1, 'Sweaters', 'sweaters', 5),
  (6, 1, 'Buzos', 'buzos', 6),
  (7, 3, 'Cortos', 'cortos', 7),
  (8, 3, 'Largos', 'largos', 8);

INSERT INTO colores (id, valor, nombre, hex, orden) VALUES
  (1, 'negro', 'Negro', '#1d1a19', 1),
  (2, 'blanco', 'Blanco', '#f6f2ea', 2),
  (3, 'crudo', 'Crudo', '#ece2cf', 3),
  (4, 'verde-lima', 'Verde lima', '#a9d47e', 4),
  (5, 'amarillo', 'Amarillo', '#f1c84b', 5),
  (6, 'chocolate', 'Chocolate', '#5b3a2b', 6),
  (7, 'beige', 'Beige', '#d8c3a5', 7),
  (8, 'jean-negro', 'Jean negro', '#2b2b2f', 8),
  (9, 'marron', 'Marrón', '#7a5a48', 9);

-- ── Productos ────────────────────────────────────────────
INSERT INTO productos (id, nombre, categoria_id, subcategoria_id, color_id, precio, costo, stock, talles, etiqueta, resumen, descripcion, destacados) VALUES
  (1, 'Top Sicilia', 1, 1, 2, 24900, 12000, 18, 'S,M,L', 'Nuevo', 'Top drapeado con escote cascada y breteles finos. Fresco, liviano y súper femenino.', 'El top que levanta cualquier look: escote cascada que cae suave, breteles finos y largo corto ideal para usar con tiro alto.

Combinalo con pollera, jean o short.', 'Escote cascada
Breteles finos
Largo corto
Tela con caída'),
  (2, 'Jean Oxford Noche', 1, 3, 8, 38900, 18700, 14, '36,38,40,42,44', 'Más vendido', 'Jean oxford tiro alto en lavado negro, con bota bien amplia que estiliza la figura.', 'Tiro alto, pierna ajustada arriba y bota oxford bien abierta. Un clásico que alarga las piernas.

Denim con un toque de elastano para mayor comodidad.', 'Tiro alto
Bota oxford
Denim con elastano
Cinco bolsillos'),
  (3, 'Top Sol', 1, 1, 5, 18900, 9100, 20, 'S,M,L', NULL, 'Top halter con frunce central y lazo al cuello. Color amarillo sol.', 'Halter con frunce en el centro y atado al cuello para ajustarlo a tu gusto. El color que alegra cualquier outfit.', 'Escote halter
Frunce central
Atado al cuello'),
  (4, 'Musculosa Tejida Arena', 1, 1, 3, 22900, 11000, 16, 'S,M,L', 'Nuevo', 'Musculosa tejida con textura en relieve, cuello alto y tono arena.', 'Tejido de punto con textura ondulada, cuello alto y sisa americana. Queda divina con short de jean o pollera.', 'Tejido de punto
Cuello alto
Textura en relieve'),
  (5, 'Conjunto Lima', 1, 2, 4, 42900, 20600, 6, 'S,M,L', 'Oferta', 'Conjunto de top corset y short sastrero en verde lima.', 'Top con escote corazón y breteles anchos + short sastrero de tiro alto. Se pueden usar juntos o por separado.', 'Top escote corazón
Short tiro alto
Se usa por separado'),
  (6, 'Vestido Cacao', 3, 7, 6, 46900, 22500, 9, 'S,M,L', 'Nuevo', 'Vestido corto tejido al crochet con escote en V y breteles finos. Color chocolate.', 'Tejido calado artesanal, escote en V con abertura y largo mini. Perfecto para salir o para la playa sobre la bikini.', 'Tejido calado
Escote en V
Largo mini'),
  (7, 'Vestido Luna', 3, 8, 2, 54900, 26400, 7, 'S,M,L', NULL, 'Vestido largo blanco con escote cascada y falda de encaje.', 'Escote cascada, breteles finos y falda larga de encaje con caída. Para un evento especial o una noche de verano.', 'Escote cascada
Falda de encaje
Largo maxi'),
  (8, 'Vestido Capri', 3, 7, 3, 39900, 19200, 5, 'S,M,L', 'Edición limitada', 'Vestido corto con espalda descubierta y lazo al cuello.', 'Halter con espalda totalmente descubierta y lazo al cuello. Calce al cuerpo y largo mini.', 'Espalda descubierta
Lazo al cuello
Largo mini'),
  (9, 'Vestido Margarita', 3, 7, 2, 44900, 21600, 10, 'S,M,L', 'Nuevo', 'Vestido halter blanco con falda de volados en capas.', 'Escote halter con lazo, espalda descubierta y falda corta con volados. Romántico y fresco.', 'Escote halter
Falda con volados
Espalda descubierta'),
  (10, 'Sweater Polo Rayado', 1, 5, 9, 35900, 17200, 12, 'S,M,L,XL', NULL, 'Sweater de punto con cuello polo y rayas en tonos tierra.', 'Tejido suave, cuello polo con botones y rayas en marrón y beige. Para los días frescos con mucho estilo.', 'Cuello polo
Rayas tierra
Tejido suave'),
  (11, 'Buzo Estampado Cozy', 1, 6, 2, 32900, 15800, 15, 'S,M,L,XL', 'Oferta', 'Buzo de friza blanco con estampa en el frente. Abrigado y cómodo.', 'Friza invernal, calce oversize y estampa al frente. Ideal con jogger o pollera.', 'Friza invernal
Calce oversize
Estampa al frente'),
  (12, 'Blusa Romana', 1, 4, 2, 28900, 13900, 11, 'S,M,L', 'Más vendido', 'Blusa blanca con frente bordado, mangas largas y puños fruncidos.', 'Blusa con canesú bordado, mangas abullonadas y puño elastizado. Romántica, fresca y fácil de combinar.', 'Frente bordado
Mangas abullonadas
Puño elastizado');

-- Colores en que se vende cada producto (el primero es el principal)
INSERT INTO producto_colores (producto_id, color_id, orden) VALUES
  (1, 2, 0),
  (1, 1, 1),
  (2, 8, 0),
  (3, 5, 0),
  (3, 2, 1),
  (4, 3, 0),
  (5, 4, 0),
  (6, 6, 0),
  (7, 2, 0),
  (8, 3, 0),
  (9, 2, 0),
  (10, 9, 0),
  (10, 7, 1),
  (11, 2, 0),
  (12, 2, 0);

-- Fotos (la primera es la principal)
INSERT INTO producto_imagenes (producto_id, ruta, orden) VALUES
  (1, '/img/productos/top-sicilia-1.jpg', 0),
  (1, '/img/productos/top-sicilia-2.jpg', 1),
  (2, '/img/productos/jean-oxford-noche-1.jpg', 0),
  (3, '/img/productos/top-sol-1.jpg', 0),
  (4, '/img/productos/musculosa-tejida-arena-1.jpg', 0),
  (4, '/img/productos/musculosa-tejida-arena-2.jpg', 1),
  (5, '/img/productos/conjunto-lima-1.jpg', 0),
  (6, '/img/productos/vestido-cacao-1.jpg', 0),
  (7, '/img/productos/vestido-luna-1.jpg', 0),
  (8, '/img/productos/vestido-capri-1.jpg', 0),
  (9, '/img/productos/vestido-margarita-1.webp', 0),
  (9, '/img/productos/vestido-margarita-2.webp', 1),
  (10, '/img/productos/sweater-polo-rayado-1.jpg', 0),
  (11, '/img/productos/buzo-estampado-cozy-1.jpg', 0),
  (12, '/img/productos/blusa-romana-1.jpg', 0);

-- ── Ficha técnica ────────────────────────────────────────
INSERT INTO especificaciones (producto_id, clave, valor, orden) VALUES
  (1, 'Tela', 'Satén liviano', 1),
  (1, 'Calce', 'Al cuerpo', 2),
  (1, 'Largo', 'Corto', 3),
  (1, 'Cuidado', 'Lavar a mano o en ciclo delicado', 4),
  (2, 'Tela', 'Denim con elastano', 1),
  (2, 'Calce', 'Oxford', 2),
  (2, 'Tiro', 'Alto', 3),
  (2, 'Cuidado', 'Lavar a mano o en ciclo delicado', 4),
  (3, 'Tela', 'Fibrana', 1),
  (3, 'Calce', 'Ajustable', 2),
  (3, 'Largo', 'Corto', 3),
  (3, 'Cuidado', 'Lavar a mano o en ciclo delicado', 4),
  (4, 'Tela', 'Hilado de algodón', 1),
  (4, 'Calce', 'Al cuerpo', 2),
  (4, 'Cuello', 'Alto', 3),
  (4, 'Cuidado', 'Lavar a mano o en ciclo delicado', 4),
  (5, 'Tela', 'Lino viscosa', 1),
  (5, 'Incluye', 'Top + short', 2),
  (5, 'Tiro', 'Alto', 3),
  (5, 'Cuidado', 'Lavar a mano o en ciclo delicado', 4),
  (6, 'Tela', 'Tejido crochet', 1),
  (6, 'Calce', 'Al cuerpo', 2),
  (6, 'Largo', 'Mini', 3),
  (6, 'Cuidado', 'Lavar a mano o en ciclo delicado', 4),
  (7, 'Tela', 'Satén y encaje', 1),
  (7, 'Calce', 'Entallado', 2),
  (7, 'Largo', 'Maxi', 3),
  (7, 'Cuidado', 'Lavar a mano o en ciclo delicado', 4),
  (8, 'Tela', 'Lycra suave', 1),
  (8, 'Calce', 'Al cuerpo', 2),
  (8, 'Largo', 'Mini', 3),
  (8, 'Cuidado', 'Lavar a mano o en ciclo delicado', 4),
  (9, 'Tela', 'Algodón con textura', 1),
  (9, 'Calce', 'Entallado', 2),
  (9, 'Largo', 'Mini', 3),
  (9, 'Cuidado', 'Lavar a mano o en ciclo delicado', 4),
  (10, 'Tela', 'Punto acrílico', 1),
  (10, 'Calce', 'Relajado', 2),
  (10, 'Cuello', 'Polo', 3),
  (10, 'Cuidado', 'Lavar a mano o en ciclo delicado', 4),
  (11, 'Tela', 'Friza', 1),
  (11, 'Calce', 'Oversize', 2),
  (11, 'Estampa', 'Serigrafía', 3),
  (11, 'Cuidado', 'Lavar a mano o en ciclo delicado', 4),
  (12, 'Tela', 'Bambula', 1),
  (12, 'Calce', 'Suelto', 2),
  (12, 'Mangas', 'Largas', 3),
  (12, 'Cuidado', 'Lavar a mano o en ciclo delicado', 4);

-- ── Cupones ─────────────────────────────────────────────
INSERT INTO cupones (codigo, descripcion, porcentaje, activo, vence_en) VALUES
  ('BIENVENIDA', '10% off en tu primera compra', 0.1000, 1, NULL),
  ('FRESSIA5', '5% off de prueba', 0.0500, 1, NULL),
  ('VERANO20', '20% off de temporada (vencido)', 0.2000, 1, CURDATE() - INTERVAL 10 DAY);

-- ── Favoritos del cliente demo ──────────────────────────
INSERT INTO favoritos (usuario_id, producto_id) VALUES
  (1, 2),
  (1, 7),
  (1, 3);

-- ── Pedidos de los últimos 30 días (70) ─────────────────
INSERT INTO pedidos (id, usuario_id, cliente, email, telefono, entrega, calle, altura, piso, codigo_postal, ciudad, provincia, medio_pago, estado, subtotal, descuento, envio, total, costo, ganancia, creado_en) VALUES
  (1001, NULL, 'Agustina Torres', 'agustina.torres@mail.com', '385 4061981', 'retiro', NULL, NULL, NULL, NULL, NULL, NULL, 'tarjeta', 'entregado', 64000, 6400, 0, 57600, 32000, 25600, TIMESTAMP(CURDATE() - INTERVAL 29 DAY, '17:27:00')),
  (1002, 3, 'Ana Pérez', 'ana.perez@gmail.com', '385 4123514', 'domicilio', 'Av. Belgrano (S)', '1816', NULL, '4220', 'Termas de Río Hondo', 'Santiago del Estero', 'tarjeta', 'entregado', 29000, 0, 6500, 35500, 14000, 15000, TIMESTAMP(CURDATE() - INTERVAL 28 DAY, '11:34:00')),
  (1003, 3, 'Ana Pérez', 'ana.perez@gmail.com', '385 4649078', 'retiro', NULL, NULL, NULL, NULL, NULL, NULL, 'transferencia', 'entregado', 28000, 2800, 0, 25200, 13000, 12200, TIMESTAMP(CURDATE() - INTERVAL 28 DAY, '18:03:00')),
  (1004, NULL, 'Camila Martínez', 'camila.martinez@mail.com', '385 4536800', 'domicilio', 'Av. Belgrano (S)', '2594', NULL, '4220', 'Termas de Río Hondo', 'Santiago del Estero', 'transferencia', 'entregado', 213000, 21300, 0, 191700, 105000, 86700, TIMESTAMP(CURDATE() - INTERVAL 27 DAY, '10:07:00')),
  (1005, 1, 'Cliente Demo', 'demo@tienda.com', '385 4600861', 'retiro', NULL, NULL, NULL, NULL, NULL, NULL, 'transferencia', 'entregado', 78000, 7800, 0, 70200, 38000, 32200, TIMESTAMP(CURDATE() - INTERVAL 27 DAY, '21:35:00')),
  (1006, NULL, 'Sofía Rodríguez', 'sofia.rodriguez@mail.com', '385 4372731', 'retiro', NULL, NULL, NULL, NULL, NULL, NULL, 'tarjeta', 'entregado', 145000, 0, 0, 145000, 71000, 74000, TIMESTAMP(CURDATE() - INTERVAL 26 DAY, '09:29:00')),
  (1007, NULL, 'Lucas Herrera', 'lucas.herrera@mail.com', '385 4471007', 'retiro', NULL, NULL, NULL, NULL, NULL, NULL, 'tarjeta', 'entregado', 36000, 0, 0, 36000, 18000, 18000, TIMESTAMP(CURDATE() - INTERVAL 26 DAY, '10:10:00')),
  (1008, 1, 'Cliente Demo', 'demo@tienda.com', '385 4871464', 'retiro', NULL, NULL, NULL, NULL, NULL, NULL, 'tarjeta', 'entregado', 92000, 0, 0, 92000, 46000, 46000, TIMESTAMP(CURDATE() - INTERVAL 25 DAY, '09:31:00')),
  (1009, 3, 'Ana Pérez', 'ana.perez@gmail.com', '385 4686782', 'domicilio', 'Av. Belgrano (S)', '2928', NULL, '4300', 'La Banda', 'Santiago del Estero', 'tarjeta', 'entregado', 34000, 0, 6500, 40500, 17000, 17000, TIMESTAMP(CURDATE() - INTERVAL 25 DAY, '17:39:00')),
  (1010, NULL, 'Camila Martínez', 'camila.martinez@mail.com', '385 4158612', 'retiro', NULL, NULL, NULL, NULL, NULL, NULL, 'tarjeta', 'entregado', 216000, 0, 0, 216000, 106000, 110000, TIMESTAMP(CURDATE() - INTERVAL 24 DAY, '09:36:00')),
  (1011, 3, 'Ana Pérez', 'ana.perez@gmail.com', '385 4120956', 'domicilio', 'Av. Belgrano (S)', '1591', NULL, '5000', 'Córdoba', 'Córdoba', 'tarjeta', 'entregado', 39000, 0, 6500, 45500, 19000, 20000, TIMESTAMP(CURDATE() - INTERVAL 24 DAY, '16:07:00')),
  (1012, 1, 'Cliente Demo', 'demo@tienda.com', '385 4379324', 'domicilio', 'Av. Belgrano (S)', '194', NULL, '5000', 'Córdoba', 'Córdoba', 'transferencia', 'entregado', 64000, 6400, 6500, 64100, 31000, 26600, TIMESTAMP(CURDATE() - INTERVAL 23 DAY, '12:33:00')),
  (1013, NULL, 'Joaquín Acosta', 'joaquin.acosta@mail.com', '385 4233876', 'domicilio', 'Av. Belgrano (S)', '2159', NULL, '3500', 'Resistencia', 'Chaco', 'transferencia', 'cancelado', 66000, 6600, 6500, 65900, 33000, 26400, TIMESTAMP(CURDATE() - INTERVAL 23 DAY, '14:40:00')),
  (1014, 3, 'Ana Pérez', 'ana.perez@gmail.com', '385 4203051', 'domicilio', 'Av. Belgrano (S)', '1244', NULL, '3500', 'Resistencia', 'Chaco', 'tarjeta', 'entregado', 29000, 0, 6500, 35500, 14000, 15000, TIMESTAMP(CURDATE() - INTERVAL 22 DAY, '16:16:00')),
  (1015, 3, 'Ana Pérez', 'ana.perez@gmail.com', '385 4654381', 'retiro', NULL, NULL, NULL, NULL, NULL, NULL, 'tarjeta', 'entregado', 36000, 0, 0, 36000, 18000, 18000, TIMESTAMP(CURDATE() - INTERVAL 22 DAY, '12:30:00')),
  (1016, 3, 'Ana Pérez', 'ana.perez@gmail.com', '385 4666728', 'domicilio', 'Av. Belgrano (S)', '831', NULL, '4000', 'San Miguel de Tucumán', 'Tucumán', 'transferencia', 'entregado', 36000, 3600, 6500, 38900, 18000, 14400, TIMESTAMP(CURDATE() - INTERVAL 21 DAY, '15:50:00')),
  (1017, NULL, 'Facundo Ruiz', 'facundo.ruiz@mail.com', '385 4761654', 'domicilio', 'Av. Belgrano (S)', '187', NULL, '4300', 'La Banda', 'Santiago del Estero', 'tarjeta', 'cancelado', 142000, 0, 6500, 148500, 68000, 74000, TIMESTAMP(CURDATE() - INTERVAL 21 DAY, '09:51:00')),
  (1018, NULL, 'Valentina López', 'valentina.lopez@mail.com', '385 4948223', 'domicilio', 'Av. Belgrano (S)', '2813', NULL, '4000', 'San Miguel de Tucumán', 'Tucumán', 'tarjeta', 'entregado', 118000, 0, 6500, 124500, 57000, 61000, TIMESTAMP(CURDATE() - INTERVAL 20 DAY, '18:52:00')),
  (1019, 3, 'Ana Pérez', 'ana.perez@gmail.com', '385 4341817', 'retiro', NULL, NULL, NULL, NULL, NULL, NULL, 'tarjeta', 'entregado', 64000, 0, 0, 64000, 31000, 33000, TIMESTAMP(CURDATE() - INTERVAL 20 DAY, '17:03:00')),
  (1020, 3, 'Ana Pérez', 'ana.perez@gmail.com', '385 4642282', 'domicilio', 'Av. Belgrano (S)', '359', NULL, '3500', 'Resistencia', 'Chaco', 'transferencia', 'entregado', 65000, 6500, 6500, 65000, 32000, 26500, TIMESTAMP(CURDATE() - INTERVAL 19 DAY, '16:20:00')),
  (1021, 3, 'Ana Pérez', 'ana.perez@gmail.com', '385 4252328', 'retiro', NULL, NULL, NULL, NULL, NULL, NULL, 'tarjeta', 'entregado', 116000, 0, 0, 116000, 56000, 60000, TIMESTAMP(CURDATE() - INTERVAL 19 DAY, '10:42:00')),
  (1022, 1, 'Cliente Demo', 'demo@tienda.com', '385 4230254', 'domicilio', 'Av. Belgrano (S)', '1136', NULL, '4300', 'La Banda', 'Santiago del Estero', 'transferencia', 'entregado', 29000, 2900, 6500, 32600, 14000, 12100, TIMESTAMP(CURDATE() - INTERVAL 18 DAY, '11:29:00')),
  (1023, NULL, 'Tomás Díaz', 'tomas.diaz@mail.com', '385 4480951', 'retiro', NULL, NULL, NULL, NULL, NULL, NULL, 'tarjeta', 'entregado', 114000, 0, 0, 114000, 55000, 59000, TIMESTAMP(CURDATE() - INTERVAL 18 DAY, '14:35:00')),
  (1024, 1, 'Cliente Demo', 'demo@tienda.com', '385 4991954', 'domicilio', 'Av. Belgrano (S)', '1829', NULL, '3500', 'Resistencia', 'Chaco', 'tarjeta', 'entregado', 116000, 0, 6500, 122500, 56000, 60000, TIMESTAMP(CURDATE() - INTERVAL 17 DAY, '19:52:00')),
  (1025, NULL, 'Tomás Díaz', 'tomas.diaz@mail.com', '385 4075931', 'retiro', NULL, NULL, NULL, NULL, NULL, NULL, 'transferencia', 'entregado', 36000, 3600, 0, 32400, 18000, 14400, TIMESTAMP(CURDATE() - INTERVAL 17 DAY, '15:57:00')),
  (1026, NULL, 'Florencia Castro', 'florencia.castro@mail.com', '385 4189945', 'domicilio', 'Av. Belgrano (S)', '761', NULL, '4200', 'Santiago del Estero', 'Santiago del Estero', 'tarjeta', 'entregado', 158000, 0, 0, 158000, 76000, 82000, TIMESTAMP(CURDATE() - INTERVAL 17 DAY, '13:03:00')),
  (1027, NULL, 'Nicolás Álvarez', 'nicolas.alvarez@mail.com', '385 4468771', 'domicilio', 'Av. Belgrano (S)', '2044', NULL, '5000', 'Córdoba', 'Córdoba', 'transferencia', 'entregado', 130000, 13000, 6500, 123500, 64000, 53000, TIMESTAMP(CURDATE() - INTERVAL 16 DAY, '12:59:00')),
  (1028, NULL, 'Martina Gómez', 'martina.gomez@mail.com', '385 4697541', 'domicilio', 'Av. Belgrano (S)', '768', NULL, '4000', 'San Miguel de Tucumán', 'Tucumán', 'tarjeta', 'entregado', 179000, 17900, 0, 161100, 89000, 72100, TIMESTAMP(CURDATE() - INTERVAL 16 DAY, '09:05:00')),
  (1029, 1, 'Cliente Demo', 'demo@tienda.com', '385 4925251', 'domicilio', 'Av. Belgrano (S)', '1425', NULL, '5000', 'Córdoba', 'Córdoba', 'tarjeta', 'entregado', 70000, 0, 6500, 76500, 35000, 35000, TIMESTAMP(CURDATE() - INTERVAL 15 DAY, '12:02:00')),
  (1030, NULL, 'Mateo Sánchez', 'mateo.sanchez@mail.com', '385 4813944', 'retiro', NULL, NULL, NULL, NULL, NULL, NULL, 'tarjeta', 'entregado', 56000, 0, 0, 56000, 26000, 30000, TIMESTAMP(CURDATE() - INTERVAL 15 DAY, '12:32:00')),
  (1031, NULL, 'Facundo Ruiz', 'facundo.ruiz@mail.com', '385 4786998', 'domicilio', 'Av. Belgrano (S)', '2498', NULL, '4200', 'Santiago del Estero', 'Santiago del Estero', 'tarjeta', 'entregado', 42000, 0, 6500, 48500, 20000, 22000, TIMESTAMP(CURDATE() - INTERVAL 14 DAY, '17:54:00')),
  (1032, NULL, 'Martina Gómez', 'martina.gomez@mail.com', '385 4876422', 'retiro', NULL, NULL, NULL, NULL, NULL, NULL, 'tarjeta', 'entregado', 154000, 0, 0, 154000, 76000, 78000, TIMESTAMP(CURDATE() - INTERVAL 14 DAY, '10:24:00')),
  (1033, 1, 'Cliente Demo', 'demo@tienda.com', '385 4069258', 'domicilio', 'Av. Belgrano (S)', '476', NULL, '5000', 'Córdoba', 'Córdoba', 'transferencia', 'cancelado', 104000, 10400, 6500, 100100, 52000, 41600, TIMESTAMP(CURDATE() - INTERVAL 13 DAY, '19:33:00')),
  (1034, 1, 'Cliente Demo', 'demo@tienda.com', '385 4401143', 'retiro', NULL, NULL, NULL, NULL, NULL, NULL, 'transferencia', 'entregado', 42000, 4200, 0, 37800, 20000, 17800, TIMESTAMP(CURDATE() - INTERVAL 13 DAY, '16:54:00')),
  (1035, NULL, 'Camila Martínez', 'camila.martinez@mail.com', '385 4304985', 'domicilio', 'Av. Belgrano (S)', '991', NULL, '4400', 'Salta', 'Salta', 'transferencia', 'entregado', 90000, 9000, 6500, 87500, 43000, 38000, TIMESTAMP(CURDATE() - INTERVAL 13 DAY, '19:31:00')),
  (1036, 3, 'Ana Pérez', 'ana.perez@gmail.com', '385 4303655', 'domicilio', 'Av. Belgrano (S)', '451', NULL, '4220', 'Termas de Río Hondo', 'Santiago del Estero', 'transferencia', 'entregado', 36000, 3600, 6500, 38900, 18000, 14400, TIMESTAMP(CURDATE() - INTERVAL 12 DAY, '16:01:00')),
  (1037, 1, 'Cliente Demo', 'demo@tienda.com', '385 4999020', 'domicilio', 'Av. Belgrano (S)', '3161', NULL, '4300', 'La Banda', 'Santiago del Estero', 'tarjeta', 'entregado', 36000, 3600, 6500, 38900, 18000, 14400, TIMESTAMP(CURDATE() - INTERVAL 12 DAY, '17:16:00')),
  (1038, NULL, 'Agustina Torres', 'agustina.torres@mail.com', '385 4147542', 'retiro', NULL, NULL, NULL, NULL, NULL, NULL, 'tarjeta', 'entregado', 70000, 0, 0, 70000, 35000, 35000, TIMESTAMP(CURDATE() - INTERVAL 11 DAY, '13:46:00')),
  (1039, 1, 'Cliente Demo', 'demo@tienda.com', '385 4012291', 'retiro', NULL, NULL, NULL, NULL, NULL, NULL, 'tarjeta', 'entregado', 58000, 0, 0, 58000, 29000, 29000, TIMESTAMP(CURDATE() - INTERVAL 11 DAY, '12:45:00')),
  (1040, NULL, 'Nicolás Álvarez', 'nicolas.alvarez@mail.com', '385 4054124', 'retiro', NULL, NULL, NULL, NULL, NULL, NULL, 'tarjeta', 'entregado', 42000, 0, 0, 42000, 20000, 22000, TIMESTAMP(CURDATE() - INTERVAL 10 DAY, '13:06:00')),
  (1041, NULL, 'Martina Gómez', 'martina.gomez@mail.com', '385 4798653', 'retiro', NULL, NULL, NULL, NULL, NULL, NULL, 'tarjeta', 'entregado', 29000, 0, 0, 29000, 14000, 15000, TIMESTAMP(CURDATE() - INTERVAL 10 DAY, '09:51:00')),
  (1042, 1, 'Cliente Demo', 'demo@tienda.com', '385 4435019', 'retiro', NULL, NULL, NULL, NULL, NULL, NULL, 'transferencia', 'entregado', 130000, 13000, 0, 117000, 64000, 53000, TIMESTAMP(CURDATE() - INTERVAL 10 DAY, '11:30:00')),
  (1043, NULL, 'Nicolás Álvarez', 'nicolas.alvarez@mail.com', '385 4674449', 'retiro', NULL, NULL, NULL, NULL, NULL, NULL, 'transferencia', 'entregado', 34000, 3400, 0, 30600, 17000, 13600, TIMESTAMP(CURDATE() - INTERVAL 9 DAY, '10:10:00')),
  (1044, NULL, 'Facundo Ruiz', 'facundo.ruiz@mail.com', '385 4358566', 'domicilio', 'Av. Belgrano (S)', '1099', NULL, '4300', 'La Banda', 'Santiago del Estero', 'tarjeta', 'cancelado', 36000, 0, 6500, 42500, 18000, 18000, TIMESTAMP(CURDATE() - INTERVAL 9 DAY, '10:11:00')),
  (1045, 3, 'Ana Pérez', 'ana.perez@gmail.com', '385 4220206', 'domicilio', 'Av. Belgrano (S)', '1795', NULL, '4000', 'San Miguel de Tucumán', 'Tucumán', 'tarjeta', 'entregado', 39000, 0, 6500, 45500, 19000, 20000, TIMESTAMP(CURDATE() - INTERVAL 8 DAY, '20:33:00')),
  (1046, 1, 'Cliente Demo', 'demo@tienda.com', '385 4889855', 'domicilio', 'Av. Belgrano (S)', '2678', NULL, '5000', 'Córdoba', 'Córdoba', 'tarjeta', 'cancelado', 39000, 0, 6500, 45500, 19000, 20000, TIMESTAMP(CURDATE() - INTERVAL 8 DAY, '21:55:00')),
  (1047, NULL, 'Facundo Ruiz', 'facundo.ruiz@mail.com', '385 4800787', 'domicilio', 'Av. Belgrano (S)', '232', NULL, '4300', 'La Banda', 'Santiago del Estero', 'tarjeta', 'entregado', 58000, 0, 6500, 64500, 28000, 30000, TIMESTAMP(CURDATE() - INTERVAL 8 DAY, '15:45:00')),
  (1048, 1, 'Cliente Demo', 'demo@tienda.com', '385 4678793', 'retiro', NULL, NULL, NULL, NULL, NULL, NULL, 'tarjeta', 'entregado', 108000, 0, 0, 108000, 54000, 54000, TIMESTAMP(CURDATE() - INTERVAL 7 DAY, '20:44:00')),
  (1049, 1, 'Cliente Demo', 'demo@tienda.com', '385 4667199', 'domicilio', 'Av. Belgrano (S)', '2666', NULL, '4300', 'La Banda', 'Santiago del Estero', 'tarjeta', 'entregado', 32000, 0, 6500, 38500, 16000, 16000, TIMESTAMP(CURDATE() - INTERVAL 7 DAY, '13:33:00')),
  (1050, 1, 'Cliente Demo', 'demo@tienda.com', '385 4246172', 'retiro', NULL, NULL, NULL, NULL, NULL, NULL, 'tarjeta', 'entregado', 135000, 0, 0, 135000, 66000, 69000, TIMESTAMP(CURDATE() - INTERVAL 6 DAY, '16:33:00')),
  (1051, 3, 'Ana Pérez', 'ana.perez@gmail.com', '385 4238908', 'retiro', NULL, NULL, NULL, NULL, NULL, NULL, 'tarjeta', 'entregado', 32000, 0, 0, 32000, 16000, 16000, TIMESTAMP(CURDATE() - INTERVAL 6 DAY, '10:16:00')),
  (1052, 1, 'Cliente Demo', 'demo@tienda.com', '385 4529403', 'domicilio', 'Av. Belgrano (S)', '1296', NULL, '4200', 'Santiago del Estero', 'Santiago del Estero', 'tarjeta', 'enviado', 29000, 0, 6500, 35500, 14000, 15000, TIMESTAMP(CURDATE() - INTERVAL 6 DAY, '20:54:00')),
  (1053, NULL, 'Mateo Sánchez', 'mateo.sanchez@mail.com', '385 4940023', 'retiro', NULL, NULL, NULL, NULL, NULL, NULL, 'transferencia', 'entregado', 65000, 6500, 0, 58500, 32000, 26500, TIMESTAMP(CURDATE() - INTERVAL 5 DAY, '18:11:00')),
  (1054, NULL, 'Camila Martínez', 'camila.martinez@mail.com', '385 4746622', 'domicilio', 'Av. Belgrano (S)', '1711', NULL, '4300', 'La Banda', 'Santiago del Estero', 'transferencia', 'pagado', 96000, 9600, 6500, 92900, 48000, 38400, TIMESTAMP(CURDATE() - INTERVAL 5 DAY, '16:57:00')),
  (1055, NULL, 'Joaquín Acosta', 'joaquin.acosta@mail.com', '385 4696705', 'retiro', NULL, NULL, NULL, NULL, NULL, NULL, 'transferencia', 'entregado', 42000, 4200, 0, 37800, 20000, 17800, TIMESTAMP(CURDATE() - INTERVAL 4 DAY, '09:19:00')),
  (1056, 1, 'Cliente Demo', 'demo@tienda.com', '385 4795664', 'retiro', NULL, NULL, NULL, NULL, NULL, NULL, 'tarjeta', 'entregado', 39000, 3900, 0, 35100, 19000, 16100, TIMESTAMP(CURDATE() - INTERVAL 4 DAY, '10:35:00')),
  (1057, NULL, 'Tomás Díaz', 'tomas.diaz@mail.com', '385 4940565', 'domicilio', 'Av. Belgrano (S)', '1424', NULL, '4300', 'La Banda', 'Santiago del Estero', 'tarjeta', 'entregado', 34000, 0, 6500, 40500, 17000, 17000, TIMESTAMP(CURDATE() - INTERVAL 4 DAY, '14:47:00')),
  (1058, 1, 'Cliente Demo', 'demo@tienda.com', '385 4783587', 'retiro', NULL, NULL, NULL, NULL, NULL, NULL, 'tarjeta', 'pagado', 58000, 5800, 0, 52200, 29000, 23200, TIMESTAMP(CURDATE() - INTERVAL 3 DAY, '13:12:00')),
  (1059, NULL, 'Lucas Herrera', 'lucas.herrera@mail.com', '385 4003954', 'retiro', NULL, NULL, NULL, NULL, NULL, NULL, 'transferencia', 'enviado', 39000, 3900, 0, 35100, 19000, 16100, TIMESTAMP(CURDATE() - INTERVAL 3 DAY, '13:19:00')),
  (1060, 3, 'Ana Pérez', 'ana.perez@gmail.com', '385 4158665', 'retiro', NULL, NULL, NULL, NULL, NULL, NULL, 'transferencia', 'enviado', 194000, 19400, 0, 174600, 96000, 78600, TIMESTAMP(CURDATE() - INTERVAL 3 DAY, '20:49:00')),
  (1061, 3, 'Ana Pérez', 'ana.perez@gmail.com', '385 4167706', 'domicilio', 'Av. Belgrano (S)', '908', NULL, '5000', 'Córdoba', 'Córdoba', 'transferencia', 'pagado', 39000, 3900, 6500, 41600, 19000, 16100, TIMESTAMP(CURDATE() - INTERVAL 2 DAY, '15:48:00')),
  (1062, NULL, 'Tomás Díaz', 'tomas.diaz@mail.com', '385 4441513', 'domicilio', 'Av. Belgrano (S)', '444', NULL, '5000', 'Córdoba', 'Córdoba', 'tarjeta', 'enviado', 32000, 0, 6500, 38500, 16000, 16000, TIMESTAMP(CURDATE() - INTERVAL 2 DAY, '12:06:00')),
  (1063, 1, 'Cliente Demo', 'demo@tienda.com', '385 4194758', 'domicilio', 'Av. Belgrano (S)', '1899', NULL, '4300', 'La Banda', 'Santiago del Estero', 'tarjeta', 'pendiente', 136000, 0, 6500, 142500, 67000, 69000, NOW() - INTERVAL 268 MINUTE),
  (1064, NULL, 'Mateo Sánchez', 'mateo.sanchez@mail.com', '385 4038821', 'domicilio', 'Av. Belgrano (S)', '511', NULL, '4400', 'Salta', 'Salta', 'tarjeta', 'pagado', 34000, 0, 6500, 40500, 17000, 17000, NOW() - INTERVAL 490 MINUTE),
  (1065, NULL, 'Florencia Castro', 'florencia.castro@mail.com', '385 4390318', 'retiro', NULL, NULL, NULL, NULL, NULL, NULL, 'transferencia', 'pagado', 63000, 6300, 0, 56700, 31000, 25700, NOW() - INTERVAL 91 MINUTE),
  (1066, 3, 'Ana Pérez', 'ana.perez@gmail.com', '385 4356533', 'domicilio', 'Av. Belgrano (S)', '253', NULL, '4300', 'La Banda', 'Santiago del Estero', 'transferencia', 'pendiente', 36000, 3600, 6500, 38900, 18000, 14400, NOW() - INTERVAL 392 MINUTE),
  (1067, NULL, 'Florencia Castro', 'florencia.castro@mail.com', '385 4213288', 'domicilio', 'Av. Belgrano (S)', '1378', NULL, '5000', 'Córdoba', 'Córdoba', 'tarjeta', 'pagado', 34000, 0, 6500, 40500, 17000, 17000, NOW() - INTERVAL 94 MINUTE),
  (1068, NULL, 'Camila Martínez', 'camila.martinez@mail.com', '385 4438142', 'domicilio', 'Av. Belgrano (S)', '2835', NULL, '4220', 'Termas de Río Hondo', 'Santiago del Estero', 'tarjeta', 'pagado', 94000, 0, 6500, 100500, 47000, 47000, NOW() - INTERVAL 329 MINUTE),
  (1069, NULL, 'Nicolás Álvarez', 'nicolas.alvarez@mail.com', '385 4015554', 'domicilio', 'Av. Belgrano (S)', '765', NULL, '4000', 'San Miguel de Tucumán', 'Tucumán', 'tarjeta', 'pendiente', 146000, 0, 6500, 152500, 71000, 75000, NOW() - INTERVAL 148 MINUTE),
  (1070, NULL, 'Valentina López', 'valentina.lopez@mail.com', '385 4970456', 'domicilio', 'Av. Belgrano (S)', '2234', NULL, '4300', 'La Banda', 'Santiago del Estero', 'tarjeta', 'pendiente', 58000, 0, 6500, 64500, 29000, 29000, NOW() - INTERVAL 190 MINUTE);

-- Cobro: los pedidos pagados/enviados/entregados tienen el pago aprobado
UPDATE pedidos SET pago_estado = 'aprobado', pagado_en = creado_en
WHERE estado IN ('pagado', 'enviado', 'entregado');
UPDATE pedidos
SET pago_detalle = ELT(1 + MOD(id, 4), 'Visa terminada en 4242 · 3 cuotas', 'Mastercard terminada en 5100 · 1 cuota',
                       'Naranja terminada en 6019 · 6 cuotas', 'Dinero en cuenta de Mercado Pago'),
    pago_id = CONCAT('demo-', id)
WHERE medio_pago = 'tarjeta' AND pago_estado = 'aprobado';
UPDATE pedidos SET pago_detalle = 'Transferencia acreditada'
WHERE medio_pago = 'transferencia' AND pago_estado = 'aprobado';

-- Dirección guardada del cliente demo (se usa para completar el checkout)
UPDATE usuarios SET dni = '30111222', calle = 'Av. Belgrano (S)', altura = '1450', codigo_postal = '4200',
       ciudad = 'Santiago del Estero', provincia = 'Santiago del Estero'
WHERE email = 'demo@tienda.com';

UPDATE pedidos SET actualizado_en = creado_en;

-- ── Renglones de los pedidos (117) ─────────────────────────
INSERT INTO pedido_items (pedido_id, producto_id, nombre, color, talle, precio, costo, cantidad) VALUES
  (1001, 1, 'Top Sicilia', 'Blanco', 'S', 24900, 12000, 1),
  (1001, 1, 'Top Sicilia', 'Blanco', 'M', 24900, 12000, 1),
  (1002, 4, 'Musculosa Tejida Arena', 'Crudo', 'S', 22900, 11000, 1),
  (1003, 3, 'Top Sol', 'Amarillo', 'M', 18900, 9100, 1),
  (1004, 7, 'Vestido Luna', 'Blanco', 'L', 54900, 26400, 2),
  (1004, 6, 'Vestido Cacao', 'Chocolate', 'M', 46900, 22500, 1),
  (1004, 4, 'Musculosa Tejida Arena', 'Crudo', 'L', 22900, 11000, 2),
  (1005, 6, 'Vestido Cacao', 'Chocolate', 'S', 46900, 22500, 2),
  (1006, 6, 'Vestido Cacao', 'Chocolate', 'M', 46900, 22500, 1),
  (1006, 2, 'Jean Oxford Noche', 'Jean negro', '44', 38900, 18700, 1),
  (1006, 1, 'Top Sicilia', 'Blanco', 'L', 24900, 12000, 2),
  (1007, 8, 'Vestido Capri', 'Crudo', 'M', 39900, 19200, 1),
  (1008, 5, 'Conjunto Lima', 'Verde lima', 'S', 42900, 20600, 1),
  (1008, 7, 'Vestido Luna', 'Blanco', 'S', 54900, 26400, 1),
  (1009, 5, 'Conjunto Lima', 'Verde lima', 'S', 42900, 20600, 1),
  (1010, 7, 'Vestido Luna', 'Blanco', 'L', 54900, 26400, 2),
  (1010, 2, 'Jean Oxford Noche', 'Jean negro', '44', 38900, 18700, 1),
  (1010, 4, 'Musculosa Tejida Arena', 'Crudo', 'M', 22900, 11000, 2),
  (1011, 6, 'Vestido Cacao', 'Chocolate', 'S', 46900, 22500, 1),
  (1012, 8, 'Vestido Capri', 'Crudo', 'L', 39900, 19200, 1),
  (1012, 3, 'Top Sol', 'Amarillo', 'L', 18900, 9100, 1),
  (1013, 1, 'Top Sicilia', 'Blanco', 'L', 24900, 12000, 1),
  (1013, 5, 'Conjunto Lima', 'Verde lima', 'M', 42900, 20600, 1),
  (1014, 4, 'Musculosa Tejida Arena', 'Crudo', 'M', 22900, 11000, 1),
  (1015, 8, 'Vestido Capri', 'Crudo', 'L', 39900, 19200, 1),
  (1016, 8, 'Vestido Capri', 'Crudo', 'S', 39900, 19200, 1),
  (1017, 7, 'Vestido Luna', 'Blanco', 'S', 54900, 26400, 1),
  (1017, 3, 'Top Sol', 'Amarillo', 'M', 18900, 9100, 1),
  (1017, 3, 'Top Sol', 'Amarillo', 'M', 18900, 9100, 2),
  (1018, 3, 'Top Sol', 'Amarillo', 'M', 18900, 9100, 1),
  (1018, 1, 'Top Sicilia', 'Blanco', 'M', 24900, 12000, 1),
  (1018, 4, 'Musculosa Tejida Arena', 'Crudo', 'L', 22900, 11000, 2),
  (1019, 3, 'Top Sol', 'Amarillo', 'L', 18900, 9100, 1),
  (1019, 8, 'Vestido Capri', 'Crudo', 'S', 39900, 19200, 1),
  (1020, 8, 'Vestido Capri', 'Crudo', 'S', 39900, 19200, 1),
  (1020, 4, 'Musculosa Tejida Arena', 'Crudo', 'S', 22900, 11000, 1),
  (1021, 4, 'Musculosa Tejida Arena', 'Crudo', 'M', 22900, 11000, 2),
  (1021, 4, 'Musculosa Tejida Arena', 'Crudo', 'M', 22900, 11000, 2),
  (1022, 4, 'Musculosa Tejida Arena', 'Crudo', 'S', 22900, 11000, 1),
  (1023, 3, 'Top Sol', 'Amarillo', 'M', 18900, 9100, 2),
  (1023, 7, 'Vestido Luna', 'Blanco', 'S', 54900, 26400, 1),
  (1024, 1, 'Top Sicilia', 'Blanco', 'L', 24900, 12000, 1),
  (1024, 2, 'Jean Oxford Noche', 'Jean negro', '40', 38900, 18700, 1),
  (1024, 2, 'Jean Oxford Noche', 'Jean negro', '42', 38900, 18700, 1),
  (1025, 8, 'Vestido Capri', 'Crudo', 'S', 39900, 19200, 1),
  (1026, 2, 'Jean Oxford Noche', 'Jean negro', '38', 38900, 18700, 1),
  (1026, 2, 'Jean Oxford Noche', 'Jean negro', '38', 38900, 18700, 2),
  (1026, 1, 'Top Sicilia', 'Blanco', 'S', 24900, 12000, 1),
  (1027, 5, 'Conjunto Lima', 'Verde lima', 'L', 42900, 20600, 2),
  (1027, 3, 'Top Sol', 'Amarillo', 'L', 18900, 9100, 1),
  (1027, 5, 'Conjunto Lima', 'Verde lima', 'S', 42900, 20600, 1),
  (1028, 7, 'Vestido Luna', 'Blanco', 'L', 54900, 26400, 2),
  (1028, 5, 'Conjunto Lima', 'Verde lima', 'M', 42900, 20600, 1),
  (1028, 4, 'Musculosa Tejida Arena', 'Crudo', 'L', 22900, 11000, 1),
  (1029, 5, 'Conjunto Lima', 'Verde lima', 'L', 42900, 20600, 1),
  (1029, 8, 'Vestido Capri', 'Crudo', 'M', 39900, 19200, 1),
  (1030, 3, 'Top Sol', 'Amarillo', 'L', 18900, 9100, 2),
  (1031, 2, 'Jean Oxford Noche', 'Jean negro', '44', 38900, 18700, 1),
  (1032, 7, 'Vestido Luna', 'Blanco', 'S', 54900, 26400, 1),
  (1032, 5, 'Conjunto Lima', 'Verde lima', 'S', 42900, 20600, 2),
  (1032, 3, 'Top Sol', 'Amarillo', 'S', 18900, 9100, 1),
  (1033, 1, 'Top Sicilia', 'Blanco', 'S', 24900, 12000, 1),
  (1033, 8, 'Vestido Capri', 'Crudo', 'S', 39900, 19200, 2),
  (1034, 2, 'Jean Oxford Noche', 'Jean negro', '40', 38900, 18700, 1),
  (1035, 5, 'Conjunto Lima', 'Verde lima', 'M', 42900, 20600, 1),
  (1035, 3, 'Top Sol', 'Amarillo', 'L', 18900, 9100, 1),
  (1035, 3, 'Top Sol', 'Amarillo', 'S', 18900, 9100, 1),
  (1036, 8, 'Vestido Capri', 'Crudo', 'M', 39900, 19200, 1),
  (1037, 8, 'Vestido Capri', 'Crudo', 'L', 39900, 19200, 1),
  (1038, 5, 'Conjunto Lima', 'Verde lima', 'L', 42900, 20600, 1),
  (1038, 8, 'Vestido Capri', 'Crudo', 'S', 39900, 19200, 1),
  (1039, 7, 'Vestido Luna', 'Blanco', 'M', 54900, 26400, 1),
  (1040, 2, 'Jean Oxford Noche', 'Jean negro', '44', 38900, 18700, 1),
  (1041, 4, 'Musculosa Tejida Arena', 'Crudo', 'S', 22900, 11000, 1),
  (1042, 4, 'Musculosa Tejida Arena', 'Crudo', 'S', 22900, 11000, 2),
  (1042, 8, 'Vestido Capri', 'Crudo', 'L', 39900, 19200, 2),
  (1043, 5, 'Conjunto Lima', 'Verde lima', 'L', 42900, 20600, 1),
  (1044, 8, 'Vestido Capri', 'Crudo', 'S', 39900, 19200, 1),
  (1045, 6, 'Vestido Cacao', 'Chocolate', 'L', 46900, 22500, 1),
  (1046, 6, 'Vestido Cacao', 'Chocolate', 'L', 46900, 22500, 1),
  (1047, 4, 'Musculosa Tejida Arena', 'Crudo', 'S', 22900, 11000, 2),
  (1048, 8, 'Vestido Capri', 'Crudo', 'S', 39900, 19200, 2),
  (1048, 8, 'Vestido Capri', 'Crudo', 'M', 39900, 19200, 1),
  (1049, 1, 'Top Sicilia', 'Blanco', 'M', 24900, 12000, 1),
  (1050, 2, 'Jean Oxford Noche', 'Jean negro', '38', 38900, 18700, 1),
  (1050, 4, 'Musculosa Tejida Arena', 'Crudo', 'L', 22900, 11000, 1),
  (1050, 1, 'Top Sicilia', 'Blanco', 'L', 24900, 12000, 2),
  (1051, 1, 'Top Sicilia', 'Blanco', 'L', 24900, 12000, 1),
  (1052, 4, 'Musculosa Tejida Arena', 'Crudo', 'S', 22900, 11000, 1),
  (1053, 4, 'Musculosa Tejida Arena', 'Crudo', 'M', 22900, 11000, 1),
  (1053, 8, 'Vestido Capri', 'Crudo', 'L', 39900, 19200, 1),
  (1054, 1, 'Top Sicilia', 'Blanco', 'M', 24900, 12000, 2),
  (1054, 1, 'Top Sicilia', 'Blanco', 'S', 24900, 12000, 1),
  (1055, 2, 'Jean Oxford Noche', 'Jean negro', '42', 38900, 18700, 1),
  (1056, 6, 'Vestido Cacao', 'Chocolate', 'M', 46900, 22500, 1),
  (1057, 5, 'Conjunto Lima', 'Verde lima', 'S', 42900, 20600, 1),
  (1058, 7, 'Vestido Luna', 'Blanco', 'L', 54900, 26400, 1),
  (1059, 6, 'Vestido Cacao', 'Chocolate', 'L', 46900, 22500, 1),
  (1060, 2, 'Jean Oxford Noche', 'Jean negro', '40', 38900, 18700, 1),
  (1060, 8, 'Vestido Capri', 'Crudo', 'M', 39900, 19200, 1),
  (1060, 7, 'Vestido Luna', 'Blanco', 'M', 54900, 26400, 2),
  (1061, 6, 'Vestido Cacao', 'Chocolate', 'L', 46900, 22500, 1),
  (1062, 1, 'Top Sicilia', 'Blanco', 'L', 24900, 12000, 1),
  (1063, 8, 'Vestido Capri', 'Crudo', 'M', 39900, 19200, 1),
  (1063, 7, 'Vestido Luna', 'Blanco', 'M', 54900, 26400, 1),
  (1063, 2, 'Jean Oxford Noche', 'Jean negro', '42', 38900, 18700, 1),
  (1064, 5, 'Conjunto Lima', 'Verde lima', 'L', 42900, 20600, 1),
  (1065, 4, 'Musculosa Tejida Arena', 'Crudo', 'L', 22900, 11000, 1),
  (1065, 5, 'Conjunto Lima', 'Verde lima', 'S', 42900, 20600, 1),
  (1066, 8, 'Vestido Capri', 'Crudo', 'S', 39900, 19200, 1),
  (1067, 5, 'Conjunto Lima', 'Verde lima', 'M', 42900, 20600, 1),
  (1068, 8, 'Vestido Capri', 'Crudo', 'S', 39900, 19200, 1),
  (1068, 7, 'Vestido Luna', 'Blanco', 'S', 54900, 26400, 1),
  (1069, 6, 'Vestido Cacao', 'Chocolate', 'M', 46900, 22500, 1),
  (1069, 6, 'Vestido Cacao', 'Chocolate', 'M', 46900, 22500, 2),
  (1069, 4, 'Musculosa Tejida Arena', 'Crudo', 'M', 22900, 11000, 1),
  (1070, 7, 'Vestido Luna', 'Blanco', 'L', 54900, 26400, 1);

ALTER TABLE pedidos AUTO_INCREMENT = 1071;

-- ── Notificaciones para el admin (las 2 compras más recientes, sin leer) ──
INSERT INTO notificaciones (tipo, titulo, mensaje, url, pedido_id, leida, creado_en)
SELECT 'pedido',
       CONCAT('Nueva compra #', id),
       CONCAT(cliente, ' · $', FORMAT(total, 2, 'es_AR')),
       CONCAT('/admin/pedidos?q=', id),
       id, 0, creado_en
  FROM pedidos
 ORDER BY creado_en DESC
 LIMIT 2;
