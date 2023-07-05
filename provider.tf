#Se declara los proveedores utilizados en el proyecto
provider "aws" {
  region = "us-east-1"
}
provider "local" {
}
provider "tls" {
}