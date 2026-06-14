# 04 — Construir el data warehouse de Northwind

Vas a construir un **data warehouse** sobre Northwind: una base optimizada para queries analíticas, no transaccionales. Implementarás el patrón **estrella (star schema)** clásico de Kimball — el estándar de la industria para BI desde los 90s y aún el modelo dominante.

## Prerequisitos

- ✅ `northwind_oltp` cargado y verificado.
- ✅ Schema `northwind_dwh` creado.

---

## Paso 1 — Ubicar el script `01_northwind_dwh_ddl.sql` dentro de `scripts/`

---

## Paso 2 — Crear el DDL del star (script 01)

En DBeaver, en una pestaña SQL Editor de la conexión `aurora-mod4`:

1. **File → Open File** → selecciona `01_northwind_dwh_ddl.sql`.
2. Lee los comentarios al inicio del archivo (te explican qué crea y por qué).
3. Ejecuta todo el script con **Alt+X**.

El script crea **6 tablas vacías** dentro del schema `northwind_dwh` — solo la estructura, todavía sin datos:

- `dim_customer`
- `dim_product`
- `dim_employee`
- `dim_shipper`
- `dim_date`
- `fact_sales`

Las poblamos en los pasos siguientes.

### Verificar (en [`01_northwind_dwh_ddl.sql`](../scripts/01_northwind_dwh_ddl.sql))

```sql
SELECT table_name FROM information_schema.tables
WHERE table_schema = 'northwind_dwh'
ORDER BY table_name;
-- Esperado: 6 filas (dim_customer, dim_date, dim_employee, dim_product, dim_shipper, fact_sales)
```
