# Guía paso a paso: APIs REST con Node, Express y Vue 3

## Proyecto de referencia: ERP Contable

**Tecnologías:** Vue 3, Vite, Vuetify, Vue Router, Node.js, Express, Fetch/Axios y Postman o Insomnia.

**Resultado esperado:** el frontend Vue consulta un backend Express mediante APIs RESTful para trabajar con contactos y movimientos contables simulados.

> Esta guía describe la transformación y los archivos que debes crear o modificar. Haz una copia de seguridad antes de aplicar los cambios. La guía no modifica automáticamente tu proyecto.

---

## 1. Entender la arquitectura

El proyecto tendrá dos aplicaciones independientes:

```text
VUEBASICO/
├── erp-contable/       # Frontend Vue + Vite
└── erp-api/            # Backend Node + Express
```

El flujo será:

```text
Componente Vue
    |
    | fetch o Axios + HTTP
    v
API REST de Express
    |
    v
Datos simulados en memoria
```

Vue se encarga de la interfaz, los componentes y la reactividad. Express se encarga de recibir solicitudes, validar datos y responder JSON.

---

## 2. Requisitos previos

Abre CMD y verifica Node y npm:

```cmd
node --version
npm --version
```

Se recomienda Node.js 18 o superior. En este proyecto ya existe el frontend en:

```text
C:\Users\jdcad\Materias\Talleres\interfaces web 2026-2\PROYECTO\VUEBASICO\erp-contable
```

No ejecutes `npm run dev` desde `VUEBASICO`, porque allí no existe `package.json`. Debes entrar en `erp-contable`.

---

## 3. Crear el backend Express

Desde CMD:

```cmd
cd /d "C:\Users\jdcad\Materias\Talleres\interfaces web 2026-2\PROYECTO\VUEBASICO"
mkdir erp-api
cd erp-api
npm init -y
npm install express cors
npm install --save-dev nodemon
```

En el `package.json` del backend agrega estos scripts:

```json
"scripts": {
  "start": "node server.js",
  "dev": "nodemon server.js"
}
```

Crea `server.js` con esta base:

```js
import express from 'express'
import cors from 'cors'

const app = express()
const PORT = 3000

app.use(cors())
app.use(express.json())

let contactos = [
  { id: 1, nombre: 'Ana Torres', correo: 'ana@erp.test', tipo: 'Cliente' },
  { id: 2, nombre: 'Luis Perez', correo: 'luis@erp.test', tipo: 'Proveedor' }
]

let movimientos = [
  { id: 1, concepto: 'Venta de servicios', tipo: 'Ingreso', monto: 1500 },
  { id: 2, concepto: 'Compra de insumos', tipo: 'Egreso', monto: 450 }
]

app.get('/api/contactos', (req, res) => {
  res.status(200).json(contactos)
})

app.get('/api/contactos/:id', (req, res) => {
  const contacto = contactos.find(item => item.id === Number(req.params.id))

  if (!contacto) {
    return res.status(404).json({ mensaje: 'Contacto no encontrado' })
  }

  res.status(200).json(contacto)
})

app.post('/api/contactos', (req, res) => {
  const { nombre, correo, tipo } = req.body

  if (!nombre || !correo || !tipo) {
    return res.status(400).json({ mensaje: 'nombre, correo y tipo son obligatorios' })
  }

  const nuevoContacto = {
    id: Date.now(),
    nombre,
    correo,
    tipo
  }

  contactos.push(nuevoContacto)
  res.status(201).json(nuevoContacto)
})

app.put('/api/contactos/:id', (req, res) => {
  const indice = contactos.findIndex(item => item.id === Number(req.params.id))

  if (indice === -1) {
    return res.status(404).json({ mensaje: 'Contacto no encontrado' })
  }

  contactos[indice] = {
    id: contactos[indice].id,
    nombre: req.body.nombre,
    correo: req.body.correo,
    tipo: req.body.tipo
  }

  res.status(200).json(contactos[indice])
})

app.delete('/api/contactos/:id', (req, res) => {
  const indice = contactos.findIndex(item => item.id === Number(req.params.id))

  if (indice === -1) {
    return res.status(404).json({ mensaje: 'Contacto no encontrado' })
  }

  contactos.splice(indice, 1)
  res.status(204).send()
})

app.get('/api/movimientos', (req, res) => {
  res.status(200).json(movimientos)
})

app.post('/api/movimientos', (req, res) => {
  const { concepto, tipo, monto } = req.body
  const montoNumerico = Number(monto)

  if (!concepto || !['Ingreso', 'Egreso'].includes(tipo) || montoNumerico <= 0) {
    return res.status(400).json({ mensaje: 'Datos de movimiento inválidos' })
  }

  const nuevoMovimiento = {
    id: Date.now(),
    concepto,
    tipo,
    monto: montoNumerico
  }

  movimientos.push(nuevoMovimiento)
  res.status(201).json(nuevoMovimiento)
})

app.listen(PORT, () => {
  console.log(`API disponible en http://localhost:${PORT}`)
})
```

### Conceptos importantes del servidor

- `express()` crea la aplicación.
- `cors()` permite que Vue consulte el backend desde otro puerto.
- `express.json()` interpreta cuerpos JSON.
- `app.get`, `app.post`, `app.put` y `app.delete` definen endpoints.
- `req.params` obtiene valores de la URL.
- `req.body` obtiene datos enviados en JSON.
- `res.status(...).json(...)` responde con código HTTP y JSON.

Los datos están en memoria. Al reiniciar el servidor se pierden. Esto es adecuado para practicar endpoints simulados; una base de datos se incorporaría después.

---

## 4. Ejecutar el backend

En una terminal CMD:

```cmd
cd /d "C:\Users\jdcad\Materias\Talleres\interfaces web 2026-2\PROYECTO\VUEBASICO\erp-api"
npm run dev
```

La API debe mostrar:

```text
API disponible en http://localhost:3000
```

> Mantén esta terminal abierta.

---

## 5. Probar endpoints con Postman o Insomnia

### Listar contactos

- Método: `GET`
- URL: `http://localhost:3000/api/contactos`
- Resultado esperado: `200 OK` y un arreglo JSON.

