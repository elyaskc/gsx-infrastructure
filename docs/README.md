# GreenDevCorp — Semana 13 (Challenge C)

Aplicación web de tres capas desplegada en Kubernetes local (Minikube) y aprovisionada con Terraform.

## Stack

| Capa | Tecnología | Exposición |
|------|-----------|------------|
| Frontend | nginx | NodePort `30080` |
| Backend | Python | ClusterIP `5000` |
| Base de datos | PostgreSQL | ClusterIP `5432` |

Cada servicio corre con **3 réplicas**. La configuración se inyecta vía **ConfigMap**. El aprovisionamiento es declarativo con **Terraform** y el pipeline de CI/CD corre en **GitHub Actions**.

---

## Quick Start

### Prerrequisitos

- [Minikube](https://minikube.sigs.k8s.io/) ≥ 1.32
- [kubectl](https://kubernetes.io/docs/tasks/tools/) ≥ 1.29
- [Terraform](https://developer.hashicorp.com/terraform) ≥ 1.6
- Docker Desktop (o Docker Engine)

### 1. Arrancar Minikube

```bash
minikube start --driver=docker
eval $(minikube docker-env)   # apuntar Docker al daemon de Minikube
```

### 2. Inicializar y aplicar Terraform

```bash
cd terraform/
terraform init
terraform apply -auto-approve
```

Terraform crea el ConfigMap, los Deployments y los Services en el namespace `default`.

### 3. Verificar el despliegue

```bash
kubectl get pods
kubectl get services
```

Todos los pods deben estar en estado `Running` (3/3 réplicas por servicio).

### 4. Acceder a la aplicación

```bash
minikube service nginx-service --url
```

Abre la URL devuelta en el navegador, o accede directamente a `http://<minikube-ip>:30080`.

---

## CI/CD

Cada push a `main` dispara el workflow de GitHub Actions que:

1. Construye las imágenes Docker del frontend y backend.
2. Las sube a Docker Hub con el tag `${{ github.sha }}`.
3. Valida el plan de Terraform (`terraform validate` + `terraform plan`).
