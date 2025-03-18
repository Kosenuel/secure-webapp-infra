# Create Security Group for Webapp Server
resource "aws_security_group" "webapp_sg" {
    name        = "webapp-sg"
    description = "Allow outbound to SFTP server only"
    vpc_id      = var.vpc_id
    
    egress {
        from_port   = 22 # SSH for SFTP
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["10.0.0.0/16"] # Allow outbound to the entire VPC CIDR for SFTP server
    }

    tags = {
        Name = "webapp-sg"
    }
}


# Create Security Group for SFTP Server
resource "aws_security_group" "sftp_sg" {
    name        = "sftp-sg"
    description = "Allow inbound from Webapp and Lambda function"
    vpc_id      = var.vpc_id

    ingress {
        from_port       = 22 # SSH for SFTP
        to_port         = 22 
        protocol        = "tcp"
        security_groups = [aws_security_group.webapp_sg.id]
    }

    # Allow inbound from Lambda function's security group
    ingress {
        from_port       = 22 # SSH for SFTP
        to_port         = 22
        protocol        = "tcp"
        security_groups = [aws_security_group.lambda_sg.id] 
    }

    tags = merge(
        var.tags,
        {
        Name = "sftp-sg"
        }
    )

}

# Create Security Group for Lambda Functions
resource "aws_security_group" "lambda_sg" {
    name        = "lambda-sg"
    description = "Allow outband to SFTP and S3"
    vpc_id      = var.vpc_id

    # Allow outbound to SFTP server
    egress {
        from_port   = 22 # SSH for SFTP
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["10.0.0.0/16"] # Allow outbound to the entire VPC CIDR for SFTP server comms
    }

    # Allow outbound to S3 (HTTPS)
    egress {
        from_port       = 443
        to_port         = 443
        protocol        = "tcp"
        cidr_blocks     = ["0.0.0.0/0"] # To allow traffic to S3 (I allowed to all internet cos I don't know the specific IP for the yet-to-be-created s3 bucket)
    }

    # Allow outbound for all protocols and ports within the VPC for flexibility if needed by Lambda
    egress {
        from_port       = 0
        to_port         = 0
        protocol        = "-1" # Allow all protocols
        cidr_blocks     = ["10.0.0.0/16"] # Allow outbound to the SFTP&Secure-web-app VPC
    }

    tags = merge(
        var.tags,
        {
            Name = "lambda-sg"
        }
    )
}

# Create Security Groups for the Public Subnet Resources (for testing purposes)
resource "aws_security_group" "public_sg" {
    name        = "public-sg"
    description = "Allow inbound HTTP and SSH traffic"
    vpc_id      = var.vpc_id

    ingress {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = merge(
        var.tags,
    {
        Name = "Public Security Group"
    }
    )
}