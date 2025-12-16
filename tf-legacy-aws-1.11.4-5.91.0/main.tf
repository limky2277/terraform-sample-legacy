# Data source to get the most recent Ubuntu AMI
data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
  owners = ["099720109477"] # Canonical owner ID for Ubuntu AMIs
}

# Resource to create an EC2 instance
resource "aws_instance" "app_server" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro" # t2.micro is eligible for the AWS Free Tier

  tags = {
    Name = "ExampleAppServer"
  }
}

resource "aws_simpledb_domain" "users" {
  name = "users_domain"
}

resource "aws_opsworks_application" "foo-app" {
  name        = "foobar application"
  short_name  = "foobar"
  stack_id    = aws_opsworks_stack.main.id
  type        = "rails"
  description = "This is a Rails application"

  domains = [
    "example.com",
    "sub.example.com",
  ]

  environment {
    key    = "key"
    value  = "value"
    secure = false
  }

  app_source {
    type     = "git"
    revision = "master"
    url      = "https://github.com/example.git"
  }

  enable_ssl = true

  ssl_configuration {
    private_key = file("./foobar.key")
    certificate = file("./foobar.crt")
  }

  document_root         = "public"
  auto_bundle_on_deploy = true
  rails_env             = "staging"
}

resource "aws_redshift_cluster" "example" {
  cluster_identifier = "tf-redshift-cluster"
  database_name      = "mydb"
  master_username    = "exampleuser"
  node_type          = "dc1.large"
  cluster_type       = "single-node"

  manage_master_password = true
  snapshot_copy = true
}

# Request a spot instance at $0.03
resource "aws_spot_instance_request" "cheap_worker" {
  ami           = "ami-1234"
  spot_price    = "0.03"
  instance_type = "c4.xlarge"

  block_duration_minutes = "60"

  tags = {
    Name = "CheapWorker"
  }
}