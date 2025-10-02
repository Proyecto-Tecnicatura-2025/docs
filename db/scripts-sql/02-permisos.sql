USE keymasters;

CREATE USER IF NOT EXISTS 'api_cliente'@'%' IDENTIFIED BY '.';
CREATE USER IF NOT EXISTS 'api_publicador'@'%' IDENTIFIED BY '.';
CREATE USER IF NOT EXISTS 'api_backoffice'@'%' IDENTIFIED BY '.';
CREATE USER IF NOT EXISTS 'api_wallet'@'%' IDENTIFIED BY '.';

GRANT SELECT ON * TO 'api_cliente'@'%';
GRANT SELECT ON * TO 'api_publicador'@'%';

GRANT INSERT, UPDATE ON cliente TO 'api_cliente'@'%';
GRANT INSERT, UPDATE ON compra TO 'api_cliente'@'%';
GRANT INSERT, UPDATE ON reventa TO 'api_cliente'@'%';
GRANT INSERT, UPDATE, DELETE ON reporta_res TO 'api_cliente'@'%';
GRANT INSERT, UPDATE, DELETE ON reporta_com TO 'api_cliente'@'%';
GRANT INSERT, UPDATE, DELETE ON reporta_pub TO 'api_cliente'@'%';
GRANT INSERT, UPDATE, DELETE ON favorito TO 'api_cliente'@'%';
GRANT INSERT, UPDATE, DELETE ON upovote TO 'api_cliente'@'%';
GRANT INSERT, UPDATE ON transaccion TO 'api_cliente'@'%';
GRANT INSERT, UPDATE ON movimiento TO 'api_cliente'@'%';

GRANT INSERT, UPDATE ON publicador TO 'api_publicador'@'%';
GRANT INSERT, UPDATE, DELETE ON juego TO 'api_publicador'@'%';
GRANT INSERT, UPDATE, DELETE ON publica TO 'api_publicador'@'%';
GRANT INSERT, UPDATE, DELETE ON clave TO 'api_publicador'@'%';
GRANT INSERT, UPDATE, DELETE ON transaccion TO 'api_publicador'@'%';
GRANT INSERT, UPDATE, DELETE ON movimiento TO 'api_publicador'@'%';
GRANT INSERT, UPDATE, DELETE ON oferta TO 'api_publicador'@'%';
GRANT INSERT, UPDATE, DELETE ON genera TO 'api_publicador'@'%';
GRANT INSERT, UPDATE, DELETE ON asociada TO 'api_publicador'@'%';
GRANT INSERT, UPDATE, DELETE ON referencia TO 'api_publicador'@'%';
GRANT INSERT, UPDATE, DELETE ON publicidad TO 'api_publicador'@'%';
GRANT INSERT, UPDATE, DELETE ON media TO 'api_publicador'@'%';

GRANT INSERT, UPDATE ON motivo_reporte TO 'api_backoffice'@'%';
GRANT UPDATE ON compra TO 'api_backoffice'@'%';
GRANT UPDATE ON reventa TO 'api_backoffice'@'%';
GRANT INSERT, UPDATE ON movimiento TO 'api_backoffice'@'%';
GRANT UPDATE ON transaccion TO 'api_backoffice'@'%';
GRANT UPDATE ON publicador TO 'api_backoffice'@'%';
GRANT INSERT, UPDATE ON oferta TO 'api_backoffice'@'%';
GRANT INSERT, UPDATE ON genera TO 'api_backoffice'@'%';
GRANT INSERT, UPDATE ON referencia TO 'api_backoffice'@'%';
GRANT INSERT, UPDATE ON asociada TO 'api_backoffice'@'%';
GRANT INSERT, UPDATE ON juego TO 'api_publicador'@'%';
GRANT INSERT, UPDATE ON clave TO 'api_publicador'@'%';
GRANT INSERT, UPDATE, DELETE ON resena TO 'api_publicador'@'%';
GRANT INSERT, UPDATE, DELETE ON reporta_com TO 'api_publicador'@'%';
GRANT INSERT, UPDATE, DELETE ON reporta_res TO 'api_publicador'@'%';
GRANT INSERT, UPDATE, DELETE ON reporta_pub TO 'api_publicador'@'%';

GRANT INSERT, UPDATE ON wallet TO 'api_wallet'@'%';

FLUSH PRIVILEGES;
