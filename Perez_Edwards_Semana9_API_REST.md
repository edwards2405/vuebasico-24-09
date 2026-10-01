# Documentación API REST - ERP Contable (Tesorería)

**Nombre y apellido del estudiante:** Edwards Pérez
**Cédula de identidad:** 32533151
**Carrera:** Informática - 5to Semestre
**Unidad Curricular:** Interfaces Web con el Usuario
**Docente:** Ing. José Daniel Cadenas L.
**Fecha de entrega:** Jueves 01/10/2026
**Semana:** 9

---

## 1. DIAGRAMA ENTIDAD-RELACIÓN

![DER ERP Contable](./DER_erp_contable.png)

**Descripción breve del modelo:**
El modelo cuenta con dos entidades principales: `contactos` (que almacena tanto clientes como proveedores) y `movimientos` (que registra ingresos y egresos de caja o banco). La relación es de 1 a muchos (1:N) entre `contactos` y `movimientos`, ya que un contacto puede tener múltiples movimientos asociados, pero cada movimiento pertenece, a lo sumo, a un contacto. Se utiliza la restricción `ON DELETE SET NULL` para asegurar que si se elimina un contacto, los movimientos no se pierdan, quedando huérfanos pero contabilizados.

---

## 2. DOCUMENTACIÓN DE LAS 4 PETICIONES

### 2.1 Crear cliente (POST /api/contactos)
- **Descripción del endpoint:** Crea un nuevo registro en la tabla `contactos`.
- **Request:**
  - **Método:** POST
  - **URL:** `http://localhost:3000/api/contactos`
  - **Headers:** `Content-Type: application/json`
  - **Body:**
    ```json
    { 
      "nombre": "Distribuidora Los Andes C.A.", 
      "rfc": "DLA2026100101", 
      "tipo": "Cliente", 
      "email": "ventas@andes.com", 
      "telefono": "0412-1234567" 
    }
    ```
- **Response:** Status Code `201 Created`
  ```json
  {
    "exito": true,
    "mensaje": "Contacto creado exitosamente",
    "datos": {
      "id": 3,
      "nombre": "Distribuidora Los Andes C.A.",
      "rfc": "DLA2026100101",
      "tipo": "Cliente"
    }
  }
  ```
- *[Inserta aquí la captura de pantalla de Postman]*

### 2.2 Registrar movimiento (POST /api/movimientos)
- **Descripción del endpoint:** Inserta un nuevo flujo de caja o banco en la tabla `movimientos`.
- **Request:**
  - **Método:** POST
  - **URL:** `http://localhost:3000/api/movimientos`
  - **Headers:** `Content-Type: application/json`
  - **Body:**
    ```json
    { 
      "concepto": "Venta de servicios de consultoría", 
      "tipo": "Ingreso", 
      "monto": 2500.00, 
      "fecha": "2026-10-01", 
      "contacto_id": 3 
    }
    ```
- **Response:** Status Code `201 Created`
  ```json
  {
    "exito": true,
    "mensaje": "Movimiento registrado",
    "datos": {
      "id": 3,
      "concepto": "Venta de servicios de consultoría",
      "tipo": "Ingreso",
      "monto": 2500.00,
      "fecha": "2026-10-01"
    }
  }
  ```
- *[Inserta aquí la captura de pantalla de Postman]*

### 2.3 Consultar datos (GET /api/movimientos)
- **Descripción del endpoint:** Devuelve el listado de todos los movimientos registrados junto con el nombre del contacto asociado (JOIN).
- **Request:**
  - **Método:** GET
  - **URL:** `http://localhost:3000/api/movimientos`
  - **Headers:** Ninguno
- **Response:** Status Code `200 OK`
  *[Copia aquí el JSON que te devuelva el servidor]*
- *[Inserta aquí la captura de pantalla de Postman]*

### 2.4 Generar reporte (GET /api/resumen)
- **Descripción del endpoint:** Devuelve los totales de ingresos, egresos, saldo neto y número total de movimientos.
- **Request:**
  - **Método:** GET
  - **URL:** `http://localhost:3000/api/resumen`
  - **Headers:** Ninguno
- **Response:** Status Code `200 OK`
  *[Copia aquí el JSON que te devuelva el servidor]*
- *[Inserta aquí la captura de pantalla de Postman]*

---

## 3. TABLA DE CÓDIGOS DE ESTADO HTTP

| Código | Significado | Uso en el ERP |
|--------|-------------|---------------|
| 200    | OK          | Consultas exitosas (ej. GET /api/contactos) y PUT exitoso. |
| 201    | Created     | Recursos creados exitosamente (ej. POST /api/contactos). |
| 400    | Bad Request | Validaciones fallidas (campos vacíos, montos negativos, RFC duplicado). |
| 404    | Not Found   | Recursos no encontrados (ej. ID de contacto que no existe). |
| 500    | Server Error| Error interno, fallo de conexión a MySQL, bug en el código. |

---

## 4. VALIDACIÓN DE PRECISIÓN CONTABLE

**Tabla de cálculos manuales (basado en los pasos del ejercicio 7.1):**

