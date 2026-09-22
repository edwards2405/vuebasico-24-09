# 🧠 Cuestionario de Reflexión Post-Laboratorio
**Instrucciones para el estudiante:** *Con el laboratorio ya funcionando en tu pantalla, responde brevemente a las siguientes preguntas. No necesitas escribir código, solo explicar con tus propias palabras lo que acabas de construir.*

### 🔄 1. Reactividad (El corazón de Vue)
*   En tu vista de **Clientes**, tienes una lista (`ref`) y un saldo neto total (`computed`). 
    *   **Pregunta:** Si agregas un nuevo cliente con saldo $500, el total en la tarjeta KPI cambia **automáticamente** sin que tú hayas escrito una línea para actualizarlo. ¿Cómo sabe Vue que debe recalcular ese total? Explica la diferencia entre usar `ref` y usar una variable normal de JavaScript (como `let total = 0`).
*   En la vista de **Facturación**, usaste `computed` para el subtotal y el IVA. 
    *   **Pregunta:** ¿Por qué es mejor usar `computed` aquí en lugar de crear una función normal (ej. `function calcularTotal() {}`) que se llame cada vez que el usuario cambia algo? (Pista: Piensa en la eficiencia y en el caché de Vue).

### 🧩 2. Componentes Modulares y Props (Comunicación Padre -> Hijo)
*   Usaste el componente `TarjetaKPI` en el Dashboard y en Clientes.
    *   **Pregunta:** Imagina que eres el componente `TarjetaKPI`. No sabes qué título ni qué número mostrar. ¿Cómo hace la vista de "Clientes" (el Padre) para decirle al componente (el Hijo) "Oye, muéstrame el título 'Proveedores' y el valor 5"? Explica el concepto de **Props** usando esta analogía.
    *   **Pregunta:** ¿Qué habría pasado si en lugar de crear `TarjetaKPI` hubieras copiado y pegado el código HTML de la tarjeta 4 veces en el Dashboard? Menciona una ventaja de haberlo hecho como componente modular.

### 🎰 3. Slots (El contenido inyectado)
*   En la tabla de clientes (`v-data-table`), usaste un `<template v-slot:item.tipo>` para mostrar una etiqueta de color (`v-chip`) en lugar de texto plano.
    *   **Pregunta:** Si las **Props** son datos que el Padre le *envía* al Hijo, ¿qué es un **Slot**? Explica con tus palabras cómo el Slot permitió que la tabla (el Hijo) mostrara un diseño personalizado (el chip de color) que el Padre le envió.

### ✅ 4. Validaciones Visuales (Experiencia de Usuario)
*   En el formulario de "Nuevo Cliente", escribiste mal un RFC a propósito y el campo se puso rojo.
    *   **Pregunta:** ¿Cómo funciona la regla (`:rules`) que pusiste en el `v-text-field`? ¿Qué tiene que devolver exactamente esa función para que Vuetify sepa que el campo está "bien" (verde) y cuándo está "mal" (rojo)?

### 🗺️ 5. Enrutamiento Básico (Arquitectura SPA)
*   Cuando haces clic en "Contabilidad" en el menú lateral, la página **no** parpadea ni se recarga por completo.
    *   **Pregunta:** Explica el papel de `<router-view>` y de `vue-router` en este proceso. ¿Por qué se dice que esto es una "Single Page Application" (SPA)? ¿Qué pasa con la URL del navegador cuando navegas entre las 4 vistas?

### 🎨 6. Vuetify y Material Design
*   Usaste componentes como `v-app`, `v-card`, `v-btn` y `v-data-table`.
    *   **Pregunta:** ¿Qué ventaja tiene usar Vuetify en lugar de escribir todo el CSS desde cero? Menciona al menos un beneficio relacionado con el diseño responsivo (adaptarse a celulares) o la accesibilidad visual.

---

