variable "region" {
  default     = "ap-southeast-1"
  type        = string
  description = "AWS region for the Nextcloud app"
}

variable "availability_zone" {
  type        = string
  description = "AZ to deploy the Nextcloud app"
}

variable "vpc_cidr" {
  default     = "10.0.0.0/16"
  type        = string
  description = "CIDR for VPC"
}

variable "ami" {
  type        = string
  description = "AMI that will be used for EC2 instance"
}

variable "instance_type" {
  default     = "t2.micro"
  type        = string
  description = "EC2 instance type to deploy"
}

variable "bucket_name" {
  type        = string
  description = "S3 storage's bucket name for the Nextcloud app"
}

variable "database_name" {
  type        = string
  description = "MariaDB database name for the Nextcloud app"
}

variable "database_user" {
  type        = string
  description = "MariaDB database username for the Nextcloud app"
  sensitive   = true
}

variable "database_pass" {
  type        = string
  description = "MariaDB database password for the Nextcloud app"
  sensitive   = true
}

variable "admin_user" {
  type        = string
  description = "Nextcloud app admin's username"
  sensitive   = true
}

variable "admin_pass" {
  type        = string
  description = "Nextcloud app admin's password"
  sensitive   = true
}
