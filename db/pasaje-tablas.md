Cliente(**id_cliente**, nombre, correo, es\_miembro, nick)

Publicador(**id_publicador**, nombre, correo, aprobado, reputación)

Juego(**id_juego**, *id_publicador*, genero, idioma, region, plataforma, titulo, descripción, distribuidor, requisitos\_sistema, caractersísticas, fecha\_lanzamiento)

Publica(***id_juego***, ***id_clave***, fecha)

Clave(**id_clave**, <u>clave</u>, precio, fecha)

Compra**id_compra**, fecha, *id_clave*, *id_cliente*, monto, estado)

Reventa(***id_compra***, **fecha_reventa**, precio)

Reseña(***id_cliente***, ***id_juego***, fecha, cuerpo)

Reporta_res(**id_reporte**, motivo)

Favorito(***id_cliente***, ***id_juego***)

Upovote(***id_cliente***, ***id_juego***, es_positivo)
