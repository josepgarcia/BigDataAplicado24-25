# UD05 5. RDDs II.

# Transformations II

**Otras funciones para transformaciones en RDD**

Iniciamos sesión con Spark

```python
from pyspark.sql import SparkSession
spark = SparkSession.builder.appName("RDD II").getOrCreate()
```

Al estar trabajando con RDD lo hacemos a través de un contexto, podemos hacerlo de 2 formas:

1. **Acceso contexto a través del método**

```python
datos = [1,2,3,4]
rdd = spark.sparkContext.parallelize(datos)
rdd.collect()
```

1. **Acceso contexto a través de variable sc**

```python
datos = [1,2,3,4]
sc = spark.sparkContext
rdd = sc.parallelize(datos)
rdd.collect()
```

## Distinct

Elimina los elementos repetidos

```python
rdd = sc.parallelize([1,1,2,3,4,3,2])
rdd.distinct().collect()
```

```
[1, 2, 3, 4]
```

## Conjuntos de datos

### Union

Unimos dos RDD en uno ### Insersection Obtenemos los elementos en
común ### Subtract Elementos rel primer RDD que no estén en el
segundo

```python
rdd1 = sc.parallelize([1,2,3,4])
rdd2 = sc.parallelize([4,5,6,7])
print("Union: ", rdd1.union(rdd2).collect())
print("Intersection: ", rdd1.intersection(rdd2).collect())
print("Substract: ", rdd1.subtract(rdd2).collect())
```

```
Union:  [1, 2, 3, 4, 4, 5, 6, 7]
Intersection:  [4]
Substract:  [1, 2, 3]
```

---

**Ejercicio**

Tenemos dos RDD

rddA = sc.parallelize([1,2,3,4])

rddB = sc.parallelize([3,4,5,6])

¿Cómo conseguiremos los elementos que están en A y no en B y los de B que no están en A? Resultado: [1,2,5,6]

```python
# %load soluciones/RDD-solucion.txt
```

## RDD de pares

Es muy común trabajar con elementos que tienen un formato de (clave,
valor) de cualquier tipo

```python
listaTuplas = [(1,'a'),(2,'b'),(3,'c'),(4,'d')]
rddTuplas= sc.parallelize(listaTuplas)
rddTuplas.collect()
```

```
[(1, 'a'), (2, 'b'), (3, 'c'), (4, 'd')]
```

Podemos generar un RDD de pares de las siguientes maneras:

### zip

Une dos RDD del mismo tamaño

```python
lista1 = ['a','b','c','d']
lista2 = [1,2,3,4]
sc.parallelize(lista1).zip(sc.parallelize(lista2)).collect()
```

```
[('a', 1), ('b', 2), ('c', 3), ('d', 4)]
```

*Métodos relacionadas: zipWithIndex y zipWithUniqueId*

### map

Asignando a cada elemento un valor entero o cálculo sobre el
mismo

```python
lista = ['hola', 'adios', 'hasta mañana']
rddMap = sc.parallelize(lista).map(lambda x: (x, len(x)))
rddMap.collect()
```

```
[('hola', 4), ('adios', 5), ('hasta mañana', 12)]
```

### keyBy

Crea las claves a partir de cada elemento

```python
rddkeyby = sc.parallelize(lista).keyBy(lambda x: x[0])
rddkeyby.collect()
```

```
[('h', 'hola'), ('a', 'adios'), ('h', 'hasta mañana')]
```

### Transformaciones sobre RDD
de pares

**keys**: devuelve las claves

**values**: devuelve los valores

**mapValues**: aplica una función sobre los valores

**flatMapValues**: aplica una función sobre los valores y los aplana

```python
listaTuplas = [('a',1),('b',2),('c',3),('d',4)]
rddTuplas = sc.parallelize(listaTuplas)
claves = rddTuplas.keys()
valores = rddTuplas.values()
print("Claves: ",claves.collect())
print("Valores: ",valores.collect())
```

