# SSO del Producto — Flujos, Seguridad y Gobierno

## 1. Objetivo

Ofrecer Inicio de Sesión Único (SSO) para todas las aplicaciones de la suite, centralizando autenticación y consentimiento en un Proveedor de Identidad (IdP) y delegando autorización mediante OAuth 2.0 – Authorization Code + PKCE con permisos granulares por scopes.

---

## 2. Alcance & Roles

### 2.1 IdP (Auth Service)
Autentica usuarios, presenta consentimiento, emite JWT (access/refresh), gestiona clientes y claves.

### 2.2 Clientes (SPAs/web apps)
Se registran como public clients (sin secreto), inician el flujo PKCE y consumen APIs con el access_token.

### 2.3 APIs de negocio (resource servers)
Validan la firma del JWT con la clave pública del IdP y exigen scopes por endpoint.

### 2.4 SSO real
Una vez autenticado en el IdP, el usuario puede acceder a otras apps cliente sin volver a ingresar credenciales (podrá ver o no la hoja de consentimiento según políticas y scopes).

---

## 3. Flujos de autenticación

### 3.1 Inicio de sesión (Authorization Code + PKCE)

**Pasos del flujo:**

1. **La app cliente genera:**
    - `code_verifier` aleatorio.
    - `code_challenge = BASE64URL(SHA256(code_verifier))`.

2. **Redirige al IdP:**
    ```bash
    GET {AUTH_URL}/oauth/authorize
      ?client_id={CLIENT_ID}
      &redirect_uri={REDIRECT_URI}
      &response_type=code
      &scope={scopes_separados_por_espacio}
      &state={nonce_aleatorio}
      &code_challenge={BASE64URL_SHA256(verifier)}
      &code_challenge_method=S256
    ```

3. **El IdP autentica al usuario y muestra consentimiento de scopes.**

4. **Redirección a `{REDIRECT_URI}?code=...&state=...`.**

5. **La app canjea el código:**
    ```bash
    POST {AUTH_URL}/oauth/token
    Content-Type: application/x-www-form-urlencoded

    grant_type=authorization_code
    client_id={CLIENT_ID}
    redirect_uri={REDIRECT_URI}
    code={AUTH_CODE}
    code_verifier={ORIGINAL_VERIFIER}
    ```

6. **Resultado:**  
    `access_token` (JWT RS256), `token_type`, `expires_in` y opcional `refresh_token`.

**Por qué PKCE:**  
Evita la interceptación del authorization code; estándar actual para aplicaciones sin secreto.

### 3.2 Renovación de sesión

Con refresh_token cuando la experiencia lo requiere.

**Política sugerida:**

- access_token corto (p. ej., 15–60 min).
- refresh_token con expiración mayor y rotación.

### 3.3 Cierre de sesión

- **Cliente:** invalida su sesión local y redirige donde corresponda.
- **Global (opcional):** endpoint de sign-out en el IdP para cerrar la cookie/sesión del proveedor y propagar back-channel logout si se habilita.

---

## 4. Modelo de scopes (autorización)

| Dominio  | Scope           | Uso típico                        |
| -------- | --------------- | --------------------------------- |
| Perfil   | `profile:read`  | Mostrar datos básicos del usuario |
| Catálogo | `catalog:read`  | Navegación/consulta de ítems      |
| Catálogo | `catalog:write` | Altas/ediciones por publicadores  |
| Pedidos  | `orders:read`   | Listado/consulta de pedidos       |
| Pedidos  | `orders:write`  | Alta/actualización de pedidos     |

### Política

- Las apps deben solicitar mínimo necesario.
- Las APIs exigen scopes por ruta/acción.
- Cambios relevantes de scopes → re-consent automático.

---

## 5. Gobierno de clientes (onboarding)

Cada app se registra en el IdP con:

- client_id (sin client_secret por ser public client).
- Lista estricta de redirect_uris.
- grant_types = authorization_code (+ refresh_token si aplica).

El IdP valida coincidencia exacta del redirect_uri en la autorización (prevención de open redirect).

Revocación del cliente bloquea nuevos logins; tokens vigentes expiran normalmente (o pueden revocarse según política).

---

## 6. Integración con Active Directory (Opción A)

### 6.1 Estrategia

Active Directory es la fuente de verdad de identidades. El IdP valida credenciales contra AD por LDAPS, sincroniza/actualiza el usuario local y mapea grupos AD → scopes en los tokens emitidos.

