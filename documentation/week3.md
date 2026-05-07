# Documentación Week 3

## Deployments, Servicio y ConfigMap en Kubernetes

Un deployment es el recurso principal para gestionar pods en Kubernetes y en el archivo yaml se le indica:

- Cuantas replicas del pod se quiere
- Que imagen de contenedor usar
- Que puertos expone el contenedor
- Que variables de entorno necesita

Kubernetes se encarga de mantener siempre el numero de replicas indicado, por tanto si un pod muere, lo reinicia automáticamente


Un servicio proporciona una IP y un nombre DNS estable para acceder a un conjunto de pods. 2 tipos principales de Servicios:

- ClusterIP: lo hemos usado en python y db. Es solo accesible desde dentro del cluster y los servicios internos no necesitan exponerse al exterior. 
- NodePort: lo hemos usado en nginx. Expone el servicio en un puerto del nodo (la máquina), permitiendo acceso desde fuera del cluster.


Un ConfigMap almacena pares clave-valor de configuración que los pods pueden consumir como variables de entorno. Lo hemos usado para centralizar las credenciales de la base de datos y la configuración del entorno para no hardcodear valores en los Deployments.
En un escenario real de producción, las contraseñas se guardan en un recurso Secret en vez de ConfigMap, ya que Secret cifra los datos.


## Instalación Minikube y kubectl

Para instalar minikube, se necesitan mínimo 2GB de RAM y 2 CPUs y también Docker instalado y funcionando.

Los pasos para instalar minikube:

- `curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64` --> esto descarga el binario
- `sudo install minikube-linux-amd64 /usr/local/bin/minikube` -->  esto instala el binario

Y para verificar que se ha instalado correctamente:

- `minikube version`


Para instalar kubectl:

- `curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"` --> esto descarga kubectl
- `sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl` --> esto instala kubectl

Y para verificar la instalación:

- `kubectl version --client`

Una vez instalado minikube y kubectl, arrancamos el cluster:

- `minikube start --driver=docker`

Si al ejecutar este comando falla por permisos, hay que agregar docker al grupo del usuario de la siguiente manera:

- `sudo usermod -aG docker $USER && newgrp docker`

Para verificar que el cluster esta activo:

- `kubectl cluster-info`
- `kubectl get nodes`



## Deployment en Kubernetes

Para aplicar los manifiestos, desde el directorio /kubernetes usar el siguiente comando:

- `kubectl apply -f .`

Y para verificarlo:

- `kubectl get pods`
- `kubectl get services`

Para acceder a un servicio concreto con minikube:

- `minikube service nginx`
- `minikube service nginx --url` --> esto obtiene la URL manualmente



## Comunicación entre Servicios

Para verificar que los servicios se comunican entre si por nombre (descubrimieno por DNS):

- `kubectl exec -it deployment/nginx -- bash` --> esto entra dentro del pod de nginx
- `curl http://python:5000` --> desde dentro del pod, llama al backend Python por su nombre de servicio
- `exit` --> salir del pod

Esto demuestra que Kubernetes tiene DNS interno. El pod de nginx puede encontrar al pod de Python usando el nombre python, sin tener que saber su IP



## Prueba de escalado

Una de las ventajas de Kubernetes es poder escalar servicios con un comando:

- `kubectl scale deployment nginx --replicas=5` --> escalar nginx a 5 replicas, originalmente se creó con 3 replicas
- `kubectl get pods --watch` --> ver en tiempo real como se crean los nuevos pods
- `kubectl scale deployment nginx --replicas=1` --> escalar hacia abajo a 1 replica, originalmente se creó con 3 replicas

Con Docker Compose esto no es posible de forma nativa. Kubernetes gestiona automáticamente la distribución del tráfico entre las replicas mediante el servicio


## Prueba de resiliencia


Kubernetes detecta cuando un pod falla y lo reinicia automáticamente

Para probarlo:

- `kubectl get pods` --> ver los pods actuales
- `kubectl delete pod nginx` --> eliminar un pod específico simulando un fallo
- `kubectl get pods --watch` --> ver en tiempo real como Kubernetes crea uno nuevo inmediatamente

El servicio de nginx sigue funcionando durante este proceso ya que redirige el tráfico al nuevo pod en cuanto esté listo. En Docker Compose, si un contenedor moría había que reiniciarlo manualmente.



