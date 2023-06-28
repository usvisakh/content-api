locals {
  common_tags = {
    IsTerraform = "true"
    Environment = var.environment
  }
  common_key_pair = module.key_pair.key_pair_name
  region          = var.region
}

module "key_pair" {
  source  = "terraform-aws-modules/key-pair/aws"
  version = "~> 2.0"

  key_name   = "${var.name_prefix}-ec2-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDGQ5pX2EfBfJ8nP0DQiErFaauHKWFGBbjEM26V1Xp+3BWgxcrnu6fJYnoqaIOUWLvsgLNTzutglLE0i2cWfvBP+4JOiNeMuaAjWCb4iW6YPdczYvCzH8EX/kxnX9WLRE7z0v8GGUafL9w1JiGIlvjTVD+ex12AmfzaY9J58Nxyjzjh/bd7fTXv0chbbZHY7uYuVc3XlkcX/cIPupXClrDfkQOKc6LsNHYZIioyJ7G63MTScEZY3wXdcCNI2lqPgMSbPtw3nUoffuqC3UOMgtbn3aMzZEjKXIIyXSaWRm8w0plzpiu8rBw2Izl+9eZfieMvciqdIrWqJayLbHX4d9UQPffxUUMsgbaW1uXfjnsFf8AhdL6CIxADYF2Ckc5zNXd4pcMYe2gVlUeUf6Zm9hJAS0qIFVcRK0GDjaNqUs2KreHK3euiMoHfIp+eJgwCGuPmScaAefdHGKFRLqmiSsI5HIMpqyr+TMqlWIVUDDp/h3Gk1igpALl1MaLj/dbDAQ8= visakhus@Visakhs-MacBook-Air.local"
  tags = merge(
    local.common_tags,
    {
      "Name" : "${var.name_prefix}-ec2"
    }
  )
}

data "aws_secretsmanager_secret_version" "eks_secret" {
  secret_id = var.secret_name
}

