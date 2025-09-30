Cliente(**id_cliente**, <u>*id_wallet*</u>, correo, es\_miembro, nick)

Publicador(**id_publicador**, <u>*id_wallet*</u>, nombre, correo, aprobado, reputación)

Juego(**id_juego**, *id_publicador*, genero, idioma, region, plataforma, titulo, descripción, distribuidor, requisitos\_sistema, caractersísticas, fecha\_lanzamiento)

Publica(***id_juego***, ***id_clave***, fecha)

Clave(**id_clave**, <u>valor</u>, precio)

Compra(**id_compra**, *id_clave*, *id_cliente*, *id_transaccion*, fecha, monto, estado)

Reventa(***id_compra***, ***id_cliente***, **fecha_reventa**, precio)

Resena(**id_resena**, *id_cliente*, *id_juego*, fecha, cuerpo)

Reporta\_res(***id_cliente***, ***id_resena***, fecha)

Reporta\_pub(***id_juego***, ***id_cliente***, motivo, detalle, fecha)

Reporta\_com(***id_compra***, ***id_cliente***, motivo, detalle, fecha)

Favorito(***id_cliente***, ***id_juego***)

Upovote(***id_cliente***, ***id_juego***, es\_positivo)

Wallet(**id_wallet**, monto\_total)

Transaccion(**id_transaccion**, *id_wallet_origen*, *id_wallet_destino*, fecha, monto, referencia)

Movimiento(**id_movimiento**, *id_cliente*, *id_wallet*, positivo\_negativo, monto, concepto, fecha)

Oferta(**id_oferta**, titulo, tipo, valor, fecha\_inicio, fecha\_fin, activa, cupon)

Genera(***id_juego***, ***id_oferta***)

Asociada(***id_oferta***, ***id_publicidad***)

Referencia(***id_juego***, ***id_publicidad***)

Publicidad(**id_publicidad**, nombre, redireccionamiento, url\_media, fecha\_inicio, fecha\_fin, activa)

Media(**id_media**, ***id_juego***, url, ubicacion, orden)
