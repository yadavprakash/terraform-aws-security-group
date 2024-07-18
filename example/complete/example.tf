provider "aws" {
  region = "eu-west-1"
}

locals {
  name        = "app11"
  environment = "test"
}

##-----------------------------------------------------------------------------
## VPC Module Call.
##-----------------------------------------------------------------------------
module "vpc" {
  source      = "git::git@github.com:yadavprakash/terraform-aws-vpc.git?ref=v1.0.0"
  name        = "appdd"
  environment = "test"
  cidr_block  = "10.0.0.0/16"
}

##-----------------------------------------------------------------------------
## Security Group Module Call.
##-----------------------------------------------------------------------------
module "security_group" {
  source      = "./../../"
  name        = local.name
  environment = local.environment
  vpc_id      = module.vpc.id

  ## INGRESS Rules
  new_sg_ingress_rules_with_cidr_blocks = [{
    rule_count  = 1
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["172.16.0.0/16"]
    description = "Allow ssh traffic."
    },
    {
      rule_count  = 2
      from_port   = 27017
      to_port     = 27017
      protocol    = "tcp"
      cidr_blocks = ["172.16.0.0/16"]
      description = "Allow Mongodb traffic."
    }
  ]

  new_sg_ingress_rules_with_self = [{
    rule_count  = 1
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    description = "Allow ssh traffic."
    },
    {
      rule_count  = 2
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      description = "Allow Mongodbn traffic."
    }
  ]

  new_sg_ingress_rules_with_source_sg_id = [{
    rule_count               = 1
    from_port                = 22
    to_port                  = 22
    protocol                 = "tcp"
    source_security_group_id = "sg-0f251332b1474ba77"
    description              = "Allow ssh traffic."
    },
    {
      rule_count               = 2
      from_port                = 27017
      to_port                  = 27017
      protocol                 = "tcp"
      source_security_group_id = "sg-0f251332b1474ba77"
      description              = "Allow Mongodb traffic."
  }]

  ## EGRESS Rules
  new_sg_egress_rules_with_cidr_blocks = [{
    rule_count  = 1
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [module.vpc.vpc_cidr_block, "172.16.0.0/16"]
    description = "Allow ssh outbound traffic."
    },
    {
      rule_count  = 2
      from_port   = 27017
      to_port     = 27017
      protocol    = "tcp"
      cidr_blocks = ["172.16.0.0/16"]
      description = "Allow Mongodb outbound traffic."
    }
  ]

  new_sg_egress_rules_with_self = [{
    rule_count  = 1
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    description = "Allow ssh outbound traffic."
    },
    {
      rule_count  = 2
      from_port   = 27017
      to_port     = 27017
      protocol    = "tcp"
      description = "Allow Mongodb traffic."
  }]

  new_sg_egress_rules_with_source_sg_id = [{
    rule_count               = 1
    from_port                = 22
    to_port                  = 22
    protocol                 = "tcp"
    source_security_group_id = "sg-0f251332b1474ba77"
    description              = "Allow ssh outbound traffic."
    },
    {
      rule_count               = 2
      from_port                = 27017
      to_port                  = 27017
      protocol                 = "tcp"
      source_security_group_id = "sg-0f251332b1474ba77"
      description              = "Allow Mongodb traffic."
  }]
}

