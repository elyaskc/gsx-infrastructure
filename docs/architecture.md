# Arquitectura — GreenDevCorp

## Diagrama de componentes

```
  Internet / Navegador
         │
         │  HTTP :30080 (NodePort)
         ▼
┌─────────────────────┐
│   nginx-service     │  NodePort 30080
│  (3 réplicas)       │
│  nginx:latest       │
└────────┬────────────┘
         │  HTTP :5000 (ClusterIP, interno)
         ▼
┌─────────────────────────┐
│   python-service        │  ClusterIP 5000
│  (3 réplicas)           │
│ greendevcorp/python-gsx │◄──── ConfigMap
└────────┬────────────────┘          DB_USER, DB_PASSWORD
         │  TCP :5432 (ClusterIP, interno)  DB_HOST, APP_ENV
         ▼
┌─────────────────────┐
│  postgres-service   │  ClusterIP 5432
│  (3 réplicas)       │
│  postgres:15        │
└─────────────────────┘
```

## Red interna de Kubernetes

```
Namespace: default
─────────────────────────────────────────────────────
 Pod nginx      ──► python-service.default.svc:5000
 Pod python     ──► postgres-service.default.svc:5432
 Pod postgres   (sin salida a otros servicios)
─────────────────────────────────────────────────────
```

Solo `nginx-service` es accesible desde fuera del clúster. Los demás servicios son exclusivamente internos (`ClusterIP`).

## Pipeline CI/CD

```
GitHub Push (main)
       │
       ▼
GitHub Actions
  ├── docker build  (nginx)  ──► Docker Hub  greendevcorp/nginx-gsx:<sha>
  ├── docker build  (python) ──► Docker Hub  greendevcorp/python-gsx:<sha>
  └── terraform validate / plan
```

## Aprovisionamiento (Terraform)

```
main.tf
  ├── kubernetes_config_map   (variables de entorno)
  ├── kubernetes_deployment   nginx   (3 réplicas)
  ├── kubernetes_deployment   python  (3 réplicas)
  ├── kubernetes_deployment   postgres(3 réplicas)
  ├── kubernetes_service      nginx-service   NodePort 30080
  ├── kubernetes_service      python-service  ClusterIP 5000
  └── kubernetes_service      postgres-service ClusterIP 5432

variables.tf  ──► parámetros configurables (imagen, réplicas, credenciales)
outputs.tf    ──► URL del servicio nginx, IPs de ClusterIP
```
