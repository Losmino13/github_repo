resource "aws_key_pair" "webserver_kep_pair" {
  key_name   = "ws-ssh-key"
  public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBO7G/DoqMlZwYiRWFgkybpFvuJAkqT9BawfkTRCWMqE milisavljevic.milos@yahoo.com"
}

resource "aws_instance" "web1" {
  ami                    = "ami-08ca3fed11864d6bb"
  instance_type          = "t2.micro"
  availability_zone      = "eu-west-1a"
  user_data              = file("../shell/install_app.sh")
  subnet_id              = aws_subnet.web_subnet_1.id
  vpc_security_group_ids = [aws_security_group.webserver_sg.id]
  key_name               = "ws-ssh-key"
  tags = {
    Name        = "Web Server 1"
    Description = "Test instance"
    CostCenter  = "123456"
  }
}

resource "aws_instance" "web2" {
  ami                    = "ami-08ca3fed11864d6bb"
  instance_type          = "t2.micro"
  availability_zone      = "eu-west-1b"
  user_data              = file("../shell/install_app.sh")
  subnet_id              = aws_subnet.web_subnet_2.id
  vpc_security_group_ids = [aws_security_group.webserver_sg.id]
  key_name               = "ws-ssh-key"

  tags = {
    Name = "Web Server 2"
  }
}
