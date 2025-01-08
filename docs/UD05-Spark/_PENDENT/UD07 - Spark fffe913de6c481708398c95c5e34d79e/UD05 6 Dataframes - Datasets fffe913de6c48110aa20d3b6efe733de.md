# UD05 6. Dataframes - Datasets

# DataFrames

<aside>
👨🏼‍🏫 FUENTE: [https://aitor-medrano.github.io/iabd/spark/dataframeAPI.html](https://aitor-medrano.github.io/iabd/spark/dataframeAPI.html)

</aside>

Lo RDD permiten trabajar a bajo nivel, mientras que los DataFrames permiten hacer uso del lenguaje SQL.

- Son una abastracción de datos distribuidos y estructurados.
- Estructura:Similares a una tabla de una BD relacional (filas y columnas).
- Schema Information: Permite la optimización de consultas entre otras.

## Ventajas sobre los RDD

- Consultas optimizadas gracias a la información de Schema.
- Más rápidos y eficientes en el procesamiento de datos.
- Facilidad de uso:
    - Lenguaje de consulta de alto nivel (parecido a SQL)
    - Más sencillo, comparado a las transformaciones de los RDD
- Integración con el ecosistema Spark.
- Builtin optimization….
- Fácil conversión a Panda dataframes.

```python
from pyspark.sql import SparkSession
spark = SparkSession.builder.appName("DataFrame-Demo").getOrCreate()
```

```python
spark
```

## RDD vs DataFrame

### Preparamos un fichero con datos

Preparamos un archivo (lorem ipsum) con datos.
https://es.wikipedia.org/wiki/Lorem_ipsum

```python
import requests
api_url = 'https://loripsum.net/api/10/long/headers'response = requests.get(api_url)
if response.status_code == requests.codes.ok:
    f = open("./lorem.txt", "w")
    f.write(response.text)
    f.close()
    print("Fichero creado.")
else:
    print("Error:", response.status_code, response.text)
```

### Con RDD

```python
rdd = spark.sparkContext.textFile("./lorem.txt")
```

```python
result_rdd = rdd.flatMap(lambda line: line.split(" ")) \.map(lambda word: (word, 1)) \.reduceByKey(lambda a, b: a + b) \.sortBy(lambda x: x[1], ascending=False)
```

```python
result_rdd.take(10)
```

### Con DataFrames

```python
df = spark.read.text("./lorem.txt")
result_df = df.selectExpr("explode(split(value,' ')) as word") \.groupBy("word").count().orderBy("count",ascending=False)
```

```python
result_df.take(10)
```

## Creación DataFrames

1. La manera más sencilla es a partid de un RDD mediante `toDF`

```python
from pyspark.sql import SparkSession
# SparkSessionspark = SparkSession.builder.getOrCreate()
# Creamos un RDDdatos = [("Aitor", 182), ("Pedro", 178), ("Marina", 161)]
rdd = spark.sparkContext.parallelize(datos)
# Creamos un DataFrame y mostramos su esquemadfRDD = rdd.toDF()
dfRDD.printSchema()
```

```
root
 |-- _1: string (nullable = true)
 |-- _2: long (nullable = true)
```

*Y mediante `printSchema` obtenemos un resumen del esquema del DataFrame , donde para cada columna se indica el nombre, el tipo y si admite valores nulos.*

Si nos fijamos en la salida de prindSchema vemos que el nombre de las columnas son _1 y _2, podemos cambiarlo con:

```python
columnas = ["nombre", "altura"]
dfRDD = rdd.toDF(columnas)
dfRDD.printSchema()
```

```
root
 |-- nombre: string (nullable = true)
 |-- altura: long (nullable = true)
```

Para mostrar los datos del df

```python
dfRDD.show()
```

```
+------+------+
|nombre|altura|
+------+------+
| Aitor|   182|
| Pedro|   178|
|Marina|   161|
+------+------+
```

1. Creación directamente desde una SparkSession

```python
dfDesdeDatos = spark.createDataFrame(datos, columnas)
dfDesdeDatos.printSchema()
```

```
root
 |-- nombre: string (nullable = true)
 |-- altura: long (nullable = true)
```

## Mostrar datos

```python
clientes = [
    ("Aitor", "Medrano", "Elche", 3000),
    ("Pedro", "Casas", "Elche", 4000),
    ("Laura", "García", "Elche", 5000),
    ("Miguel", "Ruiz", "Torrellano", 6000),
    ("Isabel", "Guillén", "Alicante", 7000)
]
columnas = ["nombre","apellidos", "ciudad", "sueldo"]
df = spark.createDataFrame(clientes, columnas)
```

### show()

```python
# only showing top 2 rowsdf.show(2)
df.show(truncate=False)
# only showing top 3 rowsdf.show(3, vertical=True)
```

```
+------+---------+------+------+
|nombre|apellidos|ciudad|sueldo|
+------+---------+------+------+
| Aitor|  Medrano| Elche|  3000|
| Pedro|    Casas| Elche|  4000|
+------+---------+------+------+
only showing top 2 rows

+------+---------+----------+------+
|nombre|apellidos|ciudad    |sueldo|
+------+---------+----------+------+
|Aitor |Medrano  |Elche     |3000  |
|Pedro |Casas    |Elche     |4000  |
|Laura |García   |Elche     |5000  |
|Miguel|Ruiz     |Torrellano|6000  |
|Isabel|Guillén  |Alicante  |7000  |
+------+---------+----------+------+

-RECORD 0------------
 nombre    | Aitor
 apellidos | Medrano
 ciudad    | Elche
 sueldo    | 3000
-RECORD 1------------
 nombre    | Pedro
 apellidos | Casas
 ciudad    | Elche
 sueldo    | 4000
-RECORD 2------------
 nombre    | Laura
 apellidos | García
 ciudad    | Elche
 sueldo    | 5000
only showing top 3 rows
```

### head() first()

```python
#df.first()#df.head()#df.head(3)
```

```python
nom1 = df.first()[0]
nom2 = df.first()['nombre']
print(nom1,nom2)
```

```
Aitor Aitor
```

### describe()

Obtenemos un sumario de datos (como con Pandas)

```python
df.describe().show()
```

```
+-------+------+---------+----------+------------------+
|summary|nombre|apellidos|    ciudad|            sueldo|
+-------+------+---------+----------+------------------+
|  count|     5|        5|         5|                 5|
|   mean|  NULL|     NULL|      NULL|            5000.0|
| stddev|  NULL|     NULL|      NULL|1581.1388300841897|
|    min| Aitor|    Casas|  Alicante|              3000|
|    max| Pedro|     Ruiz|Torrellano|              7000|
+-------+------+---------+----------+------------------+
```

### count()

Total de filas

```python
df.count()
```

```
5
```

### collect() take()

Como un DataFrame por debajo es un RDD también podemos utilizar estas
funciones

```python
print(df.collect(),"\n")
print(df.take(2),"\n")
print(df.collect()[0][0])
```

```
[Row(nombre='Aitor', apellidos='Medrano', ciudad='Elche', sueldo=3000), Row(nombre='Pedro', apellidos='Casas', ciudad='Elche', sueldo=4000), Row(nombre='Laura', apellidos='García', ciudad='Elche', sueldo=5000), Row(nombre='Miguel', apellidos='Ruiz', ciudad='Torrellano', sueldo=6000), Row(nombre='Isabel', apellidos='Guillén', ciudad='Alicante', sueldo=7000)]

[Row(nombre='Aitor', apellidos='Medrano', ciudad='Elche', sueldo=3000), Row(nombre='Pedro', apellidos='Casas', ciudad='Elche', sueldo=4000)]

Aitor
```

## Carga de datos

Documentación oficial

https://spark.apache.org/docs/latest/sql-data-sources-parquet.html

Lo más usual es cargar los datos desde una archivo externo. Para
ello, mediante el API de DataFrameReader cargaremos los datos
directamente en un Dataframe mediante diferentes métodos dependiendo del
formato (admite tanto el nombre de un recurso como una ruta de una
carpeta).

Para cada formato, existe un método corto que se llama como el
formato en sí, y un método general donde mediante format indicamos el
formato y que finaliza con el método load siempre dentro de
spark.read:

### csv

```python
dfCSV = spark.read.csv("datos.csv")
dfCSV = spark.read.csv("datos/*.csv")   # Una carpeta enteradfCSV = spark.read.option("sep", ";").csv("datos.csv")
dfCSV = spark.read.option("header", "true").csv("datos.csv")
dfCSV = spark.read.option("header", True).option("inferSchema", True).csv("datos.csv")
dfCSV = spark.read.options(sep=";", header=True, inferSchema=True).csv("pdi_sales.csv")
dfCSV = spark.read.format("csv").load("datos.csv")
dfCSV = spark.read.load(path="datos.csv", format="csv", header="true", sep=";", inferSchema="true")
```

### txt

```python
dfTXT = spark.read.text("datos.txt")
# cada fichero se lee entero como un registrodfTXT = spark.read.option("wholetext", true).text("datos/")
dfTXT = spark.read.format("txt").load("datos.txt")
```

### json

```python
dfJSON = spark.read.json("datos.json")
dfJSON = spark.read.format("json").load("datos.json")
```

### parquet

https://spark.apache.org/docs/latest/sql-data-sources-parquet.html

```python
dfParquet = spark.read.parquet("datos.parquet")
dfParquet = spark.read.format("parquet").load("datos.parquet")
```

## Persistencia

Documentación oficial

https://spark.apache.org/docs/latest/sql-data-sources-parquet.html

Para la persistencia de los datos utilizaremos write en vez de read,
también save

```python
# CSVdfCSV.write.csv("datos.csv")
dfCSV.write.format("csv").save("datos.csv")
dfCSV.write.format("csv").mode("overwrite").save("datos.csv")
# TXTdfTXT.write.text("datos.txt")
dfTXT.write.option("lineSep",";").text("datos.txt")
dfTXT.write.format("txt").save("datos.txt")
# JsondfJSON.write.json("datos.json")
dfJSON.write.format("json").save("datos.json")
# ParquetdfParquet.write.parquet("datos.parquet")
dfParquet.write.mode("overwrite").partitionBy("fecha").parquet("datos/")
dfParquet.write.format("parquet").save("datos.parquet")
```

## Compresión

## Datos y Esquemas

El esquema completo de un DataFrame se modela mediante un StructType, el cual contiene una colección de objetos StructField. Así pues, cada columna de un DataFrame de Spark se modela mediante un objeto StructField indicando su nombre, tipo y gestión de los nulos.

Hemos visto que al crear un DataFrame desde un archivo externo, podemos inferir el esquema. Si queremos crear un DataFrame desde un esquema propio utilizaremos los tipos StructType, StructField, así como StringType, IntegerType o el tipo necesario para cada columna. Para ello, primero hemos de importarlos (como puedes observar, estas clases pertenecen a las librerías SQL de PySpark):

```python
from pyspark.sql import SparkSession
from pyspark.sql.types import StructType, StructField, StringType, IntegerType
```

Además de cadenas y enteros, flotantes (FloatType) o dobles (DoubleType), tenemos tipos booleanos (BooleanType), de fecha (DateType y TimestampType), así como tipos complejos como ArrayType, MapType y StructType. Para más información, consultar la documentación oficial.

Volvamos al ejemplo anterior donde tenemos ciertos datos de clientes, como son su nombre y apellidos, ciudad y sueldo:

```python
clientes = [
    ("Juan", "Garcia", "Valencia", 3000),
    ("Pedro", "Casas", "Elche", 4000),
    ("Laura", "García", "Madrid", 5000),
    ("Miguel", "Ruiz", "Carlet", 6000),
    ("Isabel", "Guillén", "Alzira", 7000)
]
```

Para esta estructura, definiremos un esquema con los campos, indicando para cada uno de ellos su nombre, tipo y si admite valores nulos:

```python
esquema = StructType([
    StructField("nombre", StringType(), False),
    StructField("apellidos", StringType(), False),
    StructField("ciudad", StringType(), True),
    StructField("sueldo", IntegerType(), False)
])
```

A continuación ya podemos crear un DataFrame con datos propios que cumplen un esquema haciendo uso del método createDataFrame:

```python
# Sin especificar schemadfsin = spark.createDataFrame(data=clientes)
dfsin.printSchema()
dfsin.show(truncate=False)
```

```
root
 |-- _1: string (nullable = true)
 |-- _2: string (nullable = true)
 |-- _3: string (nullable = true)
 |-- _4: long (nullable = true)

+------+-------+--------+----+
|_1    |_2     |_3      |_4  |
+------+-------+--------+----+
|Juan  |Garcia |Valencia|3000|
|Pedro |Casas  |Elche   |4000|
|Laura |García |Madrid  |5000|
|Miguel|Ruiz   |Carlet  |6000|
|Isabel|Guillén|Alzira  |7000|
+------+-------+--------+----+
```

```python
df = spark.createDataFrame(data=clientes, schema=esquema)
df.printSchema()
df.show(truncate=False)
```

```
root
 |-- nombre: string (nullable = false)
 |-- apellidos: string (nullable = false)
 |-- ciudad: string (nullable = true)
 |-- sueldo: integer (nullable = false)

+------+---------+--------+------+
|nombre|apellidos|ciudad  |sueldo|
+------+---------+--------+------+
|Juan  |Garcia   |Valencia|3000  |
|Pedro |Casas    |Elche   |4000  |
|Laura |García   |Madrid  |5000  |
|Miguel|Ruiz     |Carlet  |6000  |
|Isabel|Guillén  |Alzira  |7000  |
+------+---------+--------+------+
```

Si lo que queremos es asignarle un esquema a un DataFrame que vamos a leer desde una fuente de datos externa, hemos de emplear el método schema:

```python
# dfClientes = spark.read.option("header", True).schema(esquema).csv("clientes.csv")
```

La inferencia de los tipos de los datos es un proceso computacionalmente costoso. Por ello, si nuestro conjunto de datos es grande, es muy recomendable crear el esquema de forma programativa y configurarlo en la carga de datos.

Se recomienda la lectura del artículo Using schemas to speed up reading into Spark DataFrames.
https://t-redactyl.io/blog/2020/08/using-schemas-to-speed-up-reading-into-spark-dataframes.html

Respecto al esquema, tenemos diferentes propiedades como columns, dtypes y schema con las que obtener su información:

```python
df.columns
# ['nombre', 'apellidos', 'ciudad', 'sueldo']df.dtypes
# [('nombre', 'string'),#  ('apellidos', 'string'),#  ('ciudad', 'string'),#  ('sueldo', 'int')]df.schema
# StructType(List(StructField(nombre,StringType,false),StructField(apellidos,StringType,false),StructField(ciudad,StringType,true),StructField(sueldo,IntegerType,false)))
```

```
StructType([StructField('nombre', StringType(), False), StructField('apellidos', StringType(), False), StructField('ciudad', StringType(), True), StructField('sueldo', IntegerType(), False)])
```

Si una vez hemos cargado un DataFrame queremos cambiar el tipo de una de sus columnas, podemos hacer uso del método withColumn:

```python
# Forma largafrom pyspark.sql.types import DoubleType
df = df.withColumn("sueldo", df.sueldo.cast(DoubleType()))
# Forma cortadf = df.withColumn("sueldo", df.sueldo.cast("double"))
# df = df.withColumn("fnac", to_date(df.Date, "M/d/yyy"))
```

### Errores al leer datos

Si tenemos un error al leer un dato que contiene un tipo no esperado, por defecto, Spark lanzará una excepción y se detendrá la lectura.

Si queremos que asigne los tipos a los campos pero que no los valide, podemos pasarle el parámetro extra verifySchema a False al crear un DataFrame mediante spark.createDataFrame o enforceSchema también a False al cargar desde una fuente externa mediante spark.read, de manera que los datos que no concuerden con el tipo se quedarán nulos, vacíos o con valor 0, dependiendo del tipo de dato que tiene asignada la columna en el esquema.

```python
# dfClientes = spark.read.option("header", True).option("enforceSchema",False).schema(esquema).csv("clientes.csv")
```

### inferSchema

Obtención del schema en modo automático

## DataFrame API

Existen también 2 tipos de operaciones:

- Transforamciones
- Acciones

Estas operaciones **no modifican el DataFrame sobre el que realizamos la transformación**. Por lo que realizaremos un encadenamiento de transformaciones (transformation chaining) o asignaremos el resultado a un nuevo DataFrame.

Cargamos el fichero de ventas (pdi_sales_small.csv)

```python
from pyspark.sql import SparkSession
spark = SparkSession.builder.appName("s8a-dataframes-api").getOrCreate()
# Lectura de CSV con el ; como separador de columnas y con encabezadodf = spark.read.option("sep",";").option("header", "true").option("inferSchema", "true").csv("datos/pdi_sales_small.csv")
df.printSchema()
```

```
root
 |-- ProductID: integer (nullable = true)
 |-- Date: string (nullable = true)
 |-- Zip: string (nullable = true)
 |-- Units: integer (nullable = true)
 |-- Revenue: double (nullable = true)
 |-- Country: string (nullable = true)
```

### Select

Permite indicar las columnas a recuperar pasándolas como parámetros.

```python
df.select("ProductID","Revenue").show(3)
```

```
+---------+-------+
|ProductID|Revenue|
+---------+-------+
|      725|  115.5|
|      787|  314.9|
|      788|  314.9|
+---------+-------+
only showing top 3 rows
```

También podemos realizar cálculos, referenciando a los campos como nombreDataframe.nombreColumna y podemos crear alias y asociarlos aun
campo.

```python
df.select(df.ProductID,(df.Revenue+10).alias("VentasMas10")).show(3)
```

```
+---------+-----------+
|ProductID|VentasMas10|
+---------+-----------+
|      725|      125.5|
|      787|      324.9|
|      788|      324.9|
+---------+-----------+
only showing top 3 rows
```

Si tenemos un DataFrame con un gran número de columnas y queremos
recuperarlas todas a excepción de unas pocas, es más cómodo utilizar la
transformación drop, la cual funciona de manera opuesta a select, es
decir, indicando las columnas que queremos quitar del resultado

```python
# Obtenemos el mismo resultadodf.select("ProductID", "Date", "Zip")
df.drop("Units", "Revenue", "Country")
```

```
DataFrame[ProductID: int, Date: string, Zip: string]
```

### Columnas

Para acceder a las columnas, debemos crear objetos Column. Para ello,
podemos seleccionarlos a partir de un DataFrame como una propiedad o
mediante la función col:

```python
#nomCliente = df.nombre#nomCliente = df["ProductID"]#nomCliente = col("ProductID")
```

Podemos recuperar ciertas columnas de un DataFrame con cualquier de
las siguientes expresiones:

```python
from pyspark.sql.functions import col
#df.select("ProductID", "Revenue").show()#df.select(df.ProductID, df.Revenue).show()#df.select(df["ProductID"], df["Revenue"]).show()#df.select(col("ProductID"), col("Revenue")).show()
```

### withColumn: Añadiendo columnas

```python
dfNuevo = df.withColumn("total", df.Units * df.Revenue)
dfNuevo.show(3)
```

```
+---------+---------+---------------+-----+-------+-------+-----+
|ProductID|     Date|            Zip|Units|Revenue|Country|total|
+---------+---------+---------------+-----+-------+-------+-----+
|      725|1/15/1999|41540          |    1|  115.5|Germany|115.5|
|      787| 6/6/2002|41540          |    1|  314.9|Germany|314.9|
|      788| 6/6/2002|41540          |    1|  314.9|Germany|314.9|
+---------+---------+---------------+-----+-------+-------+-----+
only showing top 3 rows
```

Anteriormente hemos utilizado el método withColumn para cambiarle el
tipo a un campo ya existente. Así pues, si referenciamos a una columna
que ya existe, en vez de crearla, la sustituirá.

### selectExpr

Otra forma de añadir columnas:

```python
df.selectExpr("*", "Units * Revenue as total").show(3)
```

```
+---------+---------+---------------+-----+-------+-------+-----+
|ProductID|     Date|            Zip|Units|Revenue|Country|total|
+---------+---------+---------------+-----+-------+-------+-----+
|      725|1/15/1999|41540          |    1|  115.5|Germany|115.5|
|      787| 6/6/2002|41540          |    1|  314.9|Germany|314.9|
|      788| 6/6/2002|41540          |    1|  314.9|Germany|314.9|
+---------+---------+---------------+-----+-------+-------+-----+
only showing top 3 rows
```

También podemos realizar analítica de datos aprovechando SQL

```python
df.selectExpr("count(distinct(ProductID)) as productos","count(distinct(Country)) as paises").show()
```

```
+---------+------+
|productos|paises|
+---------+------+
|      799|     5|
+---------+------+
```

### withColumnRenamed

Cambiamos el nombre a una columna

```python
df.withColumnRenamed("Zip", "PostalCode").show(3)
```

```
+---------+---------+---------------+-----+-------+-------+
|ProductID|     Date|     PostalCode|Units|Revenue|Country|
+---------+---------+---------------+-----+-------+-------+
|      725|1/15/1999|41540          |    1|  115.5|Germany|
|      787| 6/6/2002|41540          |    1|  314.9|Germany|
|      788| 6/6/2002|41540          |    1|  314.9|Germany|
+---------+---------+---------------+-----+-------+-------+
only showing top 3 rows
```

### filter: Filtrado de datos

Podemos eliminar filas utilizando `filter`

```python
df.filter(df.Country=="Germany").show(3)
```

```
+---------+---------+---------------+-----+-------+-------+
|ProductID|     Date|            Zip|Units|Revenue|Country|
+---------+---------+---------------+-----+-------+-------+
|      725|1/15/1999|41540          |    1|  115.5|Germany|
|      787| 6/6/2002|41540          |    1|  314.9|Germany|
|      788| 6/6/2002|41540          |    1|  314.9|Germany|
+---------+---------+---------------+-----+-------+-------+
only showing top 3 rows
```

Por similitud con SQL, podemos utilizar también where como un alias
de filter:

```python
df.where(df.Units>20).show()
```

```
+---------+----------+---------------+-----+-------+-------+
|ProductID|      Date|            Zip|Units|Revenue|Country|
+---------+----------+---------------+-----+-------+-------+
|      495| 3/15/1999|75213 CEDEX 16 |   77|43194.1|France |
|     2091| 5/15/1999|9739           |   24| 3652.7|Mexico |
|     2091| 6/15/1999|40213          |   41| 6240.1|Germany|
|     2091|10/15/1999|40213          |   41| 6347.7|Germany|
|     2091|12/15/1999|40213          |   23| 3560.9|Germany|
+---------+----------+---------------+-----+-------+-------+
```

Podemos utilizar los operadores lógicos (& para conjunción y |
para la disyunción) para crear condiciones compuestas (recordad rodear
cada condición entre paréntesis):

```python
df.filter((df.Country=="Germany") & (df.Units>20)).show()
df.filter((df.ProductID==2314) | (df.ProductID==1322)).show()
```

```
+---------+----------+---------------+-----+-------+-------+
|ProductID|      Date|            Zip|Units|Revenue|Country|
+---------+----------+---------------+-----+-------+-------+
|     2091| 6/15/1999|40213          |   41| 6240.1|Germany|
|     2091|10/15/1999|40213          |   41| 6347.7|Germany|
|     2091|12/15/1999|40213          |   23| 3560.9|Germany|
+---------+----------+---------------+-----+-------+-------+

+---------+---------+---------------+-----+-------+-------+
|ProductID|     Date|            Zip|Units|Revenue|Country|
+---------+---------+---------------+-----+-------+-------+
|     2314|5/15/1999|46045          |    1|   13.9|Germany|
|     1322| 1/6/2000|75593 CEDEX 12 |    1|  254.5|France |
+---------+---------+---------------+-----+-------+-------+
```

### Eliminación duplicados

```python
df.select("Country").distinct().show()
df.dropDuplicates(["Country"]).select("Country").show()
```

```
+-------+
|Country|
+-------+
|Germany|
|France |
|Canada |
|Mexico |
| France|
+-------+

+-------+
|Country|
+-------+
|Germany|
|France |
|Canada |
|Mexico |
| France|
+-------+
```

### sort - orderBY

Permiten ordenar datos, son operaciones equivalentes.

```python
df.select("ProductID","Revenue").sort("Revenue").show(5)
df.sort("Revenue").show(5)
df.sort("Revenue", ascending=True).show(5)
df.sort(df.Revenue.asc()).show(5)
# Ordenación descendientedf.sort(df.Revenue.desc()).show(5)
df.sort("Revenue", ascending=False).show(5)
from pyspark.sql.functions import desc
df.sort(desc("Revenue")).show(5)
# Ordenación diferente en cada columnadf.sort(df.Revenue.desc(), df.Units.asc()).show(5)
df.sort(["Revenue","Units"], ascending=[0,1]).show(5)
```

```
+---------+-------+
|ProductID|Revenue|
+---------+-------+
|     2314|   13.9|
|     1974|   52.4|
|     1974|   52.4|
|     1974|   52.4|
|     1974|   52.4|
+---------+-------+
only showing top 5 rows

+---------+---------+---------------+-----+-------+-------+
|ProductID|     Date|            Zip|Units|Revenue|Country|
+---------+---------+---------------+-----+-------+-------+
|     2314|5/15/1999|46045          |    1|   13.9|Germany|
|     1974|3/15/1999|R3B            |    1|   52.4|Canada |
|     1974|4/15/1999|R3H            |    1|   52.4|Canada |
|     1974|3/15/1999|R3H            |    1|   52.4|Canada |
|     1974|1/15/1999|R3S            |    1|   52.4|Canada |
+---------+---------+---------------+-----+-------+-------+
only showing top 5 rows

+---------+---------+---------------+-----+-------+-------+
|ProductID|     Date|            Zip|Units|Revenue|Country|
+---------+---------+---------------+-----+-------+-------+
|     2314|5/15/1999|46045          |    1|   13.9|Germany|
|     1974|3/15/1999|R3B            |    1|   52.4|Canada |
|     1974|4/15/1999|R3H            |    1|   52.4|Canada |
|     1974|3/15/1999|R3H            |    1|   52.4|Canada |
|     1974|1/15/1999|R3S            |    1|   52.4|Canada |
+---------+---------+---------------+-----+-------+-------+
only showing top 5 rows

+---------+---------+---------------+-----+-------+-------+
|ProductID|     Date|            Zip|Units|Revenue|Country|
+---------+---------+---------------+-----+-------+-------+
|     2314|5/15/1999|46045          |    1|   13.9|Germany|
|     1974|3/15/1999|R3B            |    1|   52.4|Canada |
|     1974|4/15/1999|R3H            |    1|   52.4|Canada |
|     1974|3/15/1999|R3H            |    1|   52.4|Canada |
|     1974|1/15/1999|R3S            |    1|   52.4|Canada |
+---------+---------+---------------+-----+-------+-------+
only showing top 5 rows

+---------+---------+---------------+-----+-------+-------+
|ProductID|     Date|            Zip|Units|Revenue|Country|
+---------+---------+---------------+-----+-------+-------+
|      495|3/15/1999|75213 CEDEX 16 |   77|43194.1|France |
|      495| 3/1/2000|75391 CEDEX 08 |   18|10395.0|France |
|      464|6/11/2003|75213 CEDEX 16 |   16|10075.8|France |
|      464| 8/1/2000|22397          |   17| 9817.5|Germany|
|      495| 3/1/2000|06175 CEDEX 2  |   16| 9240.0|France |
+---------+---------+---------------+-----+-------+-------+
only showing top 5 rows

+---------+---------+---------------+-----+-------+-------+
|ProductID|     Date|            Zip|Units|Revenue|Country|
+---------+---------+---------------+-----+-------+-------+
|      495|3/15/1999|75213 CEDEX 16 |   77|43194.1|France |
|      495| 3/1/2000|75391 CEDEX 08 |   18|10395.0|France |
|      464|6/11/2003|75213 CEDEX 16 |   16|10075.8|France |
|      464| 8/1/2000|22397          |   17| 9817.5|Germany|
|      495| 3/1/2000|06175 CEDEX 2  |   16| 9240.0|France |
+---------+---------+---------------+-----+-------+-------+
only showing top 5 rows

+---------+---------+---------------+-----+-------+-------+
|ProductID|     Date|            Zip|Units|Revenue|Country|
+---------+---------+---------------+-----+-------+-------+
|      495|3/15/1999|75213 CEDEX 16 |   77|43194.1|France |
|      495| 3/1/2000|75391 CEDEX 08 |   18|10395.0|France |
|      464|6/11/2003|75213 CEDEX 16 |   16|10075.8|France |
|      464| 8/1/2000|22397          |   17| 9817.5|Germany|
|      495| 3/1/2000|06175 CEDEX 2  |   16| 9240.0|France |
+---------+---------+---------------+-----+-------+-------+
only showing top 5 rows

+---------+---------+---------------+-----+-------+-------+
|ProductID|     Date|            Zip|Units|Revenue|Country|
+---------+---------+---------------+-----+-------+-------+
|      495|3/15/1999|75213 CEDEX 16 |   77|43194.1|France |
|      495| 3/1/2000|75391 CEDEX 08 |   18|10395.0|France |
|      464|6/11/2003|75213 CEDEX 16 |   16|10075.8|France |
|      464| 8/1/2000|22397          |   17| 9817.5|Germany|
|      495| 3/1/2000|06175 CEDEX 2  |   16| 9240.0|France |
+---------+---------+---------------+-----+-------+-------+
only showing top 5 rows

+---------+---------+---------------+-----+-------+-------+
|ProductID|     Date|            Zip|Units|Revenue|Country|
+---------+---------+---------------+-----+-------+-------+
|      495|3/15/1999|75213 CEDEX 16 |   77|43194.1|France |
|      495| 3/1/2000|75391 CEDEX 08 |   18|10395.0|France |
|      464|6/11/2003|75213 CEDEX 16 |   16|10075.8|France |
|      464| 8/1/2000|22397          |   17| 9817.5|Germany|
|      495| 3/1/2000|06175 CEDEX 2  |   16| 9240.0|France |
+---------+---------+---------------+-----+-------+-------+
only showing top 5 rows
```

### limit

Normalmente al hacer una ordenación es habitual quedarse con un
subconjunto de datos.

```python
df.sort(df.Revenue.desc(), df.Units.asc()).limit(5).show()
```

```
+---------+---------+---------------+-----+-------+-------+
|ProductID|     Date|            Zip|Units|Revenue|Country|
+---------+---------+---------------+-----+-------+-------+
|      495|3/15/1999|75213 CEDEX 16 |   77|43194.1|France |
|      495| 3/1/2000|75391 CEDEX 08 |   18|10395.0|France |
|      464|6/11/2003|75213 CEDEX 16 |   16|10075.8|France |
|      464| 8/1/2000|22397          |   17| 9817.5|Germany|
|      495| 3/1/2000|06175 CEDEX 2  |   16| 9240.0|France |
+---------+---------+---------------+-----+-------+-------+
```

### Añadir filas

Hay que crear un nuevo DF con el mismo schema y utilizaremos
union

```python
nuevasVentas = [
    (6666, "2022-03-24", "03206", 33, 3333.33, "Spain"),
    (6666, "2022-03-25", "03206", 22, 2222.22, "Spain"),
]
# Creamos un nuevo DataFrame con las nuevas ventasnvDF = spark.createDataFrame(nuevasVentas)
# Unimos los dos DataFramesdfUpdated = df.union(nvDF)
```

Considerando dos DataFrames como dos conjuntos, podemos emplear las
operaciones union, intersect, intersectAll (mantiene los duplicados),
exceptAll (mantiene los duplicados) y subtract. -
https://spark.apache.org/docs/latest/api/python/reference/pyspark.sql/api/pyspark.sql.DataFrame.union.html
-
https://spark.apache.org/docs/latest/api/python/reference/pyspark.sql/api/pyspark.sql.DataFrame.intersect.html
-
https://spark.apache.org/docs/latest/api/python/reference/pyspark.sql/api/pyspark.sql.DataFrame.intersectAll.html
-
https://spark.apache.org/docs/latest/api/python/reference/pyspark.sql/api/pyspark.sql.DataFrame.exceptAll.html
-
https://spark.apache.org/docs/latest/api/python/reference/pyspark.sql/api/pyspark.sql.DataFrame.subtract.html

### Cogiendo muestras

Si necesitamos recoger un subconjunto de los datos, ya sea para
preparar los datos para algún modelo de machine learning como para una
muestra aleatoria de los mismos, podemos utilizar las siguientes
transformaciones:

### sample

Permite obtener una muestra a partir de un porcentaje (no tiene
porqué obtener una cantidad exacta). También admite un semilla e indicar
si queremos que pueda repetir los datos.

```python
df.count()                  # 120239muestra = df.sample(0.10)
muestra.count()             # 11876muestraConRepetidos = df.sample(True, 0.10)
muestraConRepetidos.count() # 11923
```

```
12130
```

### randomSplit

Recupera diferentes DataFrames cuyos tamaños en porcentaje se indican
como parámetros (si no suman uno, los parámetros se normalizan):

```python
dfs = df.randomSplit([0.8, 0.2])
dfEntrenamiento = dfs[0]
dfPrueba = dfs[1]
dfEntrenamiento.count()     # 96194dfPrueba.count()            # 24045
```

```
23990
```

**Realizar actividad 1**

## Trabajando con datos sucios

## Actividades

### Actividad 1

A partir del archivo nombres.json, crea un DataFrame y realiza las
siguientes operaciones:

1. Crea una nueva columna (columna Mayor30) que indique si la persona
es mayor de 30 años
2. Crea una nueva columna (columna FaltanJubilacion) que calcule
cuantos años le faltan para jubilarse (supongamos que se jubila a los 67
años)
3. Crea una nueva columna (columna Apellidos) que contenga XYZ (puedes
utilizar la función lit)
4. Elimina las columna Mayor30 y Apellidos.
5. Crea una nueva columna (columna AnyoNac) con el año de nacimiento de
cada persona (puedes utilizar la función current_date).
6. Añade un id incremental para cada fila (campo Id) y haz que al hacer
un show se vea en primer lugar (puedes utilizar la función
monotonically_increasing_id) seguidos del Nombre, Edad, AnyoNac,
FaltaJubilacion y Ciudad
7. Al realizar los seis pasos, el resultado del DataFrame será similar a :

```python
#+---+-------+----+-------+----------------+--------+#| Id|Nombre |Edad|AnyoNac|FaltanJubilacion|  Ciudad|#+---+-------+----+-------+----------------+--------+#|  1| Marina|  14|   2008|              53|Alicante|#|  0|  Aitor|  45|   1977|              22|   Elche|#|  2|  Laura|  19|   2003|              48|   Elche|#|  3|  Sonia|  45|   1977|              22|    Aspe|#|  4|  Pedro|null|   null|            null|   Elche|#+---+-------+----+-------+----------------+--------+
```

### Actividad 2

A partir del archivo VentasNulos.csv:

1. Elimina las filas que tengan al menos 4 nulos.
2. Con las filas restantes, sustituye:
    1. Los nombres nulos por Empleado
    2. Las ventas nulas por la media de las ventas de los compañeros (redondeado a entero).
        
        Agrupando
        
        Para obtener la media, aunque lo veremos en la próxima sesión, debes agrupar y luego obtener la media de la columna:
        
        valor = df.groupBy().avg('Ventas')
        
    3. Los euros nulos por el valor del compañero que menos € ha ganado. (tras agrupar, puedes usar la función min)
    4. La ciudad nula por C.V. y el identificador nulo por XYZ

Para los pasos b) y c) puedes crear un DataFrame que obtenga el valor a asignar y luego pasarlo como parámetro al método para rellenar los nulos.

