# Runbook — GreenDevCorp

## Despliegue completo desde cero

```bash
minikube start --driver=docker
eval $(minikube docker-env)
cd terraform/
terraform init && terraform apply -auto-approve
kubectl get pods -w          # esperar a que todos estén Running
minikube service nginx-service --url
```

## Actualizar una imagen

```bash
# 1. Construir y subir la nueva imagen
docker build -t greendevcorp/app:v2 ./backend
docker push greendevcorp/app:v2

# 2. Actualizar el Deployment (o cambiar la variable en variables.tf y re-aplicar)
kubectl set image deployment/python-deployment app=greendevcorp/app:v2
kubectl rollout status deployment/python-deployment
```

## Escalar un servicio

```bash
# Escalar python a 5 réplicas
kubectl scale deployment python-deployment --replicas=5

# Volver a 3
kubectl scale deployment python-deployment --replicas=3
```

Para que el cambio sea permanente, actualiza `replicas` en `variables.tf` y ejecuta `terraform apply`.

## Ver logs

```bash
# Logs de todos los pods de un servicio
kubectl logs -l app=python --tail=100

# Logs en tiempo real
kubectl logs -l app=nginx -f

# Logs de un pod específico
kubectl logs <nombre-del-pod>
```

## Troubleshooting

### Pods en CrashLoopBackOff

```bash
kubectl describe pod <nombre-del-pod>
kubectl logs <nombre-del-pod> --previous
```

Causas comunes:
- Credenciales incorrectas en el ConfigMap.
- La imagen no existe en Docker Hub o Minikube no puede bajarla.
- El backend arranca antes que PostgreSQL esté listo.

### Pods en Pending

```bash
kubectl describe pod <nombre-del-pod>
# En la sección Events al final
```

Causas comunes:
- Recursos insuficientes en el nodo (`minikube start --cpus=4 --memory=4096`).

### No se puede acceder al frontend

```bash
minikube service nginx-service --url   # obtener la URL correcta
kubectl get service nginx-service      # verificar NodePort asignado
curl http://$(minikube ip):30080
```

### El backend no conecta con la base de datos

```bash
kubectl get configmap app-config -o yaml   # verificar DB_HOST y credenciales
kubectl exec -it <pod-python> -- env | grep DB
kubectl exec -it <pod-python> -- nc -zv postgres-service 5432
```

### Reiniciar un despliegue completo

```bash
kubectl rollout restart deployment/nginx-deployment
kubectl rollout restart deployment/python-deployment
kubectl rollout restart deployment/postgres-deployment
```

## Destruir el entorno

```bash
cd config/week4/
terraform destroy -auto-approve
minikube stop
```
