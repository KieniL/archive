provider "aws" {
  region = "eu-central-1"
}

# Create a VPC
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true
  instance_tenancy = "default"
  tags = {
    project = "BA"
  }
}

#Create a Subnet
resource "aws_subnet" "main" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = true
  tags ={
    project = "BA"
  }
}

#Create an Internet Gateway
resource "aws_internet_gateway" "main" {
 vpc_id = aws_vpc.main.id
}

#Create a Route Table
resource "aws_route_table" "main" {
  vpc_id = aws_vpc.main.id
  tags = {
    project = "BA"
  }
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id 
  }
}

resource "aws_route_table_association" "main" {
  subnet_id      = aws_subnet.main.id
  route_table_id = aws_route_table.main.id
}


# Create the WebSecurityGroup
resource "aws_security_group" "main" {
  name = "WebServerSecurityGroup"
  description = "Allow http connection from client"
  vpc_id = aws_vpc.main.id
  tags = {
    project = "BA"
  }
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["62.178.238.153/32"]    
  }
}

# Create a Role

resource "aws_iam_role" "main" {
  name = "webserverrole"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

  tags = {
    project = "BA"
  }
}
resource "aws_iam_policy" "policy" {
  name        = "test-policy"
  description = "A test policy"
  policy = <<EOF
{
                            "Version": "2012-10-17",
                            "Statement": [
                                {
                                    "Action": [
                                        "logs:CreateLogStream",
                                        "logs:DescribeLogStreams",
                                        "logs:PutLogEvents"
                                    ],
                                    "Effect": "Allow",
                                    "Resource": "arn:aws:logs:eu-central-1:680785598240:log-group:ssmlog:*"
                                },
                                {
                                    "Action": [
                                        "logs:CreateLogGroup",
                                        "logs:DescribeLogGroups"
                                    ],
                                    "Effect": "Allow",
                                    "Resource": "arn:aws:logs:eu-central-1:680785598240:log-group:*"
                                }
                            ]
                        
}
EOF
}

resource "aws_iam_policy_attachment" "test-attach" {
  name       = "test-attachment"
  roles      = [aws_iam_role.main.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

#Create iam plicy
resource "aws_iam_policy_attachment" "main" {
  name = "embedpolicy"
  roles = [aws_iam_role.main.name]
  policy_arn = aws_iam_policy.policy.arn
}

#Create instance profile
resource "aws_iam_instance_profile" "main" {
 name = "ssmprofile"
 role = aws_iam_role.main.name
}

#Create a S3 Bucket
resource "aws_s3_bucket" "main" {
  bucket = "webserverbucket-kienast"
  tags = {
   project = "BA"
  }
  server_side_encryption_configuration {
   rule {
     apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
     }
   }
  }
  policy = <<EOF
{
                    "Statement": [
                        {
                            "Effect": "Allow",
                            "Principal": {
                                "AWS": "arn:aws:iam::680785598240:role/webserverrole"
                            },
                            "Action": [
                                "s3:ListBucket"
                            ],
                            "Resource": "arn:aws:s3:::webserverbucket-kienast"
                        },
                        {
                            "Effect": "Allow",
                            "Principal": {
                                "AWS": "arn:aws:iam::680785598240:role/webserverrole"
                            },
                            "Action": [
                                "s3:GetObject",
                                "s3:PutObject"
                            ],
                            "Resource": "arn:aws:s3:::webserverbucket-kienast/*"
                        }
                    ]
                }
  EOF
}

#create Server
resource "aws_instance" "main" {
  ami = "ami-0b418580298265d5c"
  iam_instance_profile = aws_iam_instance_profile.main.name
  subnet_id = aws_subnet.main.id
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.main.id]
  tags = {
    project = "BA"
  }
  user_data = <<EOF
#/bin/sh
sudo apt-get update && sudo apt-get install -y apache2
sudo service apache2 start
echo "<html><body><h1>Awesome !!!</h1>" > /var/www/html/index.html
echo "</body></html>" >> /var/www/html/index.html
sudo service apache2 reload
EOF
}