#### 6.1.1 Configuración (variables de entorno)
```ini
LDAP_HOST=ad.corp.local
LDAP_PORT=636
LDAP_ENCRYPTION=ssl                 # LDAPS
LDAP_BASE_DN=DC=corp,DC=local
LDAP_BIND_DN=CN=svc_sso,OU=Svc,DC=corp,DC=local
LDAP_BIND_PASSWORD=********
LDAP_USER_FILTER=(|(sAMAccountName=%s)(userPrincipalName=%s))
LDAP_ATTR_MAIL=mail
LDAP_ATTR_NAME=displayName
LDAP_ATTR_UID=objectGUID            # identificador inmutable
```
- **Conexión:** LDAPS (certificado confiable del DC).
- **Service account:** privilegios de solo lectura para búsqueda y atributos.
- **Sin almacenar contraseñas AD:** el IdP guarda solo metadatos (email, nombre, external_id).

### 6.2 Mapeo grupos → scopes

Definir grupos AD que representen permisos del producto, p. ej.:

- GRP_Profile_Read → profile:read
- GRP_Catalog_Read → catalog:read
- GRP_Catalog_Write → catalog:write
- GRP_Orders_Read → orders:read
- GRP_Orders_Write → orders:write

**Lógica de emisión:**  
Scopes otorgados = intersección entre:

- Scopes solicitados por la app cliente, y
- Scopes permitidos al usuario (derivados de sus grupos AD).

**Ejemplo de configuración (pseudocódigo):**
```php
// config/ad_scopes.php
return [
    'groups_to_scopes' => [
        'GRP_Profile_Read'   => ['profile:read'],
        'GRP_Catalog_Read'   => ['catalog:read'],
        'GRP_Catalog_Write'  => ['catalog:write'],
        'GRP_Orders_Read'    => ['orders:read'],
        'GRP_Orders_Write'   => ['orders:write'],
    ],
];
```

---

## 7. Tokens y validación

### 7.1 Contenido del access_token (JWT RS256)

- iss (issuer), aud (audience), sub (id de usuario)
- exp, iat, nbf
- scope/scopes (lista de permisos otorgados)
- jti (id de token para auditoría)
- kid (opcional; facilita rotación de claves)

### 7.2 Validación en APIs

Las APIs deben:

- Extraer Authorization: Bearer <jwt>.
- Verificar firma y expiración con la clave pública del IdP (RS256).
- Extraer sub y scopes.
- Autorizar la ruta si el token contiene todos los scopes requeridos.

**Códigos estándar:**

- 401 Unauthorized: token ausente/inválido/expirado.
- 403 Forbidden: token válido sin los scopes exigidos.

Recomendado publicar la clave pública del IdP vía endpoint (p. ej. JWKS) para facilitar rotación.

---

## 8. Seguridad (controles clave)

- PKCE (S256): protege el intercambio del authorization code.
- CSRF: uso de state impredecible, validado a la vuelta.
- Redirects: coincidencia exacta de redirect_uri contra la lista blanca del cliente.
- Consentimiento: transparencia y control del usuario sobre scopes.
- TLS extremo a extremo.
- Rate limiting en login y protecciones anti-brute-force.
- JWT: algoritmo fijo (RS256), rechazo de none/simétricos; aud/iss esperados.
- Claves: almacenamiento restringido, permisos de archivo mínimos, rotación periódica.
- Auditoría: log de inicios de sesión, consentimientos, emisión/uso de tokens y revocaciones.

---

## 9. Políticas operativas

### 9.1 Ciclo de vida de tokens

- access_token: expiración corta (15–60 min).
- refresh_token: expiración mayor, rotación e invalidación en incidentes.

### 9.2 Rotación de llaves RSA

- Plan con nueva clave (kid), ventana de convivencia y retiro de la clave vieja.

### 9.3 Gestión de incidentes

- Compromiso de un cliente → revocación inmediata + bloqueo de redirects afectados.
- Compromiso de claves → rotación inmediata y forzar re-autenticación.

---

## 10. Alta de una nueva app (checklist)

- Definir scopes que la app necesita (mínimo necesario).
- Registrar cliente en el IdP: client_id, redirect_uris, grant_types.
- Configurar authorize URL en el frontend (PKCE S256 + state).
- Ajustar CORS y orígenes permitidos si corresponde.
- Exigir scopes en las APIs consumidas por la app.
- QA funcional: login, consentimiento, token válido, 403 por falta de scope, logout.

