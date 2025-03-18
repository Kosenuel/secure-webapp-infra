output "vpc_id" {
  value = aws_vpc.main.id
}

output "priv_sub1" {
  value = aws_subnet.private_subnet_az1.id
}

output "priv_sub2" {
  value = aws_subnet.private_subnet_az2.id
}

