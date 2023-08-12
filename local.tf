locals {
  app_name = "private-isu"
  region = "ap-northeast-1"
  ami = "ami-0676c829e30e00846" // https://github.com/catatsuy/private-isu
  benchmark_ami = "ami-0582a2a7fbe79a30d" // https://github.com/catatsuy/private-isu
  instance_type = "c6i.large"
  benchmark_instance_type = "c6i.xlarge"
}
