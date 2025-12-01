# Terraform: Deploy EC2 with New or Existing Security Group in Mumbai (ap-south-1) Region

# 🔄 USING NEW SECURITY GROUP

Create ec2-new-sg.tf:

## Step 1: Set AWS Credentials

```bash
export AWS_ACCESS_KEY_ID="YOUR_ACCESS_KEY"
export AWS_SECRET_ACCESS_KEY="YOUR_SECRET_KEY"
export AWS_DEFAULT_REGION="ap-south-1"
```

## Step 2: Create Terraform File

Create ec2-new-sg.tf:

```bash
provider "aws" {
  region = "ap-south-1"
}

resource "aws_security_group" "ec2_sg" {
  name        = "my-ec2-sg"
  description = "Allow HTTP, HTTPS, SSH"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "web_server" {
  ami                    = "ami-0d176f79571d18a8f"  # Ubuntu 20.04 Mumbai
  instance_type          = "t2.micro"
  key_name               = "Mumbai_server_key"      # Change to your key name
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]

  tags = {
    Name = "My-Terraform-EC2"
  }
}

output "public_ip" {
  value = aws_instance.web_server.public_ip
}
```

## Step 3: Initialize & Deploy

``` bash
# 1. Initialize Terraform
terraform init

# 2. Preview what will be created
terraform plan

# 3. Deploy everything (type 'yes' when prompted)
terraform apply

# OR deploy without confirmation
terraform apply -auto-approve
```

# 🌐 ALTERNATIVE SETUP

# 🔄 USING EXISTING SECURITY GROUP

Create ec2-existing-sg.tf:

## Step 1: Create Terraform File

```bash
provider "aws" {
  region = "ap-south-1"
}

resource "aws_instance" "web_server" {
  ami                    = "ami-0d176f79571d18a8f"
  instance_type          = "t2.micro"
  key_name               = "Mumbai_server_key"
  
  # Replace with your existing security group ID
  vpc_security_group_ids = ["sg-xxxxxxxxxxxxxxxxx"]

  tags = {
    Name = "My-EC2-With-Existing-SG"
  }
}
```

## Step 2: Initialize & Deploy

``` bash
# 1. Initialize Terraform
terraform init

# 2. Preview what will be created
terraform plan

# 3. Deploy everything (type 'yes' when prompted)
terraform apply

# OR deploy without confirmation
terraform apply -auto-approve
```

# ⚡ TROUBLESHOOTING COMMANDS

```bash
# Fix permission denied

chmod 400 ~/.ssh/your-key.pem

# Check instance status

aws ec2 describe-instances --query "Reservations[*].Instances[*].{ID:InstanceId,State:State.Name,IP:PublicIpAddress}" --output table

# Get current AMI ID for Ubuntu 22.04 in Mumbai

aws ec2 describe-images --owners 099720109477 --filters "Name=name,Values=ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*" --query 'sort_by[Images, &CreationDate](-1).ImageId' --region ap-south-1 --output text
```

# 🗂️ PROJECT STRUCTURE

```bash
terraform-ec2/
├── ec2-new-sg.tf          # Main file (use this first)
├── ec2-existing-sg.tf     # Use existing security group
├── .gitignore            # Prevent committing secrets
└── README.md             # This guide
📌 .gitignore FILE
Create .gitignore and paste:
```

# Terraform files

*.tfstate
*.tfstate.backup
.terraform/
*EC2_Using_Existing_SG.tf
*EC2_Using_New_SG.tf

# AWS credentials

*.pem
*.key
*.secret

# Step 🎯 VARIABLES FILE (Optional)

Create variables.tf:

```bash
variable "region" {
  default = "ap-south-1"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "key_name" {
  description = "Name of your AWS key pair"
  type        = string
}
```

# ⚙️ ADDITIONAL TERRAFORM COMMANDS

```bash
# Show all Terraform commands
terraform -help

# Format your Terraform code
terraform fmt

# Validate syntax
terraform validate

# View outputs
terraform output

# Refresh state from AWS
terraform refresh
```

### Remember: Always run terraform destroy when done testing

  to avoid unnecessary charges!
  
  ``` bash
  terraform destroy -auto-approve
  ```

# Created by Rushikesh Panchal
