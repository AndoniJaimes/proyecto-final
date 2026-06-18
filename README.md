# Proyecto Final — Análisis de Ventas y Estrategia de Descuentos en Northwind

## Planteamiento del problema

La dirección de Northwind está evaluando la posibilidad de lanzar una campaña comercial similar al *Buen Fin*, caracterizada por descuentos masivos en productos clave. Antes de implementar esta estrategia, los directores desean analizar si la reducción de márgenes mediante descuentos podría ser compensada por un incremento significativo en el volumen de ventas, o si por el contrario afectaría negativamente las ganancias netas de la empresa.

Este proyecto busca responder a esa inquietud mediante un análisis detallado de las ventas históricas de Northwind, utilizando un modelo dimensional en estrella y técnicas de SQL avanzado.

---

## Pregunta analítica principal

**¿Conviene aplicar descuentos masivos para incrementar el volumen de ventas, al grado de que el aumento en cantidad vendida compense la reducción en margen, o es preferible mantener precios estables para proteger la rentabilidad?**

---

## Subpreguntas específicas

1. **Producto con mayor volumen por región**  
   - ¿Cuál es el producto que registra más ventas en cada sección geográfica (país o región)?  
   - Justificación: identificar los productos más demandados y su distribución territorial.

2. **Producto con mayor margen y ventas representativas**  
   - ¿Cuál es el producto con mayor margen unitario, cómo se comportan sus ventas y qué porcentaje de las ganancias totales representa, siempre que su volumen de ventas sea comparable al promedio general?  
   - Justificación: evaluar si los productos de alto margen también son relevantes en términos de participación de mercado.

3. **Producto con mayor volumen total**  
   - ¿Cuál es el producto con mayor volumen de ventas en general, qué margen tiene y qué porcentaje de las ganancias totales aporta a la empresa?  
   - Justificación: determinar si los productos más vendidos son también los más rentables o si requieren ajustes en precio.

4. **Relación volumen vs. margen**  
   - ¿Que genera más ganancias, el volumen o el margen?  
   - Justificación: responder si una campaña de descuentos masivos es factible y rentable impulsando el volumen de ventas, o si erosiona la utilidad neta.

---

## Justificación de negocio

El análisis permitirá a Northwind tomar decisiones estratégicas sobre:

- **Políticas de precios y descuentos**: definir si conviene aplicar promociones masivas o mantener márgenes estables.  
- **Selección de productos clave**: identificar qué productos deben impulsarse en campañas comerciales.  
- **Segmentación geográfica**: reconocer regiones donde los descuentos podrían tener mayor impacto.  
- **Optimización de rentabilidad**: equilibrar volumen y margen para maximizar las ganancias netas de la empresa.

---

## Dataset y contexto

El dataset utilizado en este proyecto es **Northwind**, una base de datos de ejemplo creada originalmente por Microsoft en los años 90 para enseñar conceptos de bases de datos relacionales y análisis de negocio. Northwind simula una empresa ficticia de importación y exportación de alimentos y productos, incluyendo clientes, pedidos, empleados, proveedores, productos y compañías de envío.

En este proyecto, el dataset se carga mediante el archivo `northwind.sql`, que contiene la definición de las tablas y los datos iniciales. Dicho archivo se ejecuta sobre un **cluster de Aurora PostgreSQL en AWS Academy**, lo que permite contar con una infraestructura en la nube para el Data Warehouse.

---

## Replicabilidad del proyecto

Para asegurar que cualquier persona pueda reproducir el proyecto, se incluye una carpeta llamada `setup/` dentro del repositorio. Esta carpeta contiene las instrucciones paso a paso para:

1. **Crear el cluster en AWS Aurora PostgreSQL.**  
2. **Conectarse al cluster mediante DBeaver.**  
3. **Cargar la base de datos Northwind** ejecutando el archivo `northwind.sql`.  
4. **Crear el Data Warehouse (modelo estrella)** mediante el script SQL correspondiente.  
5. **Rellenar las tablas del esquema dimensional** con datos provenientes de Northwind.  

