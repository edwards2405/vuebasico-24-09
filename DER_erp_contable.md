# Diagrama Entidad-Relación (DER) - ERP Contable

Puedes usar este código Mermaid para visualizar el diagrama. También puedes renderizarlo usando cualquier visor de Markdown que soporte Mermaid, o herramientas online como draw.io / Mermaid Live Editor.

```mermaid
erDiagram
    contactos {
        INT id PK "AUTO_INCREMENT"
        VARCHAR(100) nombre "NOT NULL"
        VARCHAR(13) rfc "UNIQUE, NOT NULL"
        ENUM tipo "('Cliente','Proveedor') NOT NULL"
        VARCHAR(100) email
        VARCHAR(20) telefono
        TIMESTAMP fecha_creacion "DEFAULT CURRENT_TIMESTAMP"
    }
    
    movimientos {
        INT id PK "AUTO_INCREMENT"
        VARCHAR(200) concepto "NOT NULL"
        ENUM tipo "('Ingreso','Egreso') NOT NULL"
        DECIMAL(10_2) monto "NOT NULL, CHECK (monto > 0)"
        DATE fecha "NOT NULL"
        INT contacto_id FK "ON DELETE SET NULL"
        TIMESTAMP fecha_creacion "DEFAULT CURRENT_TIMESTAMP"
    }

    contactos ||--o{ movimientos : "tiene"
```

> **Nota para la entrega:** Asegúrate de capturar este diagrama como imagen (`DER_erp_contable.png`) para agregarlo a tu PDF final.