```
Claves:  ['a', 'b', 'c', 'd']
Valores:  [1, 2, 3, 4]
```

```python
rddMapValues = rddTuplas.mapValues( lambda x: (x, x*2))
rddMapValues.collect()
```

```
[('a', (1, 2)), ('b', (2, 4)), ('c', (3, 6)), ('d', (4, 8))]
```

```python
rddFMV = rddTuplas.flatMapValues(lambda x: (x, x*2))
rddFMV.collect()
```

```
[('a', 1),
 ('a', 2),
 ('b', 2),
 ('b', 4),
 ('c', 3),
 ('c', 6),
 ('d', 4),
 ('d', 8)]
```

---

**Ejercicio**

A partir de la lista “Perro Gato Loreo Pez León Tortuga Gallina”

1. Crea un RDD
2. Convierte el RD normal en un RDD de pares cuya clave sea la primera letra del animal
3. Crea otro RDD de pares pero poniendo como clave un número incremental
4. Igual que el anterior pero el índice incremental ha de empezar por 100

```python
# %load soluciones/RDD-solucion2.txt
```

## reduceByKey

(Visto en el punto anterior)

---

**Ejercicio 3**

Utilizando el fichero de ventas pdi_sales.csv (versión extendida) / pdi_sales.csv (versión reducida)

El cuál tiene el siguiente formato:

```bash
%%bashhead -n5 DATOS/pdi_sales_small.csv
```

```
ProductID;Date;Zip;Units;Revenue;Country
725;1/15/1999;41540          ;1;115.5;Germany
787;6/6/2002;41540          ;1;314.9;Germany
788;6/6/2002;41540          ;1;314.9;Germany
940;1/15/1999;22587          ;1;687.7;Germany
```

1. ¿Cuántas ventas se han realizado en cada país?

```python
# %load soluciones/RDD-solucion3_1.txt
```

1. Total de unidades vendidas por país, cogeremos el país (country) y las unidades vendidas (units)

```python
# %load soluciones/RDD-solucion3_2.txt
```

---

**Ejercicio 4**

Dada la siguiente lista de compra, calcula:

1. El total que se ha gastado por cada producto.
2. Cuánto es lo máximo que se ha pagado por cada producto.

lista = [(‘pan’,3), (‘agua’,2), (‘azúcar’,1), (‘leche’,2), (‘pan’,1),
(‘cereales’,3), (‘agua’,0.5), (‘leche’,2), (‘filetes’,5)]

```python
# %load soluciones/RDD-solucion4.txt
```

## groupByKey

Permite agrupar datos a partir de una clave, repartiendo los resultados (shuffle) entre todos los nodos.

```python
rdd = sc.textFile("DATOS/pdi_sales_small.csv")
# Creamos un RDD de pares con el nombre del país como clave, y una lista con los valorespaisesUnidades = rdd.map(lambda x: (x.split(";")[-1].strip(), x.split(";")))
# Quitamos el primer elemento que es el encabezado del CSVheader = paisesUnidades.first()
paisesUnidadesSinHeader = paisesUnidades.filter(lambda linea: linea != header)
# Agrupamos las ventas por nombre del paíspaisesAgrupados = ventas.groupByKey()
paisesAgrupados.collect()
# Obtendremos para cada país, un iterable con todos sus datos:
```

```
[('Country', <pyspark.resultiterable.ResultIterable at 0xffff36129d10>),
 ('Germany', <pyspark.resultiterable.ResultIterable at 0xffff348c1d50>),
 ('Mexico', <pyspark.resultiterable.ResultIterable at 0xffff2db6fb90>),
 ('France', <pyspark.resultiterable.ResultIterable at 0xffff36280590>),
 ('Canada', <pyspark.resultiterable.ResultIterable at 0xffff2bf124d0>)]
```

Podemos transformar los iterables a una lista

```python
paisesAgrupadosLista = paisesAgrupados.map(lambda x: (x[0], list(x[1])))
# paisesAgrupadosLista.collect()
```

