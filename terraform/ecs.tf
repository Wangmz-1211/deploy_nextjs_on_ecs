module "ecs_cluster" {
  source  = "terraform-aws-modules/ecs/aws//modules/cluster"
  version = "5.7.3"

  create_task_exec_iam_role = true

  cluster_name = var.app_name

  fargate_capacity_providers = {
    FARGATE = {
      default_capacity_provider_strategy = {
        base = 1
      }
    }
  }
}
module "ecs_service" {

  source      = "terraform-aws-modules/ecs/aws//modules/service"
  name        = "${var.app_name}-service"
  cluster_arn = module.ecs_cluster.arn

  cpu    = 256
  memory = 512

  enable_execute_command = true

  container_definitions = {
    app = {
      cpu       = 256
      memory    = 512
      essential = true
      image     = "${module.ecr.repository_url}:latest"
      port_mappings = [
        {
          name          = "app"
          host_port     = 3000
          containerPort = 3000
          protocol      = "tcp"
        }
      ]
      readonly_root_filesystem = false
    }
  }

  #   service_connect_configuration = {
  #     namespace = var.app_name
  #     service = {
  #       client_alias = {
  #         port     = 80
  #         dns_name = var.app_name
  #       }
  #       port_name      = var.app_name
  #       discovery_name = var.app_name
  #     }
  #   }

  load_balancer = {
    service = {
      target_group_arn = module.alb.target_groups["app_target_group"].arn
      container_name   = "app"
      container_port   = 3000
    }
  }

  subnet_ids       = module.vpc.public_subnets
  assign_public_ip = true
  security_group_rules = {
    alb_ingress_3000 = {
      description              = "Allow ALB to communicate with ECS on port 3000"
      type                     = "ingress"
      from_port                = 3000
      to_port                  = 3000
      protocol                 = "tcp"
      source_security_group_id = module.alb.security_group_id
    }
    egress_all = {
      description = "Allow all egress traffic"
      type        = "egress"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
}