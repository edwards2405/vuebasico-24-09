# Investigación - Programación Asíncrona (Semana 8)

## 1. Simular un servidor caído
**Pregunta:** Detén el servidor Express (`Ctrl + C`). Intenta cargar los movimientos en Vue. ¿Qué tipo de error se genera en la consola? ¿Cómo lo muestra tu UI?

**Respuesta:**
Cuando el servidor está apagado, la petición asíncrona no encuentra respuesta.
- **En la consola:** Aparece un error del tipo `ERR_CONNECTION_REFUSED`, indicando que Axios no pudo establecer comunicación con `localhost:3000`.
- **En la UI:** Gracias al bloque `try/catch` y la estructuración del error en Axios (`err.request`), la variable reactiva `error` captura este estado y nuestra interfaz muestra una alerta roja amigable que dice: *"El servidor no responde. Verifica que esté encendido."* Esto evita que la página se quede congelada, ya que el bloque `finally` oculta el spinner de carga.

## 2. Manejo de Errores HTTP 400
**Pregunta:** Intenta crear un movimiento con monto negativo. Atrapa el error en el `catch` y asegúrate de que tu UI muestre el mensaje exacto que envía el backend.

**Respuesta:**
Si enviamos un monto negativo y el backend lo valida, responderá con un código de estado `HTTP 400 Bad Request` y un JSON.
- **En la consola:** Aparecerá un error `AxiosError: Request failed with status code 400`.
- **En la UI:** Al atrapar el error, el bloque de código accede a `err.response.data.mensaje` y lo asigna a nuestra variable `error`. La interfaz muestra exactamente el mensaje enviado por el servidor: *"El monto debe ser un número positivo"*.

## 3. Investigación `Promise.all`
**Pregunta:** Modifica tu código temporalmente para cargar `contactos` y `movimientos` simultáneamente en una sola función, esperando a que ambas terminen antes de ocultar el spinner de carga.

**Respuesta:**
Probé a cargar contactos y movimientos al mismo tiempo, en una sola función, en lugar de esperar una petición y después la otra. Con Promise.all las dos salen juntas. El spinner sigue visible hasta que las dos terminan, porque cargando vuelve a false en el finally, y ese bloque corre cuando el conjunto ya acabó. Si una de las dos falla, por ejemplo con el servidor apagado, no se queda a medias: cae al catch y el finally igual oculta el spinner. Tarda menos que encadenar dos await, porque el tiempo total es el de la petición más lenta y no la suma de las dos. Después dejé MotorContable como estaba, cargando solo los movimientos.
