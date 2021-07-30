locals {
  subnet_ids = { for k, v in aws_subnet.this : v.tags.Name => v.id }
  base_name  = var.product
  tags = {
    "environment"            = var.env
    "environmentVersion"     = var.envVersion
    "createdBy"              = var.createdBy
    "owner"                  = var.owner
    "product/${var.product}" = "1"
  }
}