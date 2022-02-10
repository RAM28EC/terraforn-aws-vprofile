resource "aws_security_group" "vprofile-bean-elb-sg" {
  name = "vprofile-bean-elb-sg"
  description = "security group for bean-elb"
  vpc_id = module.vpc.vpc_id
  egress {
    from_port = 0
    protocol  = "-1"
    to_port   = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 80
    protocol  = "tcp"
    to_port   = 80
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_security_group" "vprofile-bastion-sg" {
  name = "vprofile-bastion-sg"
  description = "Security group for bastionres ec2 instance"
  vpc_id = module.vpc.vpc_id
  egress {
    from_port = 0
    protocol  = "-1"
    to_port   = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 22
    protocol  = "tcp"
    to_port   = 22
    cidr_blocks = [var.MYIP]
  }
}
resource "aws_security_group" "vprofile-prod-sg" {
  name = "vprofile-prod-sg"
  description = "Security group for beanstalk instance"
  vpc_id = module.vpc.vpc_id
  egress {
    from_port = 0
    protocol  = "-1"
    to_port   = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 22
    protocol  = "tcp"
    to_port   = 22
    security_groups = [aws_security_group.vprofile-bastion-sg.id]
  }
}
resource "aws_security_group" "vprofile-backend-sg" {
  name        = "vprofile-backend-sg"
  description = "security group for RDS,activemq,elastic cache"
  vpc_id      = module.vpc.vpc_id
  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port       = 0
    protocol        = "-1"
    to_port         = 0
    security_groups = [aws_security_group.vprofile-prod-sg.id]
  }
  ingress {
    from_port = 3306
    protocol  = "tcp"
    to_port   = 3306
    security_groups = [aws_security_group.vprofile-bastion-sg.id]
  }
}
resource "aws_security_group_rule" "sec_group_allow_itself" {
  from_port         = 0
  protocol          = ""
  security_group_id = aws_security_group.vprofile-backend-sg.id
  source_security_group_id = aws_security_group.vprofile-backend-sg.id
  to_port           = 65535
  type              = "ingress"
}