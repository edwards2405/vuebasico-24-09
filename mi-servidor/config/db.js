// ============================================
// CONFIGURACIÓN DE CONEXIÓN A MySQL
// ============================================
// Este archivo centraliza la conexión a la base de datos
// para que todos los endpoints puedan reutilizarla.

// Importamos el paquete mysql2 (ya instalado con npm install mysql2)
const mysql = require('mysql2');

// Creamos un "pool" de conexiones.
// Un pool mantiene varias conexiones abiertas y las reutiliza,
// lo cual es más eficiente que abrir y cerrar una conexión en cada petición.
const pool = mysql.createPool({
  host: 'localhost',      // Servidor donde está MySQL (local en este caso)
  user: 'erp_user',       // Usuario creado en el Paso 1.4
  password: 'erp2026',    // Contraseña del usuario
  database: 'erp_contable_ep', // ⚠️ REEMPLAZA con el nombre de TU base de datos
  waitForConnections: true, // Si no hay conexiones libres, espera en cola
  connectionLimit: 10,      // Máximo de conexiones simultáneas
  queueLimit: 0             // Sin límite de peticiones en cola
});

// Exportamos el pool como "promesas" para poder usar async/await
// en los endpoints en lugar de callbacks.
module.exports = pool.promise();
