CREATE USER IF NOT EXISTS 'cliente'@'localhost' IDENTIFIED BY 'cliente_password';
CREATE USER IF NOT EXISTS 'publicador'@'localhost' IDENTIFIED BY 'publicador_password';

GRANT SELECT ON videojuegos.* TO 'cliente'@'localhost';
GRANT SELECT ON videojuegos.* TO 'publicador'@'localhost';

GRANT INSERT, UPDATE ON videojuegos.Cliente TO 'cliente'@'localhost';
GRANT INSERT, UPDATE ON videojuegos.Compra TO 'cliente'@'localhost';
GRANT INSERT, UPDATE ON videojuegos.Reventa TO 'cliente'@'localhost';
GRANT INSERT, UPDATE, DELETE ON videojuegos.Reporta_res TO 'cliente'@'localhost';
GRANT INSERT, UPDATE, DELETE ON videojuegos.Reporta_com TO 'cliente'@'localhost';
GRANT INSERT, UPDATE, DELETE ON videojuegos.Reporta_pub TO 'cliente'@'localhost';
GRANT INSERT, UPDATE, DELETE ON videojuegos.Favorito TO 'cliente'@'localhost';
GRANT INSERT, UPDATE, DELETE ON videojuegos.Upovote TO 'cliente'@'localhost';
GRANT INSERT, UPDATE ON videojuegos.Transaccion TO 'cliente'@'localhost';
GRANT INSERT, UPDATE ON videojuegos.Movimiento TO 'cliente'@'localhost';

GRANT INSERT, UPDATE ON Publicador TO 'publicador'@'localhost';
GRANT INSERT, UPDATE, DELETE ON Juego TO 'publicador'@'localhost';
GRANT INSERT, UPDATE, DELETE ON Publica TO 'publicador'@'localhost';
GRANT INSERT, UPDATE, DELETE ON Clave TO 'publicador'@'localhost';
GRANT INSERT, UPDATE, DELETE ON Transaccion TO 'publicador'@'localhost';
GRANT INSERT, UPDATE, DELETE ON Movimiento TO 'publicador'@'localhost';
GRANT INSERT, UPDATE, DELETE ON Oferta TO 'publicador'@'localhost';
GRANT INSERT, UPDATE, DELETE ON Genera TO 'publicador'@'localhost';
GRANT INSERT, UPDATE, DELETE ON Asociada TO 'publicador'@'localhost';
GRANT INSERT, UPDATE, DELETE ON Referencia TO 'publicador'@'localhost';
GRANT INSERT, UPDATE, DELETE ON Publicidad TO 'publicador'@'localhost';
GRANT INSERT, UPDATE, DELETE ON Media TO 'publicador'@'localhost';
