# variables.tf
variable "DB_USER" {
  description = "Database Username"
  default     = "admin"
}

variable "DB_PASSWORD" {
  description = "Database Password"
  default     = "gsx-2026"
}

variable "DB_HOST" {
  description = "Database Host"
  default     = "db"
}

variable "APP_ENV" {
  description = "App Environment"
  default     = "development"
}

variable "NGINX_IMAGE" {
  description = "Nginx image"
  default     = "alexxx245/nginx-gsx:v1"
}

variable "PYTHON_IMAGE" {
  description = "Python image"
  default     = "alexxx245/python-gsx:v1"
}