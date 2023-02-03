#---root/main.tf---

module "compute" {
  source         = "./compute"
  alb_tg         = module.load_balancer.alb_tg
  elb            = module.load_balancer.elb
  key_name       = "wk22_project"
  public_sg      = module.networking.public_sg
  public_subnet  = module.networking.public_subnet
  private_sg     = module.networking.private_sg
  private_subnet = module.networking.private_subnet
}

module "load_balancer" {
    source = "./load_balancer"
    asg_database = module.compute.asg_database
    public_subnet = module.networking.public_subnet
    web_sg = module.networking.web_sg
    vpc_id = module.networking.vpc_id
}

module "networking" {
    source = "./networking"
    access_ip = var.access_ip
    private_cidrs = ["10.0.1.0/24", "10.0.3.0/24", "10.0.5.0/24"]
    public_cidrs = ["10.0.2.0/24", "10.0.4.0/24", "10.0.6.0/24"]
    vpc_cidr = "10.0.0.0/16"
}