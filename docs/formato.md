
✏️ **EJERCICIOS**


??? Solución
     $ hdfs dfsadmin -report 
	     "Under replicated blocks" -> Si configuramos como réplica por ejemplo 3 y hay algún bloque con menos. Si esto baja de un determinado porcentaje, hadoop se pone en modo seguro porque piensa que hay algún problema. 
	 $ hdfs fsck / 
	 $ hdfs fsck /datos2 
	 $ hdfs dfsadmin -printTopology 
	 $ hdfs dfsadmin -listOpenFiles



## Test

!!!question "Ejercicios"
	agregar:

	  - admonition
      - pymdownx.details

    First, create a directory in your `docs` directory to hold the event pages:

    ```
    $ mkdir docs/events
    ```

    Then, add a file `.meta.yml` inside this new directory with settings for
    the page icon and a hot pink background color that will stand out on
    social media. Note that you can override the background image by setting it
    to `null` here since it is not visible anyway because of the opaque coloring.

    ```yaml
    ---
    icon: material/calendar-plus
    social:
      cards_layout_options:
        background_image: null
        background_color: "#ff1493"
    ---
    ```

    Now add a page within the `docs/events` directoy. It does not need to have
    any special content, just a top level header.

    To turn on the `default/variant` layout in `mkdocs.yml`, add the
    `cards_layout` option and also add the meta plugin:

    ```yaml
    plugins:
      - meta
      - social:
          cards_layout: default/variant
    ```

    After running `mkdocs build`, you can see that the social card at
    `site/assets/images/social/events/index.png` features the page icon.



> [!question] Title
> Contents





# Admonition

> [!NOTE] Title -> Para ejercicios
> Contents


> [!danger] Title -> PENDIENTE
> Contents


> [!example] Title -> Para ejemplos
> Contents


> [!quote] Title -> Frases
> Contents


> [!failure] Title -> Para errores
> Contents


> [!question] Title -> Info APP
> Contents




> [!abstract] Title
> Contents


> [!info] Title -> Algo más de información
> Contents


> [!tip] Title
> Contents


> [!success] Title
> Contents


> [!question] Title
> Contents


> [!warning] Title
> Contents



> [!bug] Title
> Contents












