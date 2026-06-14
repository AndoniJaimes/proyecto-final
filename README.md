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

4. **Relación volumen vs. margen bajo descuentos**  
   - ¿Hasta qué punto los descuentos altos logran compensar la pérdida de margen con un incremento en volumen?  
   - Justificación: responder si una campaña de descuentos masivos es factible y rentable, o si erosiona la utilidad neta.

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

