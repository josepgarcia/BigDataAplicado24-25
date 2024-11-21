# Ejercicio 1: análisis de ventas

# **Problema de Análisis de Ventas utilizando Hadoop y HDFS**

## **Contexto**

Imagina que una cadena de tiendas de electrónica tiene presencia en diferentes países y ha recopilado datos de ventas durante varios años. Estas tiendas venden diferentes tipos de productos, desde teléfonos móviles hasta electrodomésticos, y los datos de las transacciones están almacenados en archivos distribuidos en un sistema de archivos distribuido, como **HDFS (Hadoop Distributed File System)**.

Tu trabajo es diseñar un sistema de análisis utilizando **Hadoop** para procesar y obtener información útil sobre las ventas, con el objetivo de ayudar a los directivos a tomar decisiones estratégicas basadas en datos.

## **Objetivos del Análisis**

1.	**Identificar los productos más vendidos por cada categoría.**

2.	**Analizar las tendencias de ventas a lo largo del tiempo (por mes, trimestre y año).**

3.	**Determinar las regiones o ciudades que generan mayores ingresos.**

4.	**Estimar el impacto de las promociones en las ventas.**

5.	**Predecir las ventas futuras basadas en datos históricos (opcional, si se desea extender el proyecto con aprendizaje automático).**

## **Datos Disponibles**

Los datos están organizados en múltiples archivos CSV almacenados en HDFS, con el siguiente formato:

**Archivo: ventas.csv**

Cada fila en este archivo representa una transacción de venta:

•	**transaction_id:** Identificador único de la transacción.

•	**date:** Fecha de la transacción (formato YYYY-MM-DD).

•	**store_id:** ID de la tienda.

•	**product_id:** ID del producto vendido.

•	**category:** Categoría del producto (por ejemplo, “Electrónica”, “Electrodomésticos”).

•	**quantity:** Cantidad de productos vendidos.

•	**price:** Precio unitario del producto.

•	**total_amount:** Cantidad total (precio * cantidad).

•	**promotion:** Indicador binario (0 o 1) para señalar si la transacción se realizó con una promoción activa.

•	**region:** Región o ciudad donde se realizó la venta.

**Archivo: productos.csv**

Información detallada de cada producto:

•	**product_id:** Identificador único del producto.

•	**name:** Nombre del producto.

•	**category:** Categoría a la que pertenece el producto.

•	**brand:** Marca del producto.

**Archivo: tiendas.csv**

Información sobre las tiendas:

•	**store_id:** Identificador único de la tienda.

•	**store_name:** Nombre de la tienda.

•	**region:** Región donde se encuentra la tienda (ciudad/país).

•	**opening_date:** Fecha en que la tienda abrió sus puertas.

# **Solución**

## **Almacenamiento de Datos en HDFS**

•	**Cargar los archivos** ventas.csv**,** productos.csv **y** tiendas.csv **en HDFS.**

•	Crear directorios en HDFS para almacenar los datos, por ejemplo:

•	/user/ventas/

•	/user/productos/

•	/user/tiendas/

•	Usar los comandos de HDFS para mover los archivos desde el sistema local a HDFS:

```php
hdfs dfs -mkdir /user/ventas
hdfs dfs -mkdir /user/productos
hdfs dfs -mkdir /user/tiendas

hdfs dfs -put ventas.csv /user/ventas/
hdfs dfs -put productos.csv /user/productos/
hdfs dfs -put tiendas.csv /user/tiendas/
```

## **Procesamiento de Ventas (Hadoop MapReduce)**

### 1. **Total de ventas por producto y por región.**

El objetivo de este MapReduce es sumar las ventas totales por cada producto y por cada región. El mapper dividirá las ventas por product_id y region, y el reducer sumará los totales.

•	**Mapper:** Procesa cada línea de ventas.csv, extrae product_id, region, y total_amount.

•	**Reducer:** Recibe las claves (product_id, region) y suma los valores (total_amount).

```python
**mapper**:

def map(line):
    fields = line.split(',')
    product_id = fields[3]
    region = fields[8]
    total_amount = float(fields[6])
    emit((product_id, region), total_amount)
    
    
**reducer:**

def reduce(key, values):
    total_sales = sum(values)
    emit(key, total_sales)
```

Salida esperada:

•	**(product_id, region) -> total_sales**

### 2. **Identificar el producto más vendido por categoría.**

El objetivo de este MapReduce es determinar cuál fue el producto más vendido por cada categoría.

•	**Mapper:** Procesa cada línea de ventas.csv, emite category, product_id, y la cantidad vendida (quantity).

•	**Reducer:** Suma las cantidades vendidas por product_id y encuentra el producto con la mayor suma para cada categoría.

```python
**mapper:**

def map(line):
    fields = line.split(',')
    category = fields[4]
    product_id = fields[3]
    quantity = int(fields[5])
    emit((category, product_id), quantity)

**reducer:**

def reduce(key, values):
    total_quantity = sum(values)
    emit(key, total_quantity)
```

Paso Adicional: Para identificar el producto más vendido por categoría, se podría ejecutar una segunda fase de reducción donde se elige el producto con la mayor cantidad por categoría.

## **Análisis de Tendencias (HIVE + PIG)**

En lugar de usar solo MapReduce, se podría utilizar Pig o Hive para analizar las ventas en intervalos de tiempo (mes, trimestre, año).

•	**Consulta en Hive:** Se puede escribir una consulta en Hive para agrupar las ventas por mes, trimestre o año.

Ejemplo de consulta en Hive para ventas mensuales:

```sql
SELECT year(date), month(date), SUM(total_amount)
FROM ventas
GROUP BY year(date), month(date)
ORDER BY year(date), month(date);
```

	•	**Consulta en Pig:** Para Pig, se podría cargar el archivo de ventas y luego hacer la agregación:

```sql
ventas = LOAD '/user/ventas/ventas.csv' USING PigStorage(',') AS (transaction_id:chararray, date:chararray, store_id:int, product_id:int, category:chararray, quantity:int, price:float, total_amount:float, promotion:int, region:chararray);

ventas_por_mes = FOREACH ventas GENERATE SUBSTRING(date, 0, 7) as mes, total_amount;
ventas_agrupadas = GROUP ventas_por_mes BY mes;
ventas_totales = FOREACH ventas_agrupadas GENERATE group AS mes, SUM(ventas_por_mes.total_amount) AS total_ventas;
```

## **Paso Opcional: Exportar Resultados**

Al finalizar el procesamiento, los resultados podrían guardarse nuevamente en HDFS o exportarse a bases de datos externas como HBase o una base de datos SQL para generar informes.