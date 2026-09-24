# Code Review - Semana 8

## Revisor: Jaiker Figueredo | Revisado: Edwards Pérez

### Aspectos Positivos
1. Excelente uso de `try/catch/finally` para asegurar que el spinner de carga siempre se oculte, incluso cuando falla la conexión con el servidor.
2. La reactividad con `computed` en el cálculo del saldo y los totales de ingresos y egresos está muy bien estructurada, manejando adecuadamente el estado vacío del array para evitar `NaN`.

### Sugerencias de Mejora
1. Sería interesante encapsular la alerta de error en un componente reutilizable si la aplicación sigue creciendo.
2. Añadir un poco de validación adicional en el frontend antes de enviar la petición (por ejemplo, validar que el monto sea siempre mayor a 0) para evitar llamadas innecesarias al backend.

### Preguntas Técnicas
1. He notado que usaste `ref()` en lugar de `reactive()` para el objeto `nuevoMovimiento`. ¿Hubo alguna razón específica por la cual preferiste esta aproximación en lugar de agrupar todo el estado en un solo objeto reactivo?

### Validación de Funcionalidades
- [x] Carga de movimientos funciona
- [x] Creación de movimientos funciona
- [x] Manejo de errores es adecuado (prueba con servidor apagado)
- [x] KPIs (saldo) se actualizan correctamente
- [x] El código usa async/await y try/catch/finally