### Actividad 3

A partir del archivo movies.tsv, crea una esquema de forma declarativa con los campos:

- interprete de tipo string
- pelicula de tipo string
- anyo de tipo int

Cada fila del fichero implica que el actor/actriz ha trabajado en dicha película en el año indicado.

- Una vez creado el esquema, carga los datos en un DataFrame.

A continuación, mediante el DataFrame API:

- Muestra las películas en las que ha trabajado Murphy, Eddie (I).
- Muestra los intérpretes que aparecen tanto en Superman como en Superman II.

# BORRARRRR —-1. RDD vs DataFrame

Lo RDD permiten trabajar a bajo nivel, mientras que los DataFrames permiten hacer uso del lenguaje SQL.

```bash
from pyspark.sql import SparkSession

# Mínimo para crear una sesión
spark = SparkSession.builder.getOrCreate() 

##################################################################
#### EJEMPLO RDD, accedemos a sparkContext
**rdd = spark.sparkContext.textFile("./data/data.txt")
result_rdd = rdd.flatMap(lambda line: line.split(" ")) \
    .map(lambda word: (word, 1)) \
    .reduceByKey(lambda a, b: a + b) \
    .sortBy(lambda x: x[1], ascending=False)
result_rdd.take(10)**

[('the', 12),
 ('of', 7),
 ('a', 7),
 ('in', 5),
 ('distributed', 5),
 ('Spark', 4),
 ('is', 3),
 ('as', 3),
 ('API', 3),
 ('on', 3)]

##################################################################
#### EJEMPLO DATAFRAMES
df = spark.read.text("./data/data.txt")

**result_df = df.selectExpr("explode(split(value, ' ')) as word") \
    .groupBy("word").count().orderBy(desc("count"))
result_df.take(10)**

[Row(word='the', count=12),
 Row(word='of', count=7),
 Row(word='a', count=7),
 Row(word='in', count=5),
 Row(word='distributed', count=5),
 Row(word='Spark', count=4),
 Row(word='API', count=3),
 Row(word='RDD', count=3),
 Row(word='is', count=3),
 Row(word='on', count=3)]

spark.stop()
```

