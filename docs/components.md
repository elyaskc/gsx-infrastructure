# Componentes — GreenDevCorp

## nginx (Frontend)

- **Imagen:** `nginx:latest`
- **Réplicas:** 3
- **Puerto expuesto:** NodePort `30080` → contenedor `80`
- **Función:** sirve los archivos estáticos (HTML/CSS/JS) y actúa como reverse proxy hacia el backend Python en `python-service:5000`.

## Python (Backend)

- **Imagen:** `greendevcorp/python-gsx:<sha>`
- **Réplicas:** 3
- **Puerto:** ClusterIP `5000`
- **Función:** API REST. Recibe peticiones de nginx, ejecuta lógica de negocio y consulta PostgreSQL. Expone endpoints como `/api/data`.
- **Dependencias:** necesita que `postgres-service:5432` esté disponible al arrancar.

## PostgreSQL (Base de datos)

- **Imagen:** `postgres:15`
- **Réplicas:** 3
- **Puerto:** ClusterIP `5432`
- **Función:** almacenamiento relacional persistente. Solo accesible desde dentro del clúster.

## ConfigMap (`app-config`)

Centraliza las variables de entorno inyectadas en los pods de Python:

| Variable | Descripción |
|----------|-------------|
| `DB_USER` | Usuario de PostgreSQL |
| `DB_PASSWORD` | Contraseña de PostgreSQL |
| `DB_HOST` | Hostname interno del servicio (`postgres-service`) |
| `APP_ENV` | Entorno de ejecución (`development` / `production`) |

## Terraform

Gestiona toda la infraestructura de Kubernetes de forma declarativa.

| Archivo | Contenido |
|---------|-----------|
| `main.tf` | ConfigMap, Deployments y Services de los tres servicios |
| `variables.tf` | Parámetros configurables: nombres de imagen, número de réplicas, credenciales |
| `outputs.tf` | URL pública del servicio nginx, IPs de los servicios internos |

**Flujo:** `terraform init` → `terraform plan` → `terraform apply`. Para destruir: `terraform destroy`.

## GitHub Actions (CI/CD)

El workflow se activa en cada push a `main` y tiene tres etapas:

1. **Build & push nginx** — construye la imagen del frontend y la publica en Docker Hub con el tag `${{ github.sha }}`.
2. **Build & push python** — lo mismo para el backend.
3. **Validar Terraform** — ejecuta `terraform init`, `terraform validate` y `terraform plan` para detectar errores de configuración antes de aplicar.

El tag con el SHA del commit garantiza que cada imagen desplegada apunta exactamente al código que la generó.
