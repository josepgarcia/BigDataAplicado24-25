# UD05 9. Streaming II

[https://aitor-medrano.github.io/iabd/spark/streaming.html](https://aitor-medrano.github.io/iabd/spark/streaming.html)

# Caso 3. Spark Streaming & Kafka

Para este caso, vamos a simular el caso anterior (Caso 2), pero en vez de ficheros, vamos a cargar los datos desde Kafka y seguiremos generando los datos en un sistema de archivos.

Antes de comenzar levantamos un cluster kafka ([UD08 2. Kafka](https://www.notion.so/UD08-2-Kafka-fffe913de6c48156af2bee106cab1f4a?pvs=21))

## Producer

Vamos a utilizar como base la práctica “Bizum” realizada anteriormente ([4. Ejercicio Bizum](<./UD05 8 Streaming fffe913de6c4819a9593edd001b23257.md>)).

En este caso realizaremos un script en python que sea un **producer** que:

- Mande mensajes a un kafka (**topic bizums**).
    - Nombre;Cantidad;Concepto;tipo
        - Nombre: Array de nombres
        - Cantidad: float [5,100]
        - Conceptos: Array conceptos
        - Tipo: [ENVIO|RECEPCIÓN]
    - Array de nombres y array de conceptos generarlo con chatgpt. (unos 100 de cada).
- Cada mensaje lo ha de mandar en un intervalo de 1 a 10 segundos.

**Ejecuta el producer en 2 terminales para que genere el doble de bizums.**

## Consumiendo Kafka

a) Modifica la aplicación “Bizum” para que el spark streaming lea los datos de Kafka y los muestre por consola.

b) Balance de cuenta:

- Los bizums van asociados a una cuenta bancaria, en nuestro caso, la cuenta bancaria tiene un saldo inicial de 2000€.
- Mostrar el balance de la cuenta después de llegar cada uno de los BIZUM.
    - Ejemplo:
    Si tenemos 2000€ y leemos un mensajes tipo:
    **Maria;20;Cena;RECEPCIÓN (Hemos recibido un bizum de María por 20€)**
    Nuestra cuenta tendrá un saldo de 2020€
    **Pepe;100;Viaje;ENVIO (Hemos enviado un bizum a Pepe de 100€)**
    Saldo: 1920€

Ejemplo aplicación:

[https://aitor-medrano.github.io/iabd/spark/streaming.html#caso-3-consumiendo-kafka](https://aitor-medrano.github.io/iabd/spark/streaming.html#caso-3-consumiendo-kafka)