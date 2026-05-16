#!/bin/bash

echo "Borrando infraestructura existente"
terraform destroy -auto-approve

echo "Verificando que no hay nada"
kubectl get pods
kubectl get services

echo "Desplegando desde cero"
terraform apply -auto-approve

echo "Verificando despliegue"
kubectl get pods
kubectl get services

echo "URL de acceso"
minikube service nginx-service --url
