module "web_server_sg" {
  source = "terraform-aws-modules/security-group/aws//modules/http-80"

  name                = "${var.app_name}-web-server-sg"
  description         = "Security group for web-server with HTTP port open"
  vpc_id              = module.vpc.vpc_id
  ingress_cidr_blocks = ["0.0.0.0/0"]
}