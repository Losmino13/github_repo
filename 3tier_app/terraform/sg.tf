# Create Web Security Group
resource "aws_security_group" "web_sg" {
  name        = "Web-SG"
  description = "Allow HTTP inbound ALB"
  vpc_id      = aws_vpc.three_tier_vpc.id

  ingress {
    description = "HTTP from internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Web-SG"
  }
}

resource "aws_security_group" "webserver_sg" {
  name        = "WebSrever-SG"
  description = "Allow HTTP inbound ALB to Web servers"
  vpc_id      = aws_vpc.three_tier_vpc.id

  ingress {
    description     = "HTTP from LoadBalancer"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.web_sg.id]
  }

  ingress {
    description = "SSH from my IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["87.116.191.219/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "WebServer-SG"
  }
}


resource "aws_security_group" "database_sg" {
  name        = "Database-SG"
  description = "Allow webserver trafic to db"
  vpc_id      = aws_vpc.three_tier_vpc.id

  ingress {
    description     = "DB from WebServers"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.webserver_sg.id]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Database-SG"
  }
}