---

**Ejercicio 5**

Tenemos las cuentas de las compras de 3 días:

- día 1: pan 3€, agua 2€, azúcar 1€, leche 2€, pan 4€
- día 2: pan 1€, cereales 3€, agua 0.5€, leche 2€, filetes 5€
- día 3: filetes 2€, cereales 1€

Dada la siguiente lista de compra:

```bash
dia1 = [(‘pan’,3), (‘agua’,2), (‘azúcar’,1), (‘leche’,2), (‘pan’,4)]
dia2 = [(‘pan’,1), (‘cereales’,3), (‘agua’,0.5), (‘leche’,2), (‘filetes’,5)]
dia3 = [(‘filetes’,2), (‘cereales’,1)]
```

1. ¿Cómo obtenemos lo que hemos gastado en cada producto?
2. ¿Y el gasto medio que hemos realizado en cada uno de ellos?

```python
# %load soluciones/RDD-solucion5.txt
```

## sortByKey

Permite ordenar los datos a partir de una clave. Los pares de la misma máquina se ordenan primero por la misma clave, y luego los datos de las diferentes particiones se barajan.

Para ello crearemos una tupla, siendo el primer elemento un valor numérico por el cual ordenar, y el segundo el dato asociado.

Vamos a partir del ejemplo anterior para ordenar los paises por la cantidad de ventas:

```python
# Ejemplo anteriorrdd = sc.textFile("DATOS/pdi_sales.csv")
paisesUnidades = rdd.map(lambda x: (x.split(";")[-1].strip(), x.split(";")[3]))
header = paisesUnidades.first()
paisesUnidadesSinHeader = paisesUnidades.filter(lambda linea: linea != header)
paisesTotalUnidades = paisesUnidadesSinHeader.reduceByKey(lambda a,b: int(a)+int(b))
# Le damos la vuelta a la listaunidadesPaises = paisesTotalUnidades.map(lambda x: (x[1],x[0]))
unidadesPaises.collect()
```

```
[(244265, 'Germany'),
 (223463, 'Mexico'),
 (327730, 'France'),
 (77609, 'Canada')]
```

```python
# Y a continuación los ordenamosunidadesPaisesOrdenadas = unidadesPaises.sortByKey()
unidadesPaisesOrdenadas.collect()
```

```
[(77609, 'Canada'),
 (223463, 'Mexico'),
 (244265, 'Germany'),
 (327730, 'France')]
```

```python
# Orden descendenteunidadesPaisesOrdenadasDesc = unidadesPaises.sortByKey(False)
unidadesPaisesOrdenadasDesc.collect()
```

```
[(327730, 'France'),
 (244265, 'Germany'),
 (223463, 'Mexico'),
 (77609, 'Canada')]
```

## Particiones

Spark organiza los datos en particiones, considerándolas divisiones lógicas de los datos entre los nodos del clúster. Por ejemplo, si el almacenamiento se realiza en HDFS, cada partición se asigna a un bloque.

Cada una de las particiones va a llevar asociada una tarea de ejecución, de manera que a más particiones, mayor paralelización del proceso.

Veamos con código como podemos trabajar con las particiones:

```python
rdd = sc.parallelize([1,1,2,2,3,3,4,5])
rdd.getNumPartitions() # 4rdd = sc.parallelize([1,1,2,2,3,3,4,5], 2)
rdd.getNumPartitions() # 2rddE = sc.textFile("empleados.txt")
rddE.getNumPartitions() # 2rddE = sc.textFile("empleados.txt", 3)
rddE.getNumPartitions() # 3
```

```
3
```

La mayoría de operaciones / transformaciones / acciones que trabajan con los datos admiten un parámetro extra indicando la cantidad de particiones con las que queremos trabajar.

### MapPartitions

A diferencia de la transformación map que se invoca por cada elemento del RDD/DataSet, mapPartitions se llama por cada partición.

