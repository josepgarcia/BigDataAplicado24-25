# UD05 X. Python venv

# 1. Entornos virtuales

Un entorno virtual en Python consiste en abstraer y aislar configuraciones de Python y sus librerías, usándolas sólamente para un determinado proyecto; y así no lo mezclamos con nuestra configuración de Python de nuestra máquina host. Por ejemplo yo tengo estas librerías de Python configuradas de forma global:

![Untitled](<./UD05 X Python venv fffe913de6c481a19c2ee94a768efa37/Untitled.png>)

Ahora voy a **crear un entorno virtual** con la librería virtualenv donde estén las librerías virtualizas que utilizamos para un determinado proyecto, para ello necesitamos instalar el paquete “virtualenv”.

- Virtualenv vs venv
    
    [venv](https://docs.python.org/3/library/venv.html) es un paquete que viene con Python 3. Python 2 no contiene venv.
    
    [virtualenv](https://virtualenv.pypa.io/en/stable/) es una biblioteca que ofrece más funcionalidades que venv. Mira el siguiente enlace para obtener una lista de características que venv no ofrece en comparación con virtualenv.
    
    - [https://virtualenv.pypa.io/en/stable/](https://virtualenv.pypa.io/en/stable/)
    
    Aunque puedes crear un entorno virtual usando venv con Python3, se recomienda que instales y use virtualenv en su lugar.
    
- Diferentes entornos virtuales
    1. venv: Este es un módulo integrado en Python 3.3 y versiones posteriores que te permite crear entornos virtuales en Python. Crea un nuevo entorno de Python con sus propios directorios de sitio, que pueden ser utilizados para instalar y gestionar paquetes para proyectos específicos. Es simple, ligero y fácil de usar.
    2. pyvenv: Esta es una herramienta obsoleta en Python 3.6 y versiones posteriores que es similar a venv. Ya no se recomienda usar esta herramienta ya que ha sido reemplazada por el módulo venv.
    3. pyenv: Esta es una herramienta que te permite gestionar múltiples versiones de Python en tu máquina. No está diseñada específicamente para crear entornos virtuales, pero te permite cambiar entre diferentes versiones de Python sobre la marcha.
    4. virtualenv: Esta es una herramienta de terceros popular que te permite crear entornos de Python aislados. Funciona tanto con Python 2 como con 3 y te permite crear entornos virtuales con diferentes versiones de Python, lo que puede ser útil para probar tu código en diferentes versiones de Python.
    5. virtualenvwrapper: Este es un conjunto de extensiones para virtualenv que facilita la gestión de entornos virtuales. Proporciona comandos para crear, activar y eliminar entornos virtuales, y te permite organizar tus entornos de manera más estructurada.
    6. pipenv: Esta es una herramienta que combina entornos virtuales con gestión de paquetes. Crea un nuevo entorno virtual para cada proyecto e instala automáticamente los paquetes requeridos desde un Pipfile. Está diseñado para simplificar el proceso de gestión de dependencias para tus proyectos y proporciona una interfaz más simple que virtualenv.
    
    En resumen, venv y virtualenv son similares en funcionalidad pero difieren en la implementación, donde venv es un módulo integrado en Python 3 mientras que virtualenv es una herramienta de terceros. pyvenv es una herramienta obsoleta que ha sido reemplazada por venv. pyenv es una herramienta que te permite gestionar múltiples versiones de Python en tu máquina. virtualenvwrapper es una extensión de virtualenv que proporciona funcionalidades adicionales para gestionar entornos virtuales. pipenv combina entornos virtuales con gestión de paquetes.
    

```bash
pip3 install virtualenv
```

Ahora vamos a crear el entorno virtual de esta forma, donde le llamaré entorno1:

```bash
/usr/local/bin/virtualenv -p python3 entorno1

$ ls
	entorno1

$ ls *
	bin  lib  pyvenv.cfg
```

Activamos el entorno virtual que hemos creado

```bash
$ source entorno1/bin/activate
**(entorno1)** <▸> ~/W/p/sparkenv
```

Vemos las librerías que tenemos en este entorno

```bash
$ pip list
Package    Version
---------- -------
pip        23.3.1
setuptools 69.0.2
wheel      0.42.0
```

Salimos del entorno virtual

```bash
deactivate
```