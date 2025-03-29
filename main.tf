resource "aws_vpc" "staging_vpc" {
  cidr_block = var.vpc_cidr

  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "staging-vpc"
  }
}

resource "aws_subnet" "staging_subnet" {
  vpc_id                  = aws_vpc.staging_vpc.id
  cidr_block              = var.subnet_cidr
  availability_zone       = "ap-northeast-1a"
  map_public_ip_on_launch = false

  tags = {
    Name = "staging-subnet"
  }
}

resource "aws_vpc_dhcp_options" "dns_resolver" {
  domain_name_servers = ["AmazonProvidedDNS"]
  ntp_servers        = ["169.254.169.123"]
  netbios_name_servers = ["169.254.169.123"]
  netbios_node_type = 2

  tags = {
    Name = "staging-dhcp-options"
  }
}

# VPCのDNS設定を有効化
resource "aws_vpc_dhcp_options_association" "dns_resolver" {
  vpc_id          = aws_vpc.staging_vpc.id
  dhcp_options_id = aws_vpc_dhcp_options.dns_resolver.id
}

# IAMロールの作成
resource "aws_iam_role" "ssm_role" {
  name = "ec2_ssm_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

# SSMのポリシーをアタッチ
resource "aws_iam_role_policy_attachment" "ssm_policy" {
  role       = aws_iam_role.ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# IAMインスタンスプロファイルの作成
resource "aws_iam_instance_profile" "ssm_profile" {
  name = "ec2_ssm_profile"
  role = aws_iam_role.ssm_role.name
}

# インターネットゲートウェイの作成
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.staging_vpc.id

  tags = {
    Name = "staging-igw"
  }
}

# ルートテーブルの作成
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.staging_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "staging-public-rt"
  }
}

# サブネットとルートテーブルの関連付け
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.staging_subnet.id
  route_table_id = aws_route_table.public.id
}

# EC2インスタンスの作成
resource "aws_instance" "notebook" {
  ami           = var.ami
  instance_type = var.instance_type
  key_name      = var.key_name
  subnet_id                   = aws_subnet.staging_subnet.id
  vpc_security_group_ids      = [aws_security_group.notebook.id]
  associate_public_ip_address = true
  iam_instance_profile        = aws_iam_instance_profile.ssm_profile.name

  tags = {
    Name = "staging-notebook-ec2"
  }
}

# セキュリティグループの作成
resource "aws_security_group" "notebook" {
  name        = "notebook-security-group"
  description = "Security group for notebook EC2 instance"
  vpc_id      = aws_vpc.staging_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Jupyter Notebook用のポート追加
  ingress {
    from_port   = 8888
    to_port     = 8888
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # 本番環境では適切なIPレンジに制限することを推奨
  }

  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "notebook-security-group"
  }
}

# VPCエンドポイントの作成
resource "aws_vpc_endpoint" "ssm" {
  vpc_id              = aws_vpc.staging_vpc.id
  service_name        = "com.amazonaws.ap-northeast-1.ssm"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = [aws_subnet.staging_subnet.id]
  security_group_ids  = [aws_security_group.vpce.id]
  private_dns_enabled = true
  tags = {
    Name = "ssm-vpc-endpoint"
  }
}

resource "aws_vpc_endpoint" "ssmmessages" {
  vpc_id              = aws_vpc.staging_vpc.id
  service_name        = "com.amazonaws.ap-northeast-1.ssmmessages"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = [aws_subnet.staging_subnet.id]
  security_group_ids  = [aws_security_group.vpce.id]
  private_dns_enabled = true
  tags = {
    Name = "ssmmessages-vpc-endpoint"
  }
}

resource "aws_vpc_endpoint" "ec2messages" {
  vpc_id              = aws_vpc.staging_vpc.id
  service_name        = "com.amazonaws.ap-northeast-1.ec2messages"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = [aws_subnet.staging_subnet.id]
  security_group_ids  = [aws_security_group.vpce.id]
  private_dns_enabled = true
  tags = {
    Name = "ec2messages-vpc-endpoint"
  }
}

# VPCエンドポイント用のセキュリティグループ
resource "aws_security_group" "vpce" {
  name        = "vpce-security-group"
  description = "Security group for VPC Endpoints"
  vpc_id      = aws_vpc.staging_vpc.id

  ingress {
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = [aws_security_group.notebook.id]
  }

  tags = {
    Name = "vpce-security-group"
  }
}