
✏️ **EJERCICIOS**


??? Solución
     $ hdfs dfsadmin -report 
	     "Under replicated blocks" -> Si configuramos como réplica por ejemplo 3 y hay algún bloque con menos. Si esto baja de un determinado porcentaje, hadoop se pone en modo seguro porque piensa que hay algún problema. 
	 $ hdfs fsck / 
	 $ hdfs fsck /datos2 
	 $ hdfs dfsadmin -printTopology 
	 $ hdfs dfsadmin -listOpenFiles

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












