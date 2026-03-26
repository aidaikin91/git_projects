output "documentdb_cluster_id" {
  description = "DocumentDB cluster identifier"
  value       = aws_docdb_cluster.documentdb.id
}

output "documentdb_cluster_endpoint" {
  description = "DocumentDB cluster endpoint"
  value       = aws_docdb_cluster.documentdb.endpoint
}

output "documentdb_cluster_reader_endpoint" {
  description = "DocumentDB reader endpoint"
  value       = aws_docdb_cluster.documentdb.reader_endpoint
}

output "documentdb_port" {
  description = "DocumentDB port"
  value       = var.port
}

output "documentdb_security_group_id" {
  description = "Security group ID attached to DocumentDB"
  value       = aws_security_group.documentdb_sg.id
}

output "documentdb_secret_arn" {
  description = "Secrets Manager ARN storing DocumentDB credentials"
  value       = aws_secretsmanager_secret.documentdb.arn
}

output "documentdb_secret_name" {
  description = "Secrets Manager name storing DocumentDB credentials"
  value       = aws_secretsmanager_secret.documentdb.name
}