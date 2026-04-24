# Documentación Week 1

## Tarea 1: Servidor Nginx
Para el primer contenedor, he utilizado el script install_ssh.sh de la práctica 1, lo he añadido y he creado la imagen con los siguientes parámetros:
- Imagen: nginx:latest
- Directorio: /app
- Añadir el script install_ssh.sh al contenedor
- Exponer el puerto 80 para poder acceder

Para ejecutarlo, utilizamos el comando "docker build -t nginx-gsx .", esto crea la imagen (no el contenedor) poniendole de nombre nginx-gsx y utilizando la carpeta actual (.) como contexto para crearla.

Para crear y arrancar el contenedor se utiliza el comando:
"docker run -d -p 8080:80 nginx-gsx"
Esto ejecuta el contenedor en segundo plano, sin ocupar la consola (-d), mapeando el puerto 8080 de la máquina virtual al puerto 80 del contenedor, como un túnel, y utiliza la imagen creada anteriormente, nginx-gsx.

## Tarea 2: Servidor Python
Para este contenedor he creado un script en Python que simplemente imprime una frase por pantalla.
En el dockerfile he hecho las siguientes configuraciones:
- Imagen: python:alpine
- Directorio: /app
- Exponer el puerto 5000 para poder acceder

Para crear la imagen utilizamos el comando "docker build -t python-gsx ."
Finalmente, creamos y ejecutamos el contenedor con:
"docker run -p 5000:8080 python-gsx"

En este caso no usamos el parámetro -d ya que el script solo imprime una frase por consola y muere, verla nos sirve para saber que funcionado correctamente.

## Tarea 3: Docker Hub
Creamos una cuenta de Docker Hub
Ejecutamos en consola "docker login" para iniciar sesión
Nos redirige a la web login.docker.com/activate, alli introducimos el código que nos salió por consola
Le asignamos un tag a nuestra imagen con:
"docker tag nginx-gsx usuario/nginx-gsx:v1
Y lo subimos con:
"docker push usuario/nginx-gsx:v1"

Para comprobar que ha funcionado, he accedido a Docker Desktop desde mi ordenador, me he bajado la imagen y la he probado localmente, ha funcionado.
