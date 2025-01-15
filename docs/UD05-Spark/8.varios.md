# Varios

## Scala && hive
```bash

#Verifica que HADOOP_HOME y HIVE_HOME estén correctamente configurados:
echo $HADOOP_HOME
echo $HIVE_HOME

## Trabajaremos en esta carpeta
cd $HIVE_HOME/bin 

#Asegúrate de que el directorio de trabajo actual en HDFS sea accesible para Hive, especialmente si estás cargando datos en tablas desde HDFS:
hdfs dfs -mkdir -p /user/hive/warehouse
hdfs dfs -chmod -R 777 /user/hive/warehouse

```

```bash

/usr/local/hive/bin/schematool -dbType derby -initSchema

wget -O /tmp/users.csv https://github.com/josepgarcia/datos/raw/refs/heads/main/ml-100k/u.user

```

Dentro de hive, creamos una tabla para los usuarios:
```txt
1|24|M|technician|85711
2|53|F|other|94043
3|23|M|writer|32067
4|24|M|technician|43537
5|33|F|other|15213
6|42|M|executive|98101
7|57|M|administrator|91344
8|36|M|administrator|05201
9|29|M|student|01002
```

Ejecutamos hive y creamos la BD asociada al archivo:
`Directorio de trabajo: $HIVE_HOME/bin`

```sql
hive> CREATE DATABASE ejemplodb;
hive> USE ejemplodb;
hive> 
CREATE TABLE users (
    id INT,
    age INT,
    sex STRING,
    profession STRING,
    code INT)
    ROW FORMAT DELIMITED
    FIELDS TERMINATED BY '|'
    STORED AS TEXTFILE;


hive> load data local inpath '/tmp/users.csv' into table users;

hive> select * from users;

hive> select * from users where sex like "M";
```

La base de datos se ha creado en HDFS en la carpeta /user/hive/warehouse
![](<./images/Pasted image 20250112173222.png>)

**Configurar Spark para acceder a las tablas de Hive**:
• Copia el archivo hive-site.xml al directorio de configuración de Spark para que Spark pueda conectarse al metastore de Hive:

```bash
cd /usr/local/spark/conf
ln -s /usr/local/hive/conf/hive-site.xml .
```


Iniciamos spark-shell con la compatibilidad de hive:
(con --packages importamos las dependencias automáticamente)
```bash
# Volvemos al directorio de trabajo
cd $HIVE_HOME/bin

# Iniciamos spark-shell
spark-shell --packages org.apache.spark:spark-hive_2.12:3.3.0 
⏳


scala> import org.apache.spark.sql.SparkSession

scala>  val spark = SparkSession.builder().appName("Spark Hive Test").config("spark.sql.catalogImplementation", "hive").enableHiveSupport().getOrCreate()

scala> spark.sql("SHOW DATABASES").show()

scala> spark.sql("USE ejemplodb")

scala> spark.sql("SHOW TABLES").show()

scala> spark.sql("SELECT * FROM users").show()

```

Ejemplo de consultas:
```scala

val professionCount = spark.sql("""
  SELECT profession, COUNT(*) AS total_users
  FROM users
  GROUP BY profession
  ORDER BY total_users DESC
""")
professionCount.show()


val genderCount = spark.sql("""
  SELECT sex, COUNT(*) AS total_users
  FROM users
  GROUP BY sex
""")
genderCount.show()

```


## Pyspark && hive

> [!WARNING] Atención
> Si lanzamos pyspark desde fuera del directorio de trabajo que hemos indicado en el principio ($HIVE_HOME/bin) solo nos encuentra la base de datos default.

```python
pyspark --packages org.apache.spark:spark-hive_2.12:3.3.0

from pyspark.sql import SparkSession

spark = SparkSession.builder \
    .appName("Consulta Hive desde PySpark") \
    .config("spark.sql.catalogImplementation", "hive") \
    .enableHiveSupport() \
    .getOrCreate()

spark.sql("SHOW DATABASES").show()

spark.sql("USE ejemplodb")
spark.sql("SELECT * FROM users").show()

```

## Spark-submit && hive

> [!WARNING] Atención
> Si lanzamos spark-submit desde fuera del directorio de trabajo que hemos indicado en el principio ($HIVE_HOME/bin) solo nos encuentra la base de datos default.


```python
'''consulta_hive.py'''

from pyspark.sql import SparkSession

# Crear una SparkSession con soporte para Hive
spark = SparkSession.builder \
    .appName("Consulta Hive desde Spark Submit") \
    .enableHiveSupport() \
    .getOrCreate()

# Mostrar las bases de datos disponibles
databases = spark.sql("SHOW DATABASES")
databases.show()

# Cambiar a la base de datos deseada y consultar
spark.sql("USE ejemplodb")
users = spark.sql("SELECT * FROM users")
users.show()

# Ejemplo de consulta avanzada: Contar usuarios por profesión
profession_count = spark.sql("""
    SELECT profession, COUNT(*) AS total_users
    FROM users
    GROUP BY profession
    ORDER BY total_users DESC
""")
profession_count.show()

```


```bash
# Submit

spark-submit --master local --packages org.apache.spark:spark-hive_2.12:3.3.0 --conf spark.sql.catalogImplementation=hive consulta_hive.py
```

### Ejercicio
Realiza las configuraciones necesarias para que la base de datos "ejemplodb" sea accesible desde cualquier ubicación (que no sea necesario estar en `$HIVE_HOME/bin`).
Pista: problema de configuración del metastore