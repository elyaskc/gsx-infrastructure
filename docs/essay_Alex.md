# Reflection essay Àlex Sala Rodríguez

## Cúal ha sido el aspecto más desafiante de esta práctica?

El aspecto más desafiante yo creo que ha sido entender y usar Kubernetes, ya que pasar de Docker Compose, donde un único archivo define toda la infraestructura de forma directa a usar Kubernetes, al principio era un poco abrumador.
La cantidad de conceptos que hay que entender, como los pods, los deployments, los services, ConfigMaps, namespaces y las NetworkPolicies, hacía difícil saber por donde empezar. Relativo al nivel de dificultad, al principio fue depurar los pods que fallaban, sobretodo en el python deployment, ya que daba errores de estado como CrashLoopBackOff o ImagePullBackOff, y estos daban poca información a primera vista y por tanto tuve que entender a usar kubectl logs y kubectl describe para entender que pasaba realmente.


## Qué te ha sorprendido de la infraestructura moderna?

Me sorprendió la complejidad detrás de conceptos que al principio parecen sencillos. Por ejemplo, con Docker di por hecho que subir una imagen Docker nueva con el mismo tag a Docker Hub, actualizaría automáticamente los contenedores en Kubernetes y no es así, ya que entendí que Kubernetes cachea las imágenes localmente y, sin forzar explícitamente una nueva descarga, sigue ejecutando la versión antigua.
Otra cosa que cambió mi perspectiva fue el diseño de la red. No había pensado detenidamente la importancia de la segmentación de la red en subredes que se usa en las organizaciones o por qué una base de datos nunca debería ser accesible desde Internet. 
El hecho de diseñar la arquitectura de GreenDevCorp con una DMZ, entornos aislados y una subred dedicada para la base de datos hizo que estos conceptos se volvieran más concretos y reales. Lo mismo con la gestión de la Identidad, ya que antes de la práctica no sabía que significaba LDAP ni SSO, ya que eran siglas que solo había escuchado en algún sitio.


## Qué harías diferente si volvieras a empezar?

Al principio la parte del servidor backend con python, tuvimos un simple print, pero esto no era realmente el comportamiento de un server HTTP, ya que al ejecutarse imprimía el mensaje y moría y así en ciclo. Esto nos hizo perder bastante tiempo para depurar ya que nos daba problemas a la hora de crear el deployment, y en el estado del pod, en vez de Running, aparecían mensajes raros como CrashLoopBackOff entre otros.
También un poco típico pero verdad, deberíamos habernos organizado mejor y darle más importancia y no solo realizar las tareas obligatorias y los Cores básicos. De esta manera, envalentonarse a realizar algún Core más avanzado.


## Qué te gustaría aprender más?

Yo creo que aprender más de Kubernetes en general, para entornos de producción y como los pipelines de CI/CD se integran con Kubernetes para automatizar los deployments. También la parte de observabilidad y monitorización con Prometheus y Grafana, ya que al final no lo hemos implementado porque era parte opcional.

En general, la preparación de esta práctica y los problemas a resolver me han parecido muy útiles de cara a casos reales en la industria. Esto ha hecho un aprendizaje más complicado pero más valioso y útil. Ahora me siento capaz de leer un Dockerfile o un manifiesto de Kubernetes y entender qué hace cada línea y por qué se utiliza. 