### Consultar un contacto

- Método: `GET`
- URL: `http://localhost:3000/api/contactos/1`
- Resultado esperado: `200 OK` y un objeto JSON.

### Crear un contacto

- Método: `POST`
- URL: `http://localhost:3000/api/contactos`
- Header: `Content-Type: application/json`
- Body JSON:

```json
{
  "nombre": "Maria Lopez",
  "correo": "maria@erp.test",
  "tipo": "Cliente"
}
```

Resultado esperado: `201 Created`.

### Actualizar un contacto

- Método: `PUT`
- URL: `http://localhost:3000/api/contactos/1`
- Body JSON:

```json
{
  "nombre": "Ana Torres Actualizada",
  "correo": "ana.nueva@erp.test",
  "tipo": "Cliente"
}
```

Resultado esperado: `200 OK`.

### Eliminar un contacto

- Método: `DELETE`
- URL: `http://localhost:3000/api/contactos/1`
- Resultado esperado: `204 No Content`.

### Listar movimientos

- Método: `GET`
- URL: `http://localhost:3000/api/movimientos`

### Crear un movimiento

- Método: `POST`
- URL: `http://localhost:3000/api/movimientos`
- Body JSON:

```json
{
  "concepto": "Pago de renta",
  "tipo": "Egreso",
  "monto": 800
}
```

Resultado esperado: `201 Created`.

### Códigos que debes reconocer

| Código | Significado | Uso en el ERP |
|---|---|---|
| 200 | OK | Consulta o actualización correcta |
| 201 | Created | Registro creado |
| 204 | No Content | Eliminación correcta sin contenido |
| 400 | Bad Request | Faltan datos o son inválidos |
| 404 | Not Found | El ID no existe |
| 500 | Server Error | Error no controlado del servidor |

---

## 6. Programación asincrónica en ES6+

Una solicitud HTTP tarda un tiempo impredecible. JavaScript no debe bloquear toda la interfaz mientras espera la respuesta. Por eso se utiliza programación asincrónica.

### Promesas

Una promesa representa un resultado que estará disponible después:

```js
fetch('http://localhost:3000/api/contactos')
  .then(respuesta => respuesta.json())
  .then(datos => console.log(datos))
  .catch(error => console.error(error))
```

Estados de una promesa:

- `pending`: todavía está esperando.
- `fulfilled`: terminó correctamente.
- `rejected`: terminó con error.

### `async` y `await`

`async` permite que una función trabaje con promesas. `await` espera el resultado dentro de esa función sin bloquear el navegador:

```js
async function cargarContactos() {
  const respuesta = await fetch('http://localhost:3000/api/contactos')
  const datos = await respuesta.json()
  return datos
}
```

### `try/catch/finally`

Toda llamada real debe considerar carga y error:

```js
async function cargarContactos() {
  cargando.value = true
  error.value = ''

  try {
    const respuesta = await fetch('http://localhost:3000/api/contactos')

    if (!respuesta.ok) {
      throw new Error(`Error HTTP: ${respuesta.status}`)
    }

    contactos.value = await respuesta.json()
  } catch (problema) {
    error.value = problema.message
  } finally {
    cargando.value = false
  }
}
```

`fetch` no rechaza automáticamente la promesa ante un `404` o `500`; por eso debes comprobar `respuesta.ok`.

