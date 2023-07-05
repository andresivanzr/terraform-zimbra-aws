resource "aws_instance" "zimbraserver" {
    ami = var.ami-zimbra
    instance_type = var.instance_type_zimbra
    tags = {
        Name = var.nombre_zimbra
        Descripcion = "Este servidor ejecuta el servicio de Zimbra Collaboration Suite"
    }
    root_block_device {
      volume_size = 30
    }
    key_name = "zimbra-key-pair"
    vpc_security_group_ids = [ aws_security_group.zimbra-access.id ]
    
    depends_on = [
      aws_instance.temporal
    ]

    provisioner "file" {
      source      = "./${var.key_nombre}.pem"
      destination = "/home/ubuntu/${var.key_nombre}.pem"   
    }

    provisioner "file" {
      source      = "./zimbrainstall"
      destination = "/home/ubuntu/"
     
    }


    provisioner "remote-exec" {
      inline = [
        "sudo apt update -y",
        "sudo apt update -y",
        "sudo apt install software-properties-common -y",
        "sudo add-apt-repository --yes --update ppa:ansible/ansible",
        "sudo apt install ansible -y",
        "ansible-playbook  /home/ubuntu/zimbrainstall/playbookzimbra.yml -v --extra-vars 'hostname=${var.hostname}.${var.dominio} nombre_servidor=${var.hostname} dominio=${var.dominio} pem=${var.key_nombre}.pem ipinstancetemporal=${data.aws_instance.private-ip-temporal.private_ip}'>> logs"
      ]
    }

    connection {
    type     = "ssh"
    user     = "ubuntu"
    private_key = tls_private_key.zimbra_key.private_key_pem
    host     = self.public_ip
    }
}


resource "aws_instance" "temporal" {
    ami = var.ami-temporal
    instance_type = var.instance_type_temporal
    tags = {
        Name = var.nombre_temporal
        Descripcion = "Este servidor es temporal para la compilación"
    }
    root_block_device {
      volume_size = 30
    }
    key_name = aws_key_pair.zimbra-pem.id
    vpc_security_group_ids = [ aws_security_group.temporal.id ]

    provisioner "file" {
      source      = "./Dockerfile"
      destination = "/home/ubuntu/Dockerfile"
    }

    provisioner "file" {
      source      = "./playbook.yml"
      destination = "/home/ubuntu/playbook.yml"
    }

    connection {
    type     = "ssh"
    user     = "ubuntu"
    private_key = tls_private_key.zimbra_key.private_key_pem
    host     = self.public_ip
    }

    provisioner "remote-exec" {
      inline = [
        "sudo apt update -y",
        "sudo apt update -y",
        "sudo apt install software-properties-common -y",
        "sudo add-apt-repository --yes --update ppa:ansible/ansible",
        "sudo apt install ansible -y",
        "ansible-playbook  /home/ubuntu/playbook.yml -v >> logs"
      ]
    }    
}

output publicipzimbra {
  value = aws_instance.zimbraserver.public_ip
}

output publiciptemporal {
  value = aws_instance.temporal.public_ip
}

data "aws_instance" "private-ip-temporal" {
  instance_id = aws_instance.temporal.id
}

data "aws_instance" "private-ip-zimbra" {
  instance_id = aws_instance.zimbraserver.id
}


resource "aws_security_group" "zimbra-access" {
  name = "zimbra-access"
  description = "Permite acceso al puerto 443 y ssh desde el mundo"
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 7071
    to_port = 7071
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 25
    to_port = 25
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 587
    to_port = 587
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 465
    to_port = 465
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 993
    to_port = 993
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 995
    to_port = 995
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  lifecycle {
    create_before_destroy = true
  }  
}

resource "aws_security_group" "temporal" {
  name = "temporal"
  description = "Permite acceso al puerto 22 desde el mundo"
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  lifecycle {
    create_before_destroy = true
  }
}


resource "tls_private_key" "zimbra_key" {
  algorithm = "RSA"
  rsa_bits  = 4096

  lifecycle {
    prevent_destroy = false
  }
}

resource "aws_key_pair" "zimbra-pem" {
  key_name   = var.key_nombre
  public_key = tls_private_key.zimbra_key.public_key_openssh
 
  provisioner "local-exec" {    # Genera "zimbra-key-pair.pem" en el directorio actual
    command = <<-EOF
      echo '${tls_private_key.zimbra_key.private_key_pem}' > ./'${var.key_nombre}'.pem
      chmod 400 ./'${var.key_nombre}'.pem
    EOF
  }
  
  lifecycle {
    prevent_destroy = false
  }
  
}



