module "eks" {
  source = "terraform-aws-modules/eks/aws"

  cluster_name     = "${var.application_name}-eks"
  cluster_version  = "1.21"
  subnets          = module.vpc.private_subnets
  vpc_id           = module.vpc.vpc_id
  write_kubeconfig = false
  manage_aws_auth  = false

  cluster_enabled_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]

  node_groups_defaults = {
    desired_capacity = 1
    min_capacity     = 1
    max_capacity     = 20
    capacity_type    = "SPOT"
  }

  node_groups = [
    {
      name           = "${var.application_name}-worker-spot-1"
      instance_types = [var.eks_primary_instance_type]
      additional_tags = merge({
        Name = "${var.application_name}-worker-spot-1"
      }, local.common_tags)
    },

    {
      name           = "${var.application_name}-worker-spot-2"
      instance_types = [var.eks_primary_instance_type]
      additional_tags = merge({
        Name = "${var.application_name}-worker-spot-2"
      }, local.common_tags)
    }
  ]

  worker_create_security_group  = false
  cluster_create_security_group = false
}