# UD08 1a. Faker

# 1. Librería faker

## 1.1. Instalación

Si necesitamos generar muchos datos, es muy útil emplear una librería como [Faker](https://faker.readthedocs.io/en/master/) para generar datos sintéticos.

Primero hemos de instalarla mediante pip:

```bash
pip3 install faker
```

## 1.2. Ejemplo

```python
'''hola.py'''
from faker import Faker

fake = Faker()
fake = Faker('es_ES')   # cambiamos el locale a español

print("Nombre:", fake.name())
print("Dirección:", fake.address())
print("Nombre de hombre:", fake.first_name_male())
print("Número de teléfono:", fake.phone_number())
print("Color:", fake.color_name())
print("Fecha:", fake.date())
print("Email:", fake.email())
print("Frase de 10 palabras", fake.sentence(nb_words=10))
```

```python
$ python3 hola.py

Nombre: Yaiza Rico-Carbonell
Dirección: Cañada de Maximiliano Galán 4
Segovia, 08077
Nombre de hombre: Nando
Número de teléfono: +34 888 44 88 30
Color: Amarillo dorado claro
Fecha: 1989-02-18
Email: pinolcalixto@example.com
Frase de 10 palabras Labore nesciunt placeat nam soluta atque dolores dolor provident qui.
```

[https://faker.readthedocs.io/en/master/providers.html](https://faker.readthedocs.io/en/master/providers.html)

Los diferentes grupos de datos que genera se agrupan en *Providers*: de dirección, fechas, relacionados con internet, bancarios, códigos de barra, isbn, etc...

Al trabajar con el idioma en español, puede que algunos métodos no funcionen (más que no funcionar, posiblemente tengan otro nombre). Es recomendable comprobar las opciones disponibles en [https://faker.readthedocs.io/en/master/locales/es_ES.html](https://faker.readthedocs.io/en/master/locales/es_ES.html)

# 2. Otros lenguajes

[Getting Started | Faker](https://fakerjs.dev/guide/)

[npm: @faker-js/faker](https://www.npmjs.com/package/@faker-js/faker)

[FakerPHP / Faker](https://fakerphp.github.io/)

# 3. Ejercicios

<aside>
✅ **ENTREGAR AULES**

</aside>

1. Modifica el ejemplo anterior para generar un CSV con 100 personas.
2. Modifica el ejemplo anterior para generar un JSON con 100 personas.
3. Genera un JSON con los siguientes datos:

Nombre | Apellido1 | Apellido2 | NIF | Número de cuenta (iban) | nombre empresa | país empresa | ciudad empresa