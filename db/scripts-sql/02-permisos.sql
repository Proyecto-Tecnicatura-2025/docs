USE keymasters;

CREATE USER IF NOT EXISTS 'cliente'@'localhost' IDENTIFIED BY 'cliente_password';
CREATE USER IF NOT EXISTS 'publicador'@'localhost' IDENTIFIED BY 'publicador_password';

GRANT SELECT ON * TO 'cliente'@'localhost';
GRANT SELECT ON * TO 'publicador'@'localhost';

GRANT INSERT, UPDATE ON Cliente TO 'cliente'@'localhost';
GRANT INSERT, UPDATE ON Compra TO 'cliente'@'localhost';
GRANT INSERT, UPDATE ON Reventa TO 'cliente'@'localhost';
GRANT INSERT, UPDATE ON Wallet TO 'cliente'@'localhost';
GRANT INSERT, UPDATE, DELETE ON Reporta_res TO 'cliente'@'localhost';
GRANT INSERT, UPDATE, DELETE ON Reporta_com TO 'cliente'@'localhost';
GRANT INSERT, UPDATE, DELETE ON Reporta_pub TO 'cliente'@'localhost';
GRANT INSERT, UPDATE, DELETE ON Favorito TO 'cliente'@'localhost';
GRANT INSERT, UPDATE, DELETE ON Upovote TO 'cliente'@'localhost';
GRANT INSERT, UPDATE ON Transaccion TO 'cliente'@'localhost';
GRANT INSERT, UPDATE ON Movimiento TO 'cliente'@'localhost';

GRANT INSERT, UPDATE ON Publicador TO 'publicador'@'localhost';
GRANT INSERT, UPDATE ON Wallet TO 'cliente'@'localhost';
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

FLUSH PRIVILEGES;