Siguiendo estas instrucciones, cualquier usuario podrá replicar el entorno completo: desde la carga del dataset hasta la construcción del modelo dimensional, garantizando que el análisis sea reproducible y transparente.

> **Nota de crédito:** Las instrucciones de replicabilidad del proyecto, incluyendo la creación del cluster en AWS, la conexión mediante DBeaver y la carga del dataset, se basan en los aprendizajes del Diplomado *“Manejo de bases de datos SQL y NoSQL en un entorno de nube”* impartido por el IIMAS-UNAM. Para mayor información sobre el programa académico, consulta el siguiente enlace: [Diplomado IIMAS](https://www.iimas.unam.mx/educacioncontinua/diplomado/).

---

## Contexto de negocio

El dataset Northwind es ideal para este proyecto porque:  
- Representa un negocio realista con productos, clientes, empleados y envíos.  
- Incluye una dimensión temporal (fechas de pedido, requerido y envío) que permite análisis avanzados.  
- Es suficientemente completo para responder preguntas de negocio sobre **volumen vs. margen**, descuentos y rentabilidad.

---

## 🚀 Ejecución del ETL

### 1. Instalar dependencias
pip install pandas sqlalchemy psycopg2-binary

### 2. Configurar conexión
Edita el archivo etl_pipeline.py y asegúrate de actualizar tus credenciales:

HOST = "aurora-mod4.cluster-XXX.us-east-1.rds.amazonaws.com"
PORT = 5432
USER = "postgres"
PASSWORD = "TU_PASSWORD"
DATABASE = "northwind"

### 3. Ejecutar el ETL
python scripts/etl_pipeline.py \
    -- host aurora-mod4.cluster-XXX.us-east-1.rds.amazonaws.com \
    -- user postgres \
    -- password TU_PASSWORD \
    -- database northwind

### 4. Salida esperada
✅ Extracción completada  
✅ Transformación completada  
✅ Carga completada  
🔍 fact_sales=2155 | dim_customer=91 | dim_product=77 | ...  
🔍 Total ventas OLTP = 123456 | Total ventas DWH = 123456  

## :building_construction: Modelo dimensional

### Esquema estrella

```


                              ┌──────────────┐
                              │   dim_date   │
                              │──────────────│
                              │ date_key PK  │
                              │ full_date    │
                              │ year         │
                              │ quarter      │
                              │ month_number │
                              │ month_name   │
                              │ week_of_year │
                              │ day_of_month │
                              │ day_of_week# │
                              │ is_weekend   │
                              └─────▲──▲─────┘
                                    │  │
            order_date_key FK  ──────┘  └────── required_date_key FK
                                    │
                             shipped_date_key FK
                                    │

┌────────────────────────────────┐      ┌────────────────────────────────┐      ┌────────────────────────────┐ 
│          dim_customer          │◄─────│          fact_sales            │─────►│        dim_product         │
│────────────────────────────────│      │────────────────────────────────│      │────────────────────────────│
│ customer_key PK                │      │ sale_key PK                    │      │ product_key PK             │
│ customer_id CHAR(5) UNIQUE     │      │ order_id (degenerate dim)      │      │ product_id SMALLINT        │
│ company_name VARCHAR(40)       │      │ customer_key FK                │      │ product_name VARCHAR(40)   │
│ contact_name VARCHAR(30)       │      │ product_key FK                 │      │ category_id SMALLINT       │
│ contact_title VARCHAR(30)      │      │ employee_key FK                │      │ category_name VARCHAR(15)  │
│ city VARCHAR(15)               │      │ shipper_key FK                 │      │ category_desc TEXT         │
│ region VARCHAR(15)             │      │ order_date_key FK              │      │ supplier_id SMALLINT       │
│ postal_code VARCHAR(10)        │      │ required_date_key FK           │      │ supplier_name VARCHAR(40)  │
│ country VARCHAR(15)            │      │ shipped_date_key FK            │      │ supplier_country VARCHAR15 │
└────────────────────────────────┘      │ quantity SMALLINT              │      │ supplier_city VARCHAR(15)  │
                                        │ unit_price NUMERIC(10,2)       │      │ discontinued BOOLEAN       │
                                        │ discount NUMERIC(4,2) DEFAULT 0│      └────────────────────────────┘
                                        │ extended_price GENERATED       │
                                        │ line_total GENERATED           │
                                        └──────────────┬─────────────────┘
                                                       │
                                        ┌──────────────┴───────────────┐
                                        │                              │
                                        │                              │
                          ┌─────────────▼────────────┐     ┌───────────▼───────────┐
                          │       dim_employee       │     │       dim_shipper      │
                          │──────────────────────────│     │────────────────────────│
                          │ employee_key PK          │     │ shipper_key PK         │
                          │ employee_id SMALLINT     │     │ shipper_id SMALLINT    │
                          │ full_name VARCHAR(40)    │     │ company_name VARCHAR40 │
                          │ title VARCHAR(30)        │     │ phone VARCHAR(24)      │
                          │ city VARCHAR(15)         │     └────────────────────────┘
                          │ country VARCHAR(15)      │
                          │ region VARCHAR(15)       │
                          │ hire_date DATE           │
                          │ reports_to_name VARCHAR40│
                          └──────────────────────────┘
       
```
## 🧠 Uso avanzado de SQL

### Query 1: Producto con mayor volumen por región

```sql
WITH ventas_por_region AS (
    SELECT 
        c.country,
        p.product_name,
        SUM(f.quantity) AS total_volumen,
        RANK() OVER (
            PARTITION BY c.country 
            ORDER BY SUM(f.quantity) DESC
        ) AS ranking
    FROM northwind_dwh.fact_sales f
    JOIN northwind_dwh.dim_customer c 
        ON f.customer_key = c.customer_key
    JOIN northwind_dwh.dim_product p 
        ON f.product_key = p.product_key
    GROUP BY c.country, p.product_name
)
SELECT 
    country,
    product_name,
    total_volumen
FROM ventas_por_region
WHERE ranking = 1
ORDER BY total_volumen DESC;
```

| country | product_name        | total_volumen |
|---------|---------------------|---------------|
| Germany | Camembert Pierrot   | 405           |
| USA     | Gnocchi di nonna Alice | 386        |
| Austria | Guaraná Fantástica  | 283           |
| Brazil  | Camembert Pierrot   | 212           |
| UK      | Gorgonzola Telino   | 185           |
| France  | Tarte au sucre      | 174           |
| ...     | ...                 | ...           |

**Análisis:**  
El resultado muestra que Alemania es el país con mayor volumen en su producto líder, Camembert Pierrot, con 405 unidades, y que este mismo producto aparece en varias regiones como Brasil y Canadá, lo que lo posiciona como un producto de alcance global. También se observa que Gnocchi di nonna Alice y Guaraná Fantástica tienen presencia multinacional, mientras que otros productos como Tarte au sucre en Francia son más localizados. Esto sugiere que algunos productos deben ser gestionados con estrategias globales de inventario y promoción, mientras que otros requieren enfoques regionales específicos.

### Query 2: Producto con mayor margen unitario, comportamiento de ventas y participación en ganancias

```sql
WITH ventas_por_producto AS (
    SELECT 
        p.product_name,
        AVG(od.unit_price) AS margen_unitario_aprox,
        SUM(od.unit_price * od.quantity * (1 - od.discount)) AS margen_total,
        SUM(od.quantity) AS volumen_total
    FROM northwind_oltp.order_details od
    JOIN northwind_oltp.products p 
        ON od.product_id = p.product_id
    GROUP BY p.product_name
),
promedios AS (
    SELECT 
        AVG(volumen_total) AS volumen_promedio,
        SUM(margen_total) AS ganancias_totales
    FROM ventas_por_producto
)
SELECT 
    v.product_name,
    v.margen_unitario_aprox,
    v.margen_total,
    v.volumen_total,
    ROUND(CAST((v.margen_total / p.ganancias_totales) * 100 AS numeric), 2) AS porcentaje_ganancias
FROM ventas_por_producto v, promedios p
WHERE v.volumen_total >= p.volumen_promedio
ORDER BY v.margen_total DESC;
```

| product_name             | margen_unitario_aprox | margen_total | volumen_total | porcentaje_ganancias |
|--------------------------|-----------------------|--------------|---------------|----------------------|
| Thüringer Rostbratwurst  | 116.04                | 80368.67     | 746           | 6.35                 |
| Raclette Courdavault     | 51.13                 | 71155.70     | 1496          | 5.62                 |
| Tarte au sucre           | 46.41                 | 47234.97     | 1083          | 3.73                 |
| Camembert Pierrot        | 32.13                 | 46825.48     | 1577          | 3.70                 |
| Gnocchi di nonna Alice   | 35.42                 | 42593.06     | 1263          | 3.36                 |
| ...                      | ...                   | ...          | ...           | ...                  |

**Análisis:**  
El producto con mayor margen unitario aproximado es **Thüringer Rostbratwurst**, que además concentra un margen total elevado y representa el **6.35% de las ganancias globales**, con un volumen comparable al promedio. Le siguen **Raclette Courdavault** y **Tarte au sucre**, que combinan márgenes relevantes con altos volúmenes de venta. **Camembert Pierrot** destaca por su gran volumen y una participación significativa en las ganancias. En conjunto, estos resultados permiten identificar los productos más estratégicos: aquellos que no solo tienen un margen unitario superior, sino que además mantienen ventas representativas y aportan un porcentaje considerable a la rentabilidad global, lo que los convierte en candidatos prioritarios para políticas de precios, promociones y gestión de inventario.

### Query 3: Producto con mayor volumen total, margen y participación en ganancias

```sql
WITH ventas_por_producto AS (
    SELECT 
        p.product_name,
        SUM(od.quantity) AS volumen_total,
        AVG(od.unit_price) AS margen_unitario_aprox,
        SUM(od.unit_price * od.quantity * (1 - od.discount)) AS ingresos_netos
    FROM northwind_oltp.order_details od
    JOIN northwind_oltp.products p 
        ON od.product_id = p.product_id
    GROUP BY p.product_name
),
totales AS (
    SELECT 
        SUM(ingresos_netos) AS ganancias_totales
    FROM ventas_por_producto
)
SELECT 
    v.product_name,
    v.volumen_total,
    v.margen_unitario_aprox,
    v.ingresos_netos,
    ROUND(CAST((v.ingresos_netos / t.ganancias_totales) * 100 AS numeric), 2) AS porcentaje_ganancias
FROM ventas_por_producto v, totales t
ORDER BY v.volumen_total DESC
LIMIT 10;
```

| product_name             | volumen_total | margen_unitario_aprox | ingresos_netos | porcentaje_ganancias |
|--------------------------|---------------|-----------------------|----------------|----------------------|
| Camembert Pierrot        | 1577          | 32.13                 | 46825.48       | 3.70                 |
| Raclette Courdavault     | 1496          | 51.13                 | 71155.70       | 5.62                 |
| Gorgonzola Telino        | 1397          | 11.67                 | 14920.87       | 1.18                 |
| Gnocchi di nonna Alice   | 1263          | 35.42                 | 42593.06       | 3.36                 |
| Pavlova                  | 1158          | 16.38                 | 17215.78       | 1.36                 |
| Rhönbräu Klosterbier     | 1155          | 7.38                  | 8177.49        | 0.65                 |
| Guaraná Fantástica       | 1125          | 4.24                  | 4504.36        | 0.36                 |
| Boston Crab Meat         | 1103          | 17.23                 | 17910.63       | 1.41                 |
| Tarte au sucre           | 1083          | 46.41                 | 47234.97       | 3.73                 |
| Flotemysost              | 1057          | 19.76                 | 19551.03       | 1.54                 |

**Análisis:**  
El producto con mayor volumen total es **Camembert Pierrot**, con 1,577 unidades vendidas, un margen unitario aproximado de 32.13 y una participación del **3.70% en las ganancias totales**. Le siguen **Raclette Courdavault** y **Gorgonzola Telino**, que muestran volúmenes elevados pero márgenes distintos: Raclette combina alto volumen con un margen unitario sólido, mientras que Gorgonzola tiene gran volumen pero un margen bajo, lo que reduce su aporte a las ganancias. En conjunto, esta consulta permite evaluar si los productos más vendidos son también los más rentables, y detectar aquellos que requieren ajustes en precio o estrategia comercial para maximizar utilidad.

### Query 4: Relación volumen vs. margen

```sql
WITH ventas_por_producto AS (
    SELECT 
        p.product_name,
        SUM(od.quantity) AS volumen_total,
        AVG(od.unit_price) AS margen_unitario_aprox,
        SUM(od.unit_price * od.quantity * (1 - od.discount)) AS ingresos_netos
    FROM northwind_oltp.order_details od
    JOIN northwind_oltp.products p 
        ON od.product_id = p.product_id
    GROUP BY p.product_name
),
top_volumen AS (
    SELECT product_name, volumen_total, margen_unitario_aprox, ingresos_netos
    FROM ventas_por_producto
    ORDER BY volumen_total DESC
    LIMIT 3
),
top_margen AS (
    SELECT product_name, volumen_total, margen_unitario_aprox, ingresos_netos
    FROM ventas_por_producto
    ORDER BY ingresos_netos DESC
    LIMIT 3
)
SELECT grupo, 
       product_name, 
       volumen_total, 
       ROUND(CAST(margen_unitario_aprox AS numeric),2) AS margen_unitario_aprox, 
       ROUND(CAST(ingresos_netos AS numeric),2) AS ingresos_netos
FROM (
    SELECT 'TOP VOLUMEN' AS grupo, * FROM top_volumen
    UNION ALL
    SELECT 'TOP MARGEN' AS grupo, * FROM top_margen
) sub
ORDER BY ingresos_netos DESC;
```

| grupo       | product_name           | volumen_total | margen_unitario_aprox | ingresos_netos |
|-------------|------------------------|---------------|-----------------------|----------------|
| TOP MARGEN  | Côte de Blaye          | 623           | 245.93                | 141396.74      |
| TOP MARGEN  | Thüringer Rostbratwurst| 746           | 116.04                | 80368.67       |
| TOP VOLUMEN | Raclette Courdavault   | 1496          | 51.13                 | 71155.70       |
| TOP MARGEN  | Raclette Courdavault   | 1496          | 51.13                 | 71155.70       |
| TOP VOLUMEN | Camembert Pierrot      | 1577          | 32.13                 | 46825.48       |
| TOP VOLUMEN | Gorgonzola Telino      | 1397          | 11.67                 | 14920.87       |

**Análisis:**  
- Los **TOP MARGEN** (Côte de Blaye, Thüringer Rostbratwurst y Raclette Courdavault) generan en conjunto más de **293,000 en ingresos netos**, con márgenes unitarios muy altos (entre 51 y 246).

### Query 5: Tabla base de productos (volumen y margen)

```sql
WITH ventas_por_producto AS (
    SELECT 
        p.product_name,
        SUM(od.quantity) AS volumen_total,
        AVG(od.unit_price) AS margen_unitario_aprox
    FROM northwind_oltp.order_details od
    JOIN northwind_oltp.products p 
        ON od.product_id = p.product_id
    GROUP BY p.product_name
)
SELECT 
    product_name,
    volumen_total,
    ROUND(CAST(margen_unitario_aprox AS numeric),2) AS margen_unitario_aprox
FROM ventas_por_producto
ORDER BY volumen_total DESC;
```

| product_name            | volumen_total | margen_unitario_aprox |
|-------------------------|---------------|-----------------------|
| Camembert Pierrot       | 1577          | 32.13                 |
| Raclette Courdavault    | 1496          | 51.13                 |
| Gorgonzola Telino       | 1397          | 11.67                 |
| Gnocchi di nonna Alice  | 1263          | 35.42                 |
| Pavlova                 | 1158          | 16.38                 |
| ...                     | ...           | ...                   |

## 📍 Fórmula utilizada
La base generada por el **Query 5** servirá para aplicar la siguiente relación:

<img src="https://latex.codecogs.com/svg.latex?\Delta%20Volumen%20\approx%20\frac{\Delta%20Margen}{Margen\_Unitario}%20\times%20Volumen\_Actual" />

- **ΔMargen:** reducción absoluta en el margen unitario (ejemplo: 10%).  
- **Margen Unitario:** precio promedio por unidad.  
- **Volumen Actual:** cantidad total vendida del producto.  

El resultado de esta fórmula indica cuántas **unidades adicionales** se deben vender para compensar una reducción en el margen.  

👉 Este query fue utilizado como **base para el dashboard**, donde se graficó la relación entre el descuento aplicado al margen y el incremento en volumen requerido por producto.

---

## 📍 Extensión con Elasticidad
Para simular un escenario más realista, se introdujo un parámetro de **elasticidad (E)**:

<img src="https://latex.codecogs.com/svg.latex?\Delta%20Volumen%20\approx%20\frac{\Delta%20Margen}{Margen\_Unitario}%20\times%20Volumen\_Actual%20\times%20E" />

- **E = 1.0** → el volumen compensa exactamente la pérdida de margen (ingresos ≈ iguales).  
- **E > 1.0** → el volumen crece más de lo necesario → ingresos después pueden ser mayores.  
- **E < 1.0** → el volumen crece menos → ingresos después bajan más que el descuento.  

---

## 📊 Dashboard en Power BI
El análisis completo se encuentra en el archivo [`dashboard.pbix`](./dashboard.pbix).  
Este archivo incluye:
- Modelo de datos con las columnas `product_name`, `volumen_total`, `margen_unitario_aprox`.
- Medidas DAX para calcular ingresos antes, después, variación y elasticidad.
- Visualizaciones interactivas con slider de descuento y filtros por producto.

## 📍 Resultados del Dashboard
- Con descuentos pequeños (ej. 10%), el volumen adicional compensa casi toda la pérdida de margen.  
- Con elasticidad > 1, los ingresos después pueden subir ligeramente, pero nunca de manera significativa.  
- Con descuentos grandes (ej. 30%+), aunque el volumen adicional aumenta mucho, los ingresos después siguen siendo menores que los ingresos antes.  
- El **Aumento Ingresos %** observado en el dashboard fue cercano a cero o negativo en la mayoría de los escenarios.

---

## 📍 Conclusión
El análisis demuestra que una campaña de descuentos **no es una estrategia rentable** bajo las condiciones actuales:  
- Los ingresos tienden a mantenerse iguales o disminuir.  
- El volumen adicional no logra compensar la pérdida de margen en escenarios realistas.  
- Aunque se esperaba que los descuentos generaran un aumento en ingresos, los resultados muestran lo contrario.  

👉 **Conclusión final:** No es recomendable implementar una campaña de descuentos masiva, ya que no cumple con el objetivo esperado de incrementar los ingresos.  

---

## 📍 Reflexión
El resultado puede ser decepcionante, pero es mejor contar con un modelo que muestre la realidad:  
- Los descuentos atraen volumen, pero sacrifican margen.  
- Sin una elasticidad extraordinaria, los ingresos no mejoran.  
- La estrategia debe replantearse hacia promociones selectivas o diferenciadas, en lugar de descuentos generalizados.