### `Promise.all`

Cuando dos consultas son independientes, pueden ejecutarse juntas:

```js
const [contactosRespuesta, movimientosRespuesta] = await Promise.all([
  fetch('http://localhost:3000/api/contactos'),
  fetch('http://localhost:3000/api/movimientos')
])

const [contactosDatos, movimientosDatos] = await Promise.all([
  contactosRespuesta.json(),
  movimientosRespuesta.json()
])
```

---

## 7. Consumir la API desde un componente Vue

En `src/views/Clientes.vue`, el patrón recomendado con Composition API es:

```vue
<script setup>
import { onMounted, ref } from 'vue'

const contactos = ref([])
const cargando = ref(false)
const error = ref('')

async function cargarContactos() {
  cargando.value = true
  error.value = ''

  try {
    const respuesta = await fetch('http://localhost:3000/api/contactos')

    if (!respuesta.ok) {
      throw new Error(`No se pudieron cargar los contactos (${respuesta.status})`)
    }

    contactos.value = await respuesta.json()
  } catch (problema) {
    error.value = problema.message
  } finally {
    cargando.value = false
  }
}

onMounted(cargarContactos)
</script>

<template>
  <section>
    <h1>Contactos</h1>
    <p v-if="cargando">Cargando contactos...</p>
    <p v-else-if="error">{{ error }}</p>

    <ul v-else>
      <li v-for="contacto in contactos" :key="contacto.id">
        {{ contacto.nombre }} - {{ contacto.correo }}
      </li>
    </ul>
  </section>
</template>
```

### Qué ocurre aquí

1. `ref([])` crea una lista reactiva.
2. `onMounted` ejecuta la carga al entrar en la vista.
3. `await fetch` solicita datos al backend.
4. `contactos.value = ...` cambia el estado reactivo.
5. Vue detecta el cambio y actualiza el `v-for`.
6. `cargando` y `error` permiten mostrar estados claros al usuario.

---

## 8. Crear un contacto desde Vue

La función para enviar datos debe usar `POST`:

```js
const nuevoContacto = ref({
  nombre: '',
  correo: '',
  tipo: 'Cliente'
})

async function crearContacto() {
  const respuesta = await fetch('http://localhost:3000/api/contactos', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json'
    },
    body: JSON.stringify(nuevoContacto.value)
  })

  if (!respuesta.ok) {
    throw new Error('No se pudo crear el contacto')
  }

  const contactoCreado = await respuesta.json()
  contactos.value.push(contactoCreado)
  nuevoContacto.value = { nombre: '', correo: '', tipo: 'Cliente' }
}
```

La vista puede vincular los campos con `v-model`:

```vue
<v-text-field v-model="nuevoContacto.nombre" label="Nombre" />
<v-text-field v-model="nuevoContacto.correo" label="Correo" />
<v-select
  v-model="nuevoContacto.tipo"
  :items="['Cliente', 'Proveedor']"
  label="Tipo"
/>
<v-btn @click="crearContacto">Guardar</v-btn>
```

---

## 9. Fetch frente a Axios

### Fetch

- Viene incluido en el navegador.
- No requiere instalar otra dependencia.
- Es suficiente para este laboratorio.
- Requiere comprobar manualmente `respuesta.ok`.

```js
const respuesta = await fetch(url)
if (!respuesta.ok) throw new Error('Error HTTP')
const datos = await respuesta.json()
```

### Axios

Para instalarlo en el frontend:

```cmd
cd /d "C:\Users\jdcad\Materias\Talleres\interfaces web 2026-2\PROYECTO\VUEBASICO\erp-contable"
npm install axios
```

Ejemplo:

```js
import axios from 'axios'

const api = axios.create({
  baseURL: 'http://localhost:3000/api'
})

const respuesta = await api.get('/contactos')
contactos.value = respuesta.data
```

Axios interpreta JSON automáticamente y considera como error las respuestas HTTP no exitosas. En proyectos pequeños puedes comenzar con Fetch; en proyectos con muchas rutas, interceptores y configuración común, Axios puede resultar más cómodo.

---

## 10. Componentes y reactividad

Conviene dividir la interfaz en componentes con una responsabilidad clara:

```text
src/components/
├── TarjetaKPI.vue
├── ContactoForm.vue
├── ContactosTabla.vue
└── MovimientoForm.vue
```

La vista `Clientes.vue` puede coordinar los componentes y conservar el estado de los contactos. Las `props` envían datos del padre al hijo y los eventos permiten que el hijo comunique acciones al padre.

```vue
<!-- Padre -->
<ContactoForm @creado="agregarContacto" />
<ContactosTabla :contactos="contactos" @eliminar="eliminarContacto" />
```

La reactividad se observa en estos elementos:

