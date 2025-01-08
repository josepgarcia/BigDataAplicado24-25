# UD05 7. Formatos de datos

# Formatos

## CSV

Comma Separated Values (valores separados por comas). Requiere que cada elemento de nuestro conjunto se presente en una línea. Dentro de esa línea, cada uno de los atributos del elemento debe estar separado por un único separador, que habitualmente es una coma, y seguir siempre el mismo orden. Además, la primera línea del fichero, a la que llamaremos cabecera, no contiene datos de ningún elemento, sino información de los atributos. Si el campo contiene alguna coma, utilizaremos un delimitador como por ejemplo " ".

## XML

Extensive Markup Languaje (lenguaje de marcas extensible). Es un lenguaje de etiquetas utilizado para almacenar datos de forma estructurada.

## JSON

JavaScript Object Notation, es un formato muy utilizado hoy en día, tiene el mismo propósito que el XML que es el intercambio de datos pero no utiliza las etiquetas abiertas y cerradas, sino que pretende que pese menos, es decir que ocupe menos espacio.

## AVRO

Es un formato de almacenamiento basado en filas para Hadoop. Avro se basa en **esquemas**. Cuando los datos .avro son leídos siempre está presente el esquema con el que han sido escritos. Avro utiliza JSON para definir tipos de datos y protocolos. Es el formato utilizado para la serialización de datos ya que es más rápido y ocupa menos espacio que los JSON, la serialización de los datos la hace en un formato binario compacto.

## **Parquet**

Es un formato de almacenamiento basado en columnas para Hadoop. Fue creado para poder disponer de un formato de compresión y codificación eficiente. El formato Parquet está compuesto por tres piezas:

- Row group: es un conjunto de filas en formato columnar.
- Column chunk: son los datos de una columna en grupo. Se puede leer de manera independiente para mejorar las lecturas.
- Page: es donde finalmente se almacenan los datos, debe ser lo suficientemente grade para que la compresión sea eficiente.

- Apache Parquet está orientado a columnas y diseñado para brindar un almacenamiento en columnas eficiente en comparación con los tipos de ficheros basados en filas, como CSV.
- Los archivos Parquet se diseñaron teniendo en cuenta estructuras de datos anidadas complejas.
- Apache Parquet está diseñado para admitir esquemas de compresión y codificación muy eficientes.
- Apache Parquet genera menores costes de almacenamiento para archivos de datos y maximiza la efectividad de las consultas de datos

![Untitled](<./UD05 7 Formatos de datos fffe913de6c4819d941fc4613769fd0a/Untitled.png>)

## ORC

[Apache ORC](https://orc.apache.org/) es un formato de datos columnar (***O**ptimized* ***R**ow* ***C**olumnar*) similar a *Parquet* pero optimizado para la lectura, escritura y procesamiento de datos en *Hive*. *ORC* tiene una tasa de compresión alta (utiliza *zlib*), y al basarse en *Hive*, soporta sus tipos de datos simples (*datetime*, *decimal*, etc...) y los tipos complejos (como *struct*, *list*, *map* y *union*), siendo totalmente compatible con *HiveQL*.

Los fichero *ORC* se componen de tiras de datos (*stripes*), donde cada tira contiene un índice, los datos de la fila y un pie (con estadísticas como la cantidad, máximos y mínimos y la suma de cada columna convenientemente cacheadas)

![Untitled](<./UD05 7 Formatos de datos fffe913de6c4819d941fc4613769fd0a/Untitled 1.png>)

# Ampliación

[https://aitor-medrano.github.io/iabd/de/formatos.html](https://aitor-medrano.github.io/iabd/de/formatos.html)

---

# Práctica a realizar

<aside>
✅ Entregar en AULES

</aside>

Actividad 1:

[https://aitor-medrano.github.io/iabd/de/formatos.html#actividades](https://aitor-medrano.github.io/iabd/de/formatos.html#actividades)

![Untitled](<./UD05 7 Formatos de datos fffe913de6c4819d941fc4613769fd0a/Untitled 2.png>)

![Untitled](<./UD05 7 Formatos de datos fffe913de6c4819d941fc4613769fd0a/Untitled 3.png>)