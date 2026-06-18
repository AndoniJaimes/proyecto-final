----------------
-- Query 1
----------------

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


----------------
-- Query 2
----------------

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

----------------
-- Query 3
----------------

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

----------------
-- Query 4
----------------

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

----------------
-- Query 5
----------------

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