- `ref`: guarda valores reactivos como listas, textos y booleanos.
- `reactive`: guarda objetos reactivos.
- `computed`: calcula valores derivados, como total de ingresos.
- `watch`: reacciona a cambios específicos.
- `onMounted`: ejecuta la carga inicial.

Ejemplo para el total de movimientos:

```js
import { computed, ref } from 'vue'

const movimientos = ref([])

const totalIngresos = computed(() => {
  return movimientos.value
    .filter(movimiento => movimiento.tipo === 'Ingreso')
    .reduce((total, movimiento) => total + movimiento.monto, 0)
})
```

Cuando cambia `movimientos.value`, Vue recalcula `totalIngresos` y actualiza las tarjetas KPI que lo utilizan.

---

## 11. Qué modificar en el proyecto principal

La transformación recomendada es gradual:

### Fase A: agregar el backend

1. Crear `erp-api` al mismo nivel que `erp-contable`.
2. Inicializar npm.
3. Instalar Express, CORS y Nodemon.
4. Crear endpoints simulados.
5. Probarlos con Postman o Insomnia.

### Fase B: conectar una vista

1. Comenzar por `Clientes.vue`.
2. Reemplazar el arreglo local por un `ref([])` cargado desde Express.
3. Agregar estados `cargando` y `error`.
4. Conectar el formulario con `POST`.
5. Actualizar la tabla después de crear o eliminar.

### Fase C: conectar contabilidad

1. Consultar `GET /api/movimientos` desde `Contabilidad.vue`.
2. Crear movimientos con `POST`.
3. Usar `computed` para ingresos, egresos y saldo.
4. Mostrar resultados en `Dashboard.vue`.

### Fase D: centralizar llamadas

Cuando haya varias vistas, crear `src/services/api.js`:

```js
import axios from 'axios'

export const api = axios.create({
  baseURL: 'http://localhost:3000/api'
})

export const obtenerContactos = () => api.get('/contactos')
export const crearContacto = datos => api.post('/contactos', datos)
export const obtenerMovimientos = () => api.get('/movimientos')
export const crearMovimiento = datos => api.post('/movimientos', datos)
```

Así los componentes se enfocan en la interfaz y no repiten URLs.

---

## 12. Ejecutar las dos aplicaciones

Abre dos terminales.

### Terminal 1: API Express

```cmd
cd /d "C:\Users\jdcad\Materias\Talleres\interfaces web 2026-2\PROYECTO\VUEBASICO\erp-api"
npm run dev
```

### Terminal 2: frontend Vue

```cmd
cd /d "C:\Users\jdcad\Materias\Talleres\interfaces web 2026-2\PROYECTO\VUEBASICO\erp-contable"
npm run dev
```

Abre:

```text
http://localhost:5173
```

El backend estará en:

```text
http://localhost:3000
```

---

## 13. Lista de comprobación

- [ ] `node --version` y `npm --version` funcionan.
- [ ] Express inicia en el puerto 3000.
- [ ] `GET /api/contactos` devuelve JSON.
- [ ] `POST /api/contactos` devuelve `201`.
- [ ] Un ID inexistente devuelve `404`.
- [ ] Un cuerpo incompleto devuelve `400`.
- [ ] Vue inicia en el puerto 5173.
- [ ] La vista muestra un estado de carga.
- [ ] La vista muestra un mensaje si falla la API.
- [ ] Crear un contacto actualiza la interfaz reactivamente.
- [ ] Los movimientos alimentan los totales del dashboard.
- [ ] Las llamadas están separadas de la presentación cuando el proyecto crece.

---

## 14. Errores frecuentes

### `npm ERR! enoent package.json`

Estás en la carpeta equivocada. Usa `cd` para entrar en `erp-api` o `erp-contable`.

### Error de CORS

Confirma que el backend usa `app.use(cors())` y que está ejecutándose.

### `fetch failed` o `Failed to fetch`

Revisa el puerto, la URL y que Express siga abierto.

### La respuesta llega, pero Vue no cambia

Comprueba que estés asignando al `.value` de un `ref`, por ejemplo `contactos.value = datos`.

### La solicitud devuelve 404

Compara el método y la URL exactos con la ruta definida en Express.

### Los datos desaparecen al reiniciar

Es normal: están en memoria. Para conservarlos debes usar una base de datos o un archivo persistente.

---

## 15. Actividad de aprendizaje

1. Crea dos contactos desde Postman.
2. Cárgalos en `Clientes.vue`.
3. Agrega un formulario con validación.
4. Crea un movimiento de ingreso y uno de egreso.
5. Calcula el saldo con `computed`.
6. Simula un error apagando Express y muestra un mensaje en Vue.
7. Explica por qué `await` no congela la interfaz del navegador.
8. Compara la misma consulta usando Fetch y Axios.