La función que recibe como parámetro recogerá como entrada un iterador con los elementos de cada partición:

```python
rdd = sc.parallelize([1,1,2,2,3,3,4,5], 2)
def f(iterator): yield sum(iterator)
resultadoRdd = rdd.mapPartitions(f)
resultadoRdd.collect()  # [6, 15]resultadoRdd2 = rdd.mapPartitions(lambda iterator: [list(iterator)])
resultadoRdd2.collect() # [[1, 1, 2, 2], [3, 3, 4, 5]]
```

```
[[1, 1, 2, 2], [3, 3, 4, 5]]
```

En el ejemplo, ha dividido los datos en dos particiones, la primera con [1, 1, 2, 2] y la otra con [3, 3, 4, 5], y de ahí el resultado de sumar sus elementos es [6, 15].

### mapPartitionsWithIndex¶

De forma similar al caso anterior, pero ahora mapPartitionsWithIndex recibe una función cuyos parámetros son el índice de la partición y el iterador con los datos de la misma:

```python
def mpwi(indice, iterador):
    return [(indice, list(iterador))]
resultadoRdd = rdd.mapPartitionsWithIndex(mpwi)
resultadoRdd.collect()
# [(0, [1, 1, 2, 2]), (1, [3, 3, 4, 5])]
```

```
[(0, [1, 1, 2, 2]), (1, [3, 3, 4, 5])]
```

### Modificando las particiones

Podemos modificar la cantidad de particiones mediante dos transformaciones wide: coalesce y repartition.

Mediante coalesce podemos obtener un nuevo RDD con la cantidad de particiones a reducir:

```python
rdd = sc.parallelize([1,1,2,2,3,3,4,5], 3)
rdd.getNumPartitions() # 3rdd1p = rdd.coalesce(1)
rdd1p.getNumPartitions() # 2
```

```
1
```

En cambio, mediante repartition podemos obtener un nuevo RDD con la cantidad exacta de particiones deseadas (al reducir las particiones, repartition realiza un shuffle para redistribuir los datos, por lo tanto, si queremos reducir la cantidad de particiones, es más eficiente utilizar coalesce):

```python
rdd = sc.parallelize([1,1,2,2,3,3,4,5], 3)
rdd.getNumPartitions() # 3rdd2p = rdd.repartition(2)
rdd2p.getNumPartitions() # 2
```

```
2
```

# Actividades

## Actividad 1

A partir de la lista siguiente
[‘Alicante’,‘Elche’,‘Valencia’,‘Madrid’,‘Barcelona’,‘Bilbao’,‘Sevilla’]:

1. Almacena sólo las ciudades que tengan la letra e en su nombre y muéstralas.

En Python, para saber si una cadena contiene una letra puedes usar el operador in:

```python
nombre = "Josep Garcia"print("i" in nombre) # Falseprint("o" in nombre) # Trueprint("Gar" in nombre) # Trueprint("jo" in nombre) # False (case sensitive)
```

```
True
True
True
False
```

1. Muestra las ciudades que tienen la letra e y el número de veces que aparece en cada nombre. Por ejemplo (‘Elche’, 2).
2. Averigua las ciudades que solo tengan una única e.
3. Nos han enviado una nueva lista pero no han separado bien las ciudades. Reorganiza la lista y colócalas correctamente, y cuenta las apariciones de la letra e de cada ciudad. ciudades_mal = [[‘Alicante.Elche’,‘Valencia’,‘Madrid.Barcelona’,‘Bilbao.Sevilla’],[‘Murcia’,‘San Sebastián’,‘Melilla.Aspe’]]

## Actividad 2

Dada una lista de elementos desordenados y algunos repetidos, devolver una muestra de 5 elementos, que estén en la lista, sin repetir y ordenados descendentemente.

lista = 4,6,34,7,9,2,3,4,4,21,4,6,8,9,7,8,5,4,3,22,34,56,98

