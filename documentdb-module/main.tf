locals {
  name_prefix = replace("${var.project_name}-${var.environment}", "_", "-")
}

resource "random_password" "docdb_password" {
  length           = 20
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "aws_security_group" "documentdb_sg" {
  name        = "${local.name_prefix}-sg"
  description = "Security group for DocumentDB"
  vpc_id      = var.vpc_id

  tags = {
    Name        = "${local.name_prefix}-sg"
    Environment = var.environment
    Project     = var.project_name
  }
}

resource "aws_vpc_security_group_ingress_rule" "docdb_from_eks_nodes" {
  security_group_id            = aws_security_group.documentdb_sg.id
  referenced_security_group_id = var.eks_node_security_group_id
  from_port                    = var.port
  to_port                      = var.port
  ip_protocol                  = "tcp"
  description                  = "Allow DocumentDB access from EKS worker nodes"
}

resource "aws_vpc_security_group_egress_rule" "docdb_egress" {
  security_group_id = aws_security_group.documentdb_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
  description       = "Allow all outbound traffic"
}

resource "aws_docdb_subnet_group" "documentdb" {
  name       = "${local.name_prefix}-subnet-group"
  subnet_ids = var.private_subnets

  tags = {
    Name        = "${local.name_prefix}-subnet-group"
    Environment = var.environment
    Project     = var.project_name
  }
}

resource "aws_docdb_cluster_parameter_group" "documentdb" {
  family      = "docdb5.0"
  name        = "${local.name_prefix}-pg"
  description = "Custom parameter group for DocumentDB with TLS disabled"

  parameter {
    name  = "tls"
    value = "disabled"
  }

  tags = {
    Name        = "${local.name_prefix}-pg"
    Environment = var.environment
    Project     = var.project_name
  }
}

resource "aws_docdb_cluster" "documentdb" {
  cluster_identifier              = "${local.name_prefix}-cluster"
  engine                          = "docdb"
  engine_version                  = var.engine_version
  master_username                 = var.master_username
  master_password                 = random_password.docdb_password.result
  db_subnet_group_name            = aws_docdb_subnet_group.documentdb.name
  vpc_security_group_ids          = [aws_security_group.documentdb_sg.id]
  db_cluster_parameter_group_name = aws_docdb_cluster_parameter_group.documentdb.name
  storage_encrypted               = true
  backup_retention_period         = 1
  preferred_backup_window         = "07:00-09:00"
  skip_final_snapshot             = true
  deletion_protection             = false
  port                            = var.port

  tags = {
    Name        = "${local.name_prefix}-cluster"
    Environment = var.environment
    Project     = var.project_name
  }
}

resource "aws_docdb_cluster_instance" "documentdb" {
  count              = var.instance_count
  identifier         = "${local.name_prefix}-instance-${count.index + 1}"
  cluster_identifier = aws_docdb_cluster.documentdb.id
  instance_class     = var.instance_class

  tags = {
    Name        = "${local.name_prefix}-instance-${count.index + 1}"
    Environment = var.environment
    Project     = var.project_name
  }
}

resource "aws_secretsmanager_secret" "documentdb" {
  name                    = "${local.name_prefix}-credentials"
  recovery_window_in_days = 0

  tags = {
    Name        = "${local.name_prefix}-credentials"
    Environment = var.environment
    Project     = var.project_name
  }
}

resource "aws_secretsmanager_secret_version" "documentdb" {
  secret_id = aws_secretsmanager_secret.documentdb.id

  secret_string = jsonencode({
    username   = var.master_username
    password   = random_password.docdb_password.result
    engine     = "docdb"
    host       = aws_docdb_cluster.documentdb.endpoint
    readerhost = aws_docdb_cluster.documentdb.reader_endpoint
    port       = var.port
    dbname     = var.db_name
    uri        = "mongodb://${var.master_username}:${random_password.docdb_password.result}@${aws_docdb_cluster.documentdb.endpoint}:${var.port}/${var.db_name}?retryWrites=false"
  })
}


