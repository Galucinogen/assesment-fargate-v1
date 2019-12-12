##########
# Locals #
##########
locals {
  healthcheck = {
    command     = [ "CMD-SHELL", "curl -f http://localhost:8080/__healthcheck__ || exit 1" ]
    retries     = 3
    timeout     = 5
    interval    = 30
    startPeriod = 20
  }
}

##############
# Networking #
##############
module "networking" {
    source          = "cn-terraform/networking/aws"
    version         = "2.0.3"
    name_preffix    = var.name_preffix
    profile         = var.profile
    region          = var.region
    vpc_cidr_block  = "10.0.0.0/16"
    availability_zones                          = [ "us-east-1a", "us-east-1b", "us-east-1c", "us-east-1d" ]
    public_subnets_cidrs_per_availability_zone  = [ "10.0.0.0/19", "10.0.32.0/19", "10.0.64.0/19", "10.0.96.0/19" ]
    private_subnets_cidrs_per_availability_zone = [ "10.0.128.0/19", "10.0.160.0/19", "10.0.192.0/19", "10.0.224.0/19" ]
}

###########
# Fargate #
###########
module "ecs-cluster" {
    source  = "cn-terraform/ecs-cluster/aws"
    version = "1.0.2"
    name    = var.name_preffix
    profile = var.profile
    region  = var.region
}

module "ecs-task-definition" {
    source          = "cn-terraform/ecs-fargate-task-definition/aws"
    version         = "1.0.7"
    name_preffix    = var.name_preffix
    profile         = var.profile
    region          = var.region
    container_name  = var.container_name
    container_image = var.container_image
    container_port  = 900
}

module "ecs-fargate-service" {
    source              = "cn-terraform/ecs-fargate-service/aws"
    version             = "1.0.6"
    name_preffix        = var.name_preffix
    profile             = var.profile
    region              = var.region
    vpc_id              = module.networking.vpc_id
    task_definition_arn = module.ecs-task-definition.aws_ecs_task_definition_td_arn
    container_name      = var.container_name
    container_port      = module.ecs-task-definition.container_port
    ecs_cluster_name    = module.ecs-cluster.aws_ecs_cluster_cluster_name
    ecs_cluster_arn     = module.ecs-cluster.aws_ecs_cluster_cluster_arn
    private_subnets     = module.networking.private_subnets_ids
    public_subnets      = module.networking.public_subnets_ids
}

