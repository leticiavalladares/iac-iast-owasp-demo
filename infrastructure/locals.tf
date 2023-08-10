locals {
  default_tags = {
    Environment = "prod"
    ManagedBy   = "terraform"
    CostCenter  = "1"
    Application = "OWASP-Juice-Shop"
    Owner       = "Dameda"
  }

  #tfstate-bucket-prod-ec1-owasp-07082023

  resource_suffix = join("-", ["ec1", "owasp"])
  aws_account_id  = ""
  ami_owner_id    = "679593333241"
  suffix_az_a     = "prod-ec1a-owasp"
  suffix_az_b     = "prod-ec1b-owasp"


  subnets = [
    {
      name     = "pub-1"
      type     = "public"
      cidr     = "10.1.0.0/24"
      vpc      = "prod"
      rtb      = "pub-1"
      main_rtb = true
      az       = "eu-central-1a"
      pub_ip   = true
      routes = [{
        name      = "1"
        cidr_dest = "0.0.0.0/0"
        dest      = "igw"
        vpc       = "prod"
        rtb       = "pub-1"
      }]
    },
    {
      name     = "priv-1"
      type     = "private"
      cidr     = "10.1.1.0/24"
      vpc      = "prod"
      rtb      = "priv-1"
      main_rtb = false
      az       = "eu-central-1a"
      pub_ip   = false
      routes = [{
        name      = "2"
        cidr_dest = "0.0.0.0/0"
        dest      = "nat"
        vpc       = "prod"
        rtb       = "priv-1"
      }]
    },
    {
      name     = "priv-2"
      type     = "private"
      cidr     = "10.1.2.0/24"
      vpc      = "prod"
      rtb      = "priv-2"
      main_rtb = false
      az       = "eu-central-1b"
      pub_ip   = false
      routes = [{
        name      = "3"
        cidr_dest = "0.0.0.0/0"
        dest      = "nat"
        vpc       = "prod"
        rtb       = "priv-2"
      }]
    }
  ]

  vpcs = {
    prod = {
      cidr = "10.1.0.0/16"
    }
  }

  sg = {
    app-sg = {
      description = "Allow access for app vpc"
      vpc         = "prod"
      inbound_rules = {
        http = {
          description = "Allow HTTP"
          from_port   = 80
          to_port     = 80
          protocol    = "tcp"
          cidr_block  = "0.0.0.0/0"
        },
        https = {
          description = "Allow HTTPS"
          from_port   = 443
          to_port     = 443
          protocol    = "tcp"
          cidr_block  = "0.0.0.0/0"
        },
        ssh = {
          description = "Allow SSH"
          from_port   = 22
          to_port     = 22
          protocol    = "tcp"
          cidr_block  = "${var.my_ip}/32"
        }
      }
    },
    db-sg = {
      description = "Allow access for public snet"
      vpc         = "prod"
      inbound_rules = {
        # mysql = {
        #   description     = "Allow MySQL/Aurora"
        #   from_port       = 3306
        #   to_port         = 3306
        #   protocol        = "tcp"
        #   security_groups = [aws_security_group.sg["app-sg"].id]
        # },
        ssh = {
          description = "Allow SSH"
          from_port   = 22
          to_port     = 22
          protocol    = "tcp"
          cidr_block  = "${var.my_ip}/32"
        }
      }
    }
  }

  appservers = {
    app-server-sqlite = {
      type      = "t3.medium"
      user_data = "user-data-sqlite.sh"
    },
    app-server-mysql = {
      type      = "t3.medium"
      user_data = "user-data-mysql.sh"
    }
  }

}