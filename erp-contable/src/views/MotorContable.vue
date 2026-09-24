<template>
  <v-container>
    <h1 class="mb-4">Motor Contable</h1>
    
    <!-- Sección de KPIs (Propiedades Computadas) -->
    <v-row class="mb-6">
      <v-col cols="12" md="4">
        <v-card color="success" class="text-white">
          <v-card-title>Ingresos</v-card-title>
          <v-card-text class="text-h4">${{ totalIngresos.toFixed(2) }}</v-card-text>
        </v-card>
      </v-col>
      <v-col cols="12" md="4">
        <v-card color="error" class="text-white">
          <v-card-title>Egresos</v-card-title>
          <v-card-text class="text-h4">${{ totalEgresos.toFixed(2) }}</v-card-text>
        </v-card>
      </v-col>
      <v-col cols="12" md="4">
        <v-card :color="saldo >= 0 ? 'primary' : 'warning'" class="text-white">
          <v-card-title>Saldo Total</v-card-title>
          <v-card-text class="text-h4">${{ saldo.toFixed(2) }}</v-card-text>
        </v-card>
      </v-col>
    </v-row>

    <!-- Error Alert -->
    <v-alert v-if="error" type="error" class="mb-4" closable @click:close="error = null">
      {{ error }}
    </v-alert>

    <v-row>
      <!-- Formulario para agregar movimiento -->
      <v-col cols="12" md="4">
        <v-card>
          <v-card-title>Nuevo Movimiento</v-card-title>
          <v-card-text>
            <v-form @submit.prevent="guardarMovimiento">
              <v-text-field
                v-model="nuevoMovimiento.concepto"
                label="Concepto"
                required
              ></v-text-field>
              
              <v-select
                v-model="nuevoMovimiento.tipo"
                :items="['Ingreso', 'Egreso']"
                label="Tipo"
                required
              ></v-select>
              
              <v-text-field
                v-model.number="nuevoMovimiento.monto"
                label="Monto"
                type="number"
                min="0.01"
                step="0.01"
                required
              ></v-text-field>
              
              <v-btn
                type="submit"
                color="primary"
                block
                :loading="cargando"
              >
                Guardar
              </v-btn>
            </v-form>
          </v-card-text>
        </v-card>
      </v-col>

      <!-- Tabla de Movimientos -->
      <v-col cols="12" md="8">
        <v-card>
          <v-card-title>Historial de Movimientos</v-card-title>
          
          <v-progress-circular
            v-if="cargando"
            indeterminate
            color="primary"
            class="ma-4"
          ></v-progress-circular>
          
          <v-table v-else>
            <thead>
              <tr>
                <th class="text-left">ID</th>
                <th class="text-left">Concepto</th>
                <th class="text-left">Tipo</th>
                <th class="text-right">Monto</th>
              </tr>
            </thead>
            <tbody>
              <tr v-if="movimientos.length === 0">
                <td colspan="4" class="text-center text-grey">No hay movimientos registrados.</td>
              </tr>
              <tr
                v-for="mov in movimientos"
                :key="mov.id || mov._id"
              >
                <td>{{ mov.id || mov._id }}</td>
                <td>{{ mov.concepto }}</td>
                <td>
                  <v-chip
                    :color="mov.tipo === 'Ingreso' ? 'success' : 'error'"
                    size="small"
                  >
                    {{ mov.tipo }}
                  </v-chip>
                </td>
                <td class="text-right">${{ Number(mov.monto).toFixed(2) }}</td>
              </tr>
            </tbody>
          </v-table>
        </v-card>
      </v-col>
    </v-row>
  </v-container>
</template>

<script setup>
import { ref, onMounted, computed } from 'vue';
import { movimientoService } from '@/services/erpApi';

// Variables Reactivas
const movimientos = ref([]);
const cargando = ref(false);
const error = ref(null);

const nuevoMovimiento = ref({
  concepto: '',
  tipo: 'Ingreso',
  monto: ''
});

// Cargar movimientos al inicio
async function cargarMovimientos() {
  cargando.value = true;
  error.value = null;

  try {
    const respuesta = await movimientoService.getAll();
    // Ajuste: asumo que data es un array o viene en data.datos
    movimientos.value = respuesta.data.datos || respuesta.data || [];
  } catch (err) {
    if (err.response) {
      error.value = err.response.data?.mensaje || 'Error al cargar los datos del servidor.';
    } else if (err.request) {
      error.value = 'El servidor no responde. Verifica que esté encendido.';
    } else {
      error.value = 'Error inesperado en la aplicación.';
    }
  } finally {
    cargando.value = false;
  }
}

// Guardar nuevo movimiento
async function guardarMovimiento() {
  if (!nuevoMovimiento.value.concepto || !nuevoMovimiento.value.monto) {
    error.value = 'Completa todos los campos.';
    return;
  }

  cargando.value = true;
  error.value = null;
  try {
    const payload = {
      ...nuevoMovimiento.value,
      monto: Number(nuevoMovimiento.value.monto)
    };
    
    const respuesta = await movimientoService.create(payload);
    const movCreado = respuesta.data.datos || respuesta.data;
    
    // Actualización reactiva
    movimientos.value.push(movCreado); 
    
    // Limpiar formulario
    nuevoMovimiento.value = { concepto: '', tipo: 'Ingreso', monto: '' }; 
  } catch (err) {
    if (err.response) {
      error.value = err.response.data?.mensaje || 'Error al guardar el movimiento.';
    } else {
      error.value = 'Error de conexión. Asegúrate que el servidor esté encendido.';
    }
  } finally {
    cargando.value = false;
  }
}

// Propiedades Computadas
const totalIngresos = computed(() => {
  if (!movimientos.value || movimientos.value.length === 0) return 0;
  return movimientos.value
    .filter(m => m.tipo === 'Ingreso')
    .reduce((sum, m) => sum + Number(m.monto), 0);
});

const totalEgresos = computed(() => {
  if (!movimientos.value || movimientos.value.length === 0) return 0;
  return movimientos.value
    .filter(m => m.tipo === 'Egreso')
    .reduce((sum, m) => sum + Number(m.monto), 0);
});

const saldo = computed(() => {
  return totalIngresos.value - totalEgresos.value;
});

// Hook de ciclo de vida
onMounted(() => {
  cargarMovimientos();
});
</script>
