#Terraform config
terraform {
    required_providers {
        kubernetes = {
            source = "hashicorp/kubernetes"
            version = "~> 2.0"
        }
    }
}

provider "kubernetes" {
    config_path = "~/.kube/config"
}

# ConfigMap
resource "kubernetes_config_map" "config" {
    metadata {
        name = "app-config"
    }
    data = {
        DB_USER = var.DB_USER
        DB_PASSWORD = var.DB_PASSWORD
        DB_HOST = var.DB_HOST
        APP_ENV = var.APP_ENV
    }
}

#Nginx
resource "kubernetes_deployment" "nginx" {
    metadata {
        name = "nginx-deployment"
        labels = {
            app = "nginx"
        }
    }
    spec {
        replicas = 3
        selector {
            match_labels = {
                app = "nginx"
            }
        }
        template {
            metadata {
                labels = {
                    app = "nginx"
                }
            }
            spec {
                container {
                    name = "nginx"
                    image = var.NGINX_IMAGE
                    port {
                        container_port = 80
                    }
                }
            }
        }
    }
}

resource "kubernetes_service" "nginx" {
    metadata {
        name = "nginx_service"
    }
    spec {
        type = "NodePort"
        selector = {
            app = "nginx"
        }
        port {
            port = 80
            target_port = 80
            node_port = 30080
        }
    }
}

#Python
resource "kubernetes_deployment" "python" {
    metadata {
        name = "python-deployment"
        labels = {
            app = "python"
        }
    }
    spec {
        replicas = 3
        selector {
            match_labels = {
                app = "python"
            }
        }
        template {
            metadata {
                labels = {
                  app = "python"
                }
            }
            spec {
                container {
                    name = "python"
                    image = var.PYTHON_IMAGE
                    port {
                        container_port = 5000
                    }
                    env {
                        name = "DB_USER"
                        value_from {
                          config_map_key_ref {
                            name = "app-config"
                            key = "DB_USER"
                          }
                        }
                    }
                    env {
                        name = "DB_PASSWORD"
                        value_from {
                            config_map_key_ref {
                              name = "app-config"
                              key = DB_PASSWORD
                            }
                        }
                    }
                    env {
                        name = "DB_HOST"
                        value_from {
                            config_map_key_ref {
                              name = "app-config"
                              key = "DB_HOST"
                            }
                        }
                    }
                }
            }
        }
    }
}

resource "kubernetes_service" "python" {
    metadata {
        name = "python-service"
    }
    spec {
        type = "ClusterIP"
        selector = {
            app = "python"
        }
        port {
            port = 5000
            target_port = 5000
        }
    }
}

#DB
resource "kubernetes_deployment" "db" {
    metadata {
        name = "db-deployment"
        labels = {
            app = "db"
        }
    }
    spec {
        replicas = 3
        selector {
            match_labels = {
                app = "db"
            }
        }
        template {
            metadata {
                labels = {
                    app = "db"
                }
            }
            spec {
                container {
                    name  = "postgres"
                    image = "postgres:13"
                    port {
                        container_port = 5432
                    }
                    env {
                        name = "POSTGRES_USER"
                        value_from {
                            config_map_key_ref {
                                name = "app-config"
                                key  = "DB_USER"
                            }
                        }
                    }
                    env {
                        name = "POSTGRES_PASSWORD"
                        value_from {
                            config_map_key_ref {
                                name = "app-config"
                                key  = "DB_PASSWORD"
                            }
                        }
                    }
                }
            }
        }
    }
}
resource "kubernetes_service" "db" {
    metadata {
        name = "db-service"
    }
    spec {
        type = "ClusterIP"
        selector = {
            app = "db"
        }
        port {
            port = 5432
            target_port = 5432
        }
    }
}