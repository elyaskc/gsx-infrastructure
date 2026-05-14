# Semana 11 — Infrastructure as Code & CI/CD

## Resumen

- **Terraform**: código que despliega automáticamente la infraestructura en Kubernetes
- **GitHub Actions**: pipeline que construye las imágenes Docker y valida Terraform en cada push

## Estructura

```
config/week4/
	- main.tf        # Deployments, Services y ConfigMap
	- variables.tf   # Imágenes, credenciales, entorno

.github/workflows/
	- ci.yml         # Pipeline de CI/CD
```

## Recursos desplegados

| Recurso | Tipo |
|---|---|
| nginx | Deployment + Service (NodePort :30080) |
| python | Deployment + Service (ClusterIP :5000) |
| postgres | Deployment + Service (ClusterIP :5432) |
| app-config | ConfigMap (variables de entorno) |

## Cómo desplegarlo

```bash
minikube start
cd config/week4
terraform init
terraform apply
kubectl get pods
minikube service nginx-service --url
```
Este último comando nos devolverá una URL, luego podemos hacer curl *URL* para probar si recibimos respuesta.

## Cómo borrarlo

```bash
terraform destroy
```

## Pipeline CI/CD

En cada git push a main:
1. Construye las imágenes nginx y python
2. Las sube a Docker Hub con el tag del commit (github.sha)
3. Valida el código Terraform
