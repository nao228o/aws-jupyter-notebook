resource "aws_subnet" "subnet" {
  vpc_id                  = data.terraform_remote_state.vpc.outputs.vpc_id
  cidr_block              = var.subnet_cidr
  availability_zone       = "ap-northeast-1a"
  map_public_ip_on_launch = false
  tags = {
    Name = "${var.env}-subnet"
  }
}

