resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "db-subnets"
  subnet_ids = [aws_subnet.db_subnet_1.id, aws_subnet.db_subnet_2.id]

  tags = {
    Name = "My DB subnet group"
  }
}


resource "aws_db_instance" "three_tier_db" {
  allocated_storage      = 10
  db_subnet_group_name   = aws_db_subnet_group.db_subnet_group.id
  engine                 = "mysql"
  engine_version         = "8.0.27"
  instance_class         = "db.t2.micro"
  multi_az               = false
  name                   = "threetierdb"
  username               = "threetieruser"
  password               = "three_tier_pwd"
  skip_final_snapshot    = true
  vpc_security_group_ids = [aws_security_group.database_sg.id]
}