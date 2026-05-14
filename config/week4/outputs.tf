output "nginx_node_port" {
  description = "Puerto para acceder a Nginx"
  value       = 30080
}

output "app_environment" {
  description = "Entorno de la aplicación"
  value       = var.APP_ENV
}

output "db_host" {
  description = "Host de la base de datos"
  value       = var.DB_HOST
}