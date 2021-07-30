
resource "aws_vpc" "this" {
  cidr_block = "192.168.0.0/16"
  tags       = merge(local.tags, { Name = "${local.base_name}-vpc" })
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id
  tags   = merge(local.tags, { Name = "${local.base_name}-igw" })
}

resource "aws_subnet" "this" {
  for_each = {
    "pub_a" : ["192.168.1.0/24", "${var.region}a", "${local.base_name}-public-a"]
    "pub_b" : ["192.168.2.0/24", "${var.region}b", "${local.base_name}-public-b"]
    "pvt_a" : ["192.168.3.0/24", "${var.region}a", "${local.base_name}-private-a"]
    "pvt_b" : ["192.168.4.0/24", "${var.region}b", "${local.base_name}-private-b"]
  }

  vpc_id            = aws_vpc.this.id
  cidr_block        = each.value[0]
  availability_zone = each.value[1]

  tags = merge(local.tags, { Name = each.value[2] })
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }

  tags = merge(local.tags, { Name = "${local.base_name}-public-rt" })
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.this.id
  tags   = merge(local.tags, { Name = "${local.base_name}-private-rt" })
}

resource "aws_route_table_association" "this" {
  for_each = local.subnet_ids

  subnet_id      = each.value
  route_table_id = substr(each.key, length("${local.base_name}-") , 6) == "public" ? aws_route_table.public.id : aws_route_table.private.id
}