| Concepto | Cálculo manual |
|----------|----------------|
| Total Ingresos | 1500.00 + 2500.00 = **$4,000.00** |
| Total Egresos | 450.50 + 200.00 = **$650.50** |
| Saldo | 4000.00 - 650.50 = **$3,349.50** |
| Total movimientos | **4** |

**Respuesta del endpoint /api/resumen:**
*[Pega aquí la respuesta del endpoint obtenida tras hacer los 4 POST de la prueba de precisión]*

**Conclusión de la comparación:**
*[Escribe aquí la conclusión. Por ejemplo: "Los valores arrojados por el endpoint coinciden numéricamente de manera exacta con mis cálculos manuales, confirmando que las agregaciones SQL (SUM y CASE) operan correctamente."]*

---

## 5. PREGUNTAS REFLEXIVAS

**Pregunta 1 — Sobre el DER**
*Explica la relación entre las entidades contactos y movimientos. ¿Por qué elegiste cardinalidad 1:N y no N:M? ¿Qué pasaría si un movimiento pudiera tener múltiples contactos? ¿Cómo cambiaría el modelo de datos?*
**Respuesta:** Elegí cardinalidad 1:N porque un movimiento (una factura o un recibo) normalmente está asociado a un único cliente o proveedor específico. Si la relación fuera N:M, implicaría que un solo movimiento podría dividirse entre múltiples entidades, lo cual requeriría una tabla intermedia (`contacto_movimiento`) para registrar qué porción del monto le pertenece a quién, lo que haría la consulta de saldos individuales más compleja.

**Pregunta 2 — Sobre persistencia**
*Compara el comportamiento de tu servidor en la Semana 7-8 (datos en memoria RAM) con el de la Semana 9 (datos en MySQL). ¿Qué ventajas reales observaste al migrar? Menciona al menos 3 ventajas concretas.*
**Respuesta:** En las semanas anteriores los datos se perdían cada vez que nodemon reiniciaba el servidor, ahora la persistencia es permanente, lo cual es obligatorio en producción. Tres ventajas clave: 1) Los datos no se pierden al reiniciar. 2) Integridad garantizada mediante restricciones y llaves foráneas a nivel de base de datos. 3) Consultas complejas más óptimas como agrupaciones (SUM), delegando ese procesamiento al motor de base de datos en lugar de usar ciclos en JavaScript.

**Pregunta 3 — Sobre códigos HTTP**
*Si un estudiante intenta crear un movimiento con monto negativo, ¿qué código HTTP debería recibir y por qué? Explica la diferencia entre un error 400 (Bad Request) y un error 500 (Server Error) en el contexto de este ERP.*
**Respuesta:** Debería recibir un código 400 (Bad Request) porque es un error del cliente al mandar datos que violan una regla de negocio del sistema. La diferencia radica en la responsabilidad: el error 400 indica que la petición estaba mal estructurada o contenía datos inválidos (como un monto menor a 0), mientras que un 500 indica un fallo interno en nuestro código o pérdida de conexión con MySQL.

**Pregunta 4 — Sobre validaciones**
*¿Por qué es importante validar los datos en el backend (Express) y no solo en el frontend (Vue)? Da un ejemplo concreto de qué pasaría si un usuario malintencionado envía datos inválidos directamente a la API saltándose el frontend.*
**Respuesta:** Es vital porque el frontend puede ser manipulado o interceptado (e.g. usando Postman). Si un usuario malintencionado mandara directamente una petición a la API con un monto de -50000 como ingreso (sin validación en backend), alteraría nuestro saldo de la empresa inyectando datos corruptos que el motor contable asimilaría como reales.

**Pregunta 5 — Sobre precisión contable**
*En el Ejercicio 7 comparaste cálculos manuales con la respuesta del endpoint /api/resumen. ¿Por qué es crítica esta validación en un sistema financiero? ¿Qué consecuencias tendría un error de redondeo o cálculo en un sistema real de tesorería?*
**Respuesta:** En un sistema financiero, los errores de redondeo se propagan. Un céntimo mal calculado en millones de transacciones se traduce en faltantes (o sobrantes) de miles de dólares en las cuentas bancarias reales. La precisión contable y las validaciones de tipo (e.g. asegurar parseos correctos y uso de DECIMAL) aseguran que el sistema informático refleje fielmente la realidad del dinero que posee la organización.

---

## 6. PRUEBA DE FUEGO - DEFENSA EN VIVO

### Reto #1: [Nombre del reto]
**Enunciado del docente:**
"[Copia aquí el enunciado exacto que te dio el docente]"

**Pasos que realicé:**
1. 
2. 
3. 

**Código modificado:**
```javascript
// Pega aquí el fragmento de código que modificaste
```
**Resultado:** 
**Captura de pantalla:** [Inserta imagen]
**¿Qué aprendí?:** 

---

## 7. CONCLUSIONES
*[Escribe aquí tu conclusión personal de al menos 1 párrafo sobre lo aprendido en el taller de persistencia, Node.js y MySQL]*