1. Selecciona el elemento mayor de la lista resultante.
2. Muestra los dos elementos menores.

## Actividad 3

A partir de las siguientes listas:

Inglés: hello, table, angel, cat, dog, animal, chocolate, dark, doctor, hospital, computer.

Español: hola, mesa, angel, gato, perro, animal, chocolate, oscuro, doctor, hospital, ordenador

Una vez creado un RDD con tuplas de palabras y su traducción (puedes usar zip para unir dos listas):

```
[('hello', 'hola'),
 ('table', 'mesa'),
 ('angel', 'angel'),
 ('cat', 'gato')...
```

Averigua:

1. Palabras que se escriben igual en inglés y en español.
2. Palabras que en español son distintas que en inglés.
3. Obtén una única lista con las palabras en ambos idiomas que son distintas entre ellas ([‘hello’, ‘hola’, ‘table’, …).
4. Haz dos grupos con todas las palabras, uno con las que empiezan por vocal y otro con las que empiecen por consonante.

## Actividad 4

A partir del fichero de El Quijote (en Datos)

1. Crear un RDD a partir del fichero y crea una lista con todas las palabras del documento.
2. ¿Cuantas veces aparece la palabra Dulcinea (independientemente de si está en mayúsculas o minúsculas)? ¿Y Rocinante? (86 y 120 ocurrencias respectivamente)
3. Devuelve una lista ordenada según el número de veces que sale cada palabra de más a menos (las primeras ocurrencias deben ser [(‘que’, 10731), (‘de’, 9035), (‘y’, 8668), (‘la’, 5014), …).
4. Almacena el resultado (saveAsTextFile)

## Actividad 5

Dada una cadena que contiene una lista de nombres Juan, Jimena, Luis, Cristian, Laura, Lorena, Cristina, Jacobo, Jorge, una vez transformada la cadena en una lista y luego en un RDD:

1. Agrúpalos según su inicial, de manera que tengamos tuplas formadas por la letra inicial y todos los nombres que comienzan por dicha letra:

```python
[('J', ['Juan', 'Jimena', 'Jacobo', 'Jorge']),
('L', ['Luis', 'Laura', 'Lorena']),
('C', ['Cristian', 'Cristina'])]
```

1. De la lista original, obtén una muestra de 5 elementos sin repetir valores.
2. Devuelve una muestra de datos de aproximadamente la mitad de registros que la lista original con datos que pudieran llegar a repetirse.

## Actividad 6

En una red social sobre cine, tenemos un fichero ratings.txt compuesta por el código de la película, el código del usuario, la calificación asignada y el timestamp de la votación con el siguiente formato:

```
1::1193::5::978300760
1::661::3::978302109
1::914::3::978301968
```

1. Obtener para cada película, la nota media de todas sus votaciones.
2. Películas cuya nota media sea superior a 3.

# Proyecto

Tenemos las calificaciones de las asignaturas de matemáticas, inglés y física de los alumnos del instituto en 3 documentos de texto. A partir de estos ficheros:

```bash
%%bash
ls DATOS/notas_*
```

```
DATOS/notas_fisica.txt
DATOS/notas_ingles.txt
DATOS/notas_mates.txt
```

1. Crea 3 RDD de pares, uno para cada asignatura, con los alumnos y sus notas
2. Crea un solo RDD con todas las notas
3. ¿Cuál es la nota más baja que ha tenido cada alumno?
4. ¿Cuál es la nota media de cada alumno?
5. ¿Cuantos estudiantes suspende cada asignatura? [(‘Mates’, 7), (‘Física’, 8), (‘Inglés’, 7)]
6. ¿En qué asignatura suspende más gente?
7. Total de notables o sobresalientes por alumno, es decir, cantidad de notas superiores o igual a 7.
8. ¿Qué alumno no se ha presentado a inglés?
9. ¿A cuántas asignaturas se ha presentado cada alumno?
10. Obtén un RDD con cada alumno con sus notas