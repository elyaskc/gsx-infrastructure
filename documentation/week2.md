# Documentación Week 2

Para esta tarea hemos utilizado los dos Dockerfile de la semana anterior, nginx-gsx y python-gsx.

También hemos utilizado una base de datos Postgres para guardar los datos y un volúmen para hacerlos persistentes.

Para los servicios Nging y Python hemos configurado la carpeta donde se contruyen, ya que deben ser carpetas diferentes, asignar puertos diferentes a cada uno para poder acceder a ambos, y si debe ejecutarse otro servicio antes.
En caso de Nginx hemos puesto "depends_on: Python", teniendo en cuenta que Python es el backend y debe ejecutarse primero, y para el backend hemos puesto "depends_on: db".

Para la base de datos hemos utilizado una imagen de postgres:13, hemos creado un volumen para no perder los datos al terminar el contenedor, y hemos utilizado variables de entorno para inyectar el usuario y la contraseña.

Para estas variables de entorno, hemos creado primero un archivo .env y lo hemos añadido al .gitignore para que no se suba al repositorio de GitHub y poner en riesgo el acceso a nuestra base de datos.

