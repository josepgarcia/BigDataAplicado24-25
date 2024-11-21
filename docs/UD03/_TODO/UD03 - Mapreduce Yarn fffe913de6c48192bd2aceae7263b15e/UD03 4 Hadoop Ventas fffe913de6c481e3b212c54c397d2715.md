# UD03 4. Hadoop Ventas

# Fase 1

Para comprender mejor cómo funciona un trabajo típico de Hadoop basado en MapReduce, a continuación profundizaremos en la programación y ejecución de un ejemplo utilizando el lenguaje Python.

Hadoop funciona de forma nativa con Java pero cuenta con una herramienta que permite la ejecución de programas/scripts en diferentes lenguajes como python. Esta es la herramienta "Streaming": [https://hadoop.apache.org/docs/stable/hadoop-streaming/HadoopStreaming.html](https://hadoop.apache.org/docs/stable/hadoop-streaming/HadoopStreaming.html)

Este ejemplo trabaja con un conjunto de datos relacionados con las ventas de una empresa con múltiples tiendas: `purchases.txt`

https://drive.google.com/file/d/1m9B0fDUrYWnspWJO1pslIwR_cUcPccZD/view?usp=drive_link

A continuación puede ver un extracto del archivo, que contiene seis campos sobre compras: fecha, hora, ubicación de la tienda, categoría de producto, compra total y método de pago.

```
2012-01-01	09:00	San Jose	Men's Clothing	214.05	Amex
2012-01-01	09:00	Fort Worth	Women's Clothing	153.57	Visa
2012-01-01	09:00	San Diego	Music	66.08	Cash
2012-01-01	09:00	Pittsburgh	Pet Supplies	493.51	Discover
2012-01-01	09:00	Omaha	Children's Clothing	235.63	MasterCard
2012-01-01	09:00	Stockton	Men's Clothing	247.18	MasterCard
2012-01-01	09:00	Austin	Cameras	379.6	Visa
2012-01-01	09:00	New York	Consumer Electronics	296.8	Cash
2012-01-01	09:00	Corpus Christi	Toys	25.38	Discover
2012-01-01	09:00	Fort Worth	Toys	213.88	Visa
```

El programa resultante se puede ejecutar, dependiendo de tu sistema de las siguientes formas:

```bash
1) python3 mapper.py
2) ./mapper.py #(hay que darle permisos)
```

## **Ejemplo 1**

Es interesante conocer el importe total de ventas de cada tienda.

El paradigma MapReduce se compone de dos funciones: mapper() y reducer()

mapper

El mapper estará a cargo de construir el par clave:valor de cada línea. Piensa que cada nodo del cluster ejecutará el mapper en las líneas del archivo que le corresponden. En cualquier caso, es un trabajo que se ejecuta por líneas, lo que permite una fácil paralelización.

```
**Por ejemplo:**
San José    214,05
Fort Worth    153,57
...
Fort Worth    213,88
```

reducer

El reducer se encargará de sumar los valores correspondientes a unas mismas claves.

```
**Por ejemplo:**
San José    214.05
Fort Worth    367,45       # (135,57+213,88)
```

Entre el mapper y el reducer se ejecutan las tareas shuffle y sort, que agrupan los pares clave:valor según las claves, permitiendo la posterior operación de reducción.

Cuando ejecutemos los programas desde la consola, utilizaremos el comando “**sort**” para sustituir a shuffle y sort.

![Untitled](<./UD03 4 Hadoop Ventas fffe913de6c481e3b212c54c397d2715/Untitled.png>)

Crea el código necesario para construir el mapper y el reducer

- **Sol**
    
    ```
    https://github.com/bigdatawirtz/bigdata-aplicado-2022/blob/main/mapreduce/mapper.py
    
    **mapper.py**
    #!/usr/bin/python3
    
    # Format of each line is:
    # date\ttime\tstore name\titem description\tcost\tmethod of payment
    #
    # We want elements 2 (store name) and 4 (cost)
    # We need to write them out to standard output, separated by a tab
    
    import sys
    
    for line in sys.stdin:
        data = line.strip().split("\t")
        date, time, store, item, cost, payment = data
        print(store+"\t"+cost)
    
    **reducer.py**
    #!/usr/bin/python3
    
    import sys
    
    salesTotal = 0
    oldKey = None
    
    # Loop around the data
    # It will be in the format key\tval
    # Where key is the store name, val is the sale amount
    #
    # All the sales for a particular store will be presented,
    # then the key will change and we'll be dealing with the next store
    
    for line in sys.stdin:
        data_mapped = line.strip().split("\t")
        if len(data_mapped) != 2:
            # Something has gone wrong. Skip this line.
            continue
    
        thisKey, thisSale = data_mapped
    
        # Escribe un par key:value ante un cambio na key
        # Reinicia o total
        if oldKey and oldKey != thisKey:
            print(oldKey+"\t"+str(salesTotal))
            oldKey = thisKey;
            salesTotal = 0
    
        oldKey = thisKey
        salesTotal += float(thisSale)
    
    # Escribe o ultimo par, unha vez rematado o bucle
    if oldKey != None:
        print(oldKey+"\t"+str(salesTotal))
    ```
    

### Primera aproximación

Crea los programas mapper y reducer necesarios.

**PASO1: mapper**

Mapper leerá de un fichero de texto que contendrá 50 o 100 líneas del fichero original (así serán más rápidas las pruebas).

Lo ejecutaremos de la siguiente manera:

```bash
python mapper.py
```

Y producirá una salida tipo (campos separados por tabulador):

```
San José    214,05
Fort Worth    153,57
...
Fort Worth    213,88
```

Una vez produzca la salida deseada utilizaremos el operador de redirección “>” para guardar la salida en un archivo de texto:

```bash
python mapper.py > salida_mapper.csv
```

- [ ]  Asegúrate que la temperatura sea un *float*.

---

**PASO2: shuffle y sort**

Sustituiremos esta fase por el comando sort, por lo que simplemente haremos un:

```bash
cat salida_mapper.csv | sort > salida_sort.csv
```

---

**PASO3: reducer**

Leerá del fichero salida_sort.csv y procesará los datos.

Hay que tener en cuenta que al llegar a esta fase ya tenemos los datos ordenados, por lo que será más sencillo sumar los diferentes registros:

```
**Ejemplo de fichero**

...
Fort Worth    10
Fort Worth    20
Fort Worth    15
....
San José    133
San José    7
....
```

Esta segunda ejecución devolverá el sumatorio de los importes de cada ciudad (campos separados por tabulador):

```
**Por ejemplo:
...**
Fort Worth    45
...
****San José    140
...

```

### Segunda aproximación

Uso de tuberías

El programa debe ejecutarse a través de tuberías, no de ficheros:

```bash
cat purchases.txt | python mapper.py | sort | python reducer.py > salida.txt
```

Por lo que has de modificar el código, para que en vez de leer de un fichero, lea del stream de entrada (sys.stdin).

# Fase 2

Una vez verificado el código (funciona a través de tuberías) vamos a mandarlo a una ejecución distribuida con hadoop.

1. Sube los ficheros a la máquina donde tengas instalado hadoop (mapper, reducer y purchases.txt)
2. Crea en HDFS una carpeta llamada purchases
3. Sube allí el fichero purchases.txt
4. Los ficheros .py están en tu máquina virtual y el fichero purchases.txt está en HDFS, así hadoop ya puede dividirlo y crear los diferentes jobs que considere.
5. Vamos a utilizar mapreduce pero a través de nuestro mapper y reducer.
Para poder ejecutar nuestros scripts para crear procesos “mapreduce” utilizamos “**hadoop streaming**”
[https://hadoop.apache.org/docs/stable/hadoop-streaming/HadoopStreaming.html](https://hadoop.apache.org/docs/stable/hadoop-streaming/HadoopStreaming.html)

Lanzamos el siguiente comando:

```bash
mapred streaming -files mapper.py,reducer.py 
		-input /PURCHASES/purchases.txt -output COMPRASXTIENDA 
		-mapper "python3 mapper.py" -reducer "python3 reducer.py"

------------------------------------------------------------------
## Sintaxis del comando:
mapred streaming 
    -files mapper.py,reducer.py
    -input myInputDirs \
    -output myOutputDir \
    -mapper script_mapper
    -reducer script_reducer
```

- ℹ Otra forma de ejecutar el código:
    
    ```bash
    $ mapred streaming -files mapper2.py,reducer.py -input /quijote.txt 
    -output /quijote_salida1 -mapper ./mapper2.py -reducer ./reducer.py
    
    **$ hadoop jar /opt/hadoop/share/hadoop/tools/lib/hadoop-streaming-3.3.6.jar -file mapper2.py 
    -mapper mapper2.py -file reducer.py -reducer reducer.py -input /quijote.txt 
    -output /quijote_salida2**
    ```
    

1. ¿Dónde se encuentra el resultado?

## Ejercicios

Como puedes ver en el código, no es un algoritmo complejo y también se puede ejecutar desde la consola ejecutando los scripts manualmente.

La ventaja que ofrece Hadoop es que se pueden utilizar los mismos algoritmos en archivos mucho más grandes, distribuidos en un sistema de archivos distribuido, y se pueden utilizar varias computadoras para procesar los datos.

### Ejercicio 1.1. Mejora el código.

La función del mapper se ejecutará en todas y cada una de las líneas del archivo de datos. El código del mapper producirá un error si encuentra alguna línea que no coincida con el número exacto de valores separados por tabulaciones.

- [ ]  Mejora el código para que cualquier línea con un formato inadecuado sea descartada y continúe trabajando con la siguiente línea.
- [ ]  Asegúrate que el valor numérico sea un float
- **Sol**
    
    ```bash
    for line in sys.stdin:
        data = line.strip().split("\t")
        **if len(data) == 6:**
            date, time, store, item, cost, payment = data
            print(f'{store}\t{cost}')
    ```
    

### Ejercicio 1.2

Redefine el mapper para que mapreduce devuelva como salida las ventas totales por categoría.

```
**Ejemplo de resultado (datos no reales):**

Pet Supplies   1123.4  
Music          22344.56
Clothing       3356.45
```

- **Sol**
    
    ```bash
    for line in sys.stdin:
        data = line.strip().split("\t")
        if len(data) == 6:
            date, time, store, item, cost, payment = data
            **print(f'{item}\t{cost}')**
    ```
    

### Ejercicio 1.3

Redefine el mapper y reducer para que se obtenga la venta más alta para cada tipo de pago de las registradas en todo el archivo.

** No hay que devolver las ventas totales por tipo de pago **

```
**Ejemplo de resultado (datos no reales):**

Visa           133.5   -> la venta más alta de todas las hechas con visa
Cash           223.56  -> la venta más alta de todas las hechas con cash
Mastercard     1356.45 -> la venta más alta de todas las hechas con Mastercard
```

- **Sol**
    
    ```bash
    # El mapper devuelve el par paymet:cost
    for line in sys.stdin:
        data = line.strip().split("\t")
        if len(data) == 6:
    ****        date, time, store, item, cost, payment = data
            **print(f'{payment}\t{cost}')**
    
    # El reducer no hace la suma, si no que va comparando si
    # la venta fué mayor que la anterior
    oldKey = thisKey
        **if thisSale >= salesMax:
            salesMax = float(thisSale)**
    ```
    

### Ejercicio 1.4

Realiza las modificaciones necesarias para que el proceso mapreduce nos devuelva la venta más alta de todas las realizadas.

- **Sol**
    
    ```bash
    # Una posible solución sería modificar solo el asignador 
    #y crear una única categoría "todos" en lugar de utilizar 
    #los diferentes valores para el pago. De esta forma, 
    #el reductor pensará que todas las ventas son con el mismo 
    #tipo de pago, es decir, no se preocupará por qué tipo 
    #de pago se utilizó.
    for line in sys.stdin:
        data = line.strip().split("\t")
        if len(data) == 6:
            date, time, store, item, cost, payment = data
            **print(f'all\t{cost}')**
    ```
    

### Ejercicio 1.5

Redefine los scripts par que se obtengan las ventas totales.

- **Sol**
    
    ```bash
    #Como en el caso anterior, podemos utilizar una única 
    # categoría para todos "todos" en el mapeador.
    for line in sys.stdin:
        data = line.strip().split("\t")
        if len(data) == 6:
            date, time, store, item, cost, payment = data
            **print(f'all\t{cost}')**
    ```