Un *DataFrame* es una estructura equivalente a una tabla de base de datos relacional, con un motor bien optimizado para el trabajo en un clúster. Los datos se almacenan en filas y columnas y ofrece un conjunto de operaciones para manipular los datos.

El trabajo con *DataFrames* es más sencillo y eficiente que el procesamiento con RDD, por eso su uso es predominante en los nuevos desarrollos con *Spark*.

## Creando DataFrames

El caso más básico es crear un *DataFrame* a partir de un RDD mediante [`toDF`](https://spark.apache.org/docs/latest/api/python/reference/pyspark.sql/api/pyspark.sql.DataFrame.toDF.html):

```python
from pyspark.sql import SparkSession

spark = SparkSession.builder.getOrCreate() # SparkSession de forma programativa
# Creamos un RDD
datos = [("Aitor", 182), ("Pedro", 178), ("Marina", 161)]
rdd = spark.sparkContext.parallelize(datos)
# Creamos un DataFrame y mostramos su esquema
dfRDD = rdd.toDF()
dfRDD.printSchema()
```

## Dataframe de varios datasets

[https://github.com/coder2j/pyspark-tutorial/blob/main/06-DataFrame-from-various-data-source.ipynb](https://github.com/coder2j/pyspark-tutorial/blob/main/06-DataFrame-from-various-data-source.ipynb)

## Dataframe operations

[https://github.com/coder2j/pyspark-tutorial/blob/main/07-DataFrame-Operations.ipynb](https://github.com/coder2j/pyspark-tutorial/blob/main/07-DataFrame-Operations.ipynb)

## Spark sql

[https://github.com/coder2j/pyspark-tutorial/blob/main/08-Spark-SQL.ipynb](https://github.com/coder2j/pyspark-tutorial/blob/main/08-Spark-SQL.ipynb)