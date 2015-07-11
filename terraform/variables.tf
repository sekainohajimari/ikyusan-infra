variable "key_path" {
  default = "~/.ssh/sekahama.pem"
}
variable "ssh_key_name" {
  default = "sekahama"
}
variable "ami" {
  default = "ami-6a60b76a"
}
variable "instance_type" {
  default = "t2.micro"
}
variable "subnet" {
  default = "subnet-d29830a5"
}
variable "name" {
  default = "ikyusan-api"
}
variable "env" {
  default = "production"
}
variable "az" {
  default = "ap-northeast-1a"
}
variable "vpc_security_group_id" {
  default = "sg-f1168b94"
}
