variable "ami-zimbra" {
     default = "ami-08d4ac5b634553e16"
     type = string
     description = "Es la imagen de Ubuntu 20.04"
}
variable "ami-temporal" {
     default = "ami-08d4ac5b634553e16"
     type = string
     description = "Es la imagen de inicio para el servidor de compilación"
 }

#declaro todas las variables de entrada para el proyecto
variable "instance_type_zimbra" {
    default = "t3.xlarge"
    type = string
    description = "Es el tipo de instancia para Zimbra Collaboration Suite"
}
variable "instance_type_temporal" {
    default = "t3.xlarge"
    type = string
    description = "Es el tipo de instancia para el servidor de compilación"
}
variable "nombre_zimbra" {
    default = "Zimbra Collaboration Suite"
    type = string
    description = "Es el nombre asignado a la instancia de Zimbra Collaboration Suite"
}
variable "nombre_temporal" {
    default = "Instancia Temporal de Compilación"
    type = string
    description = "Es el nombre asignado a la instacia de compilación"
}
variable "key_nombre" {
  type        = string
  default     = "zimbra-key-pair"
  description = "Key-pair generada con terraform"
}
variable "hostname" {
  type        = string
  default     = "mail"
  description = "Nombre de dominio del servidor Zimbra Collaboration Suite"
}
variable "dominio" {
  type        = string
  default     = "andres.com"
  description = "Dominio del servidor Zimbra Collaboration Suite"
}

