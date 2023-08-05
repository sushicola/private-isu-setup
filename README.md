# private-isu-setup
## Setup
```shell
# terraform.tfvars.jsonにAWSのクレデンシャルを記載する
echo '{
  "access_key": "<AWS_ACCESS_KEY>",
  "secret_key": "<AWS_SECRET_KEY>"
}' > terraform.tfvars.json

# terraformを実行
docker run --rm -it -v $PWD:/work -w /work hashicorp/terraform:1.3.6 init
docker run --rm -it -v $PWD:/work -w /work hashicorp/terraform:1.3.6 apply

# 出力されたpublic_ipにアクセス(サーバー起動に少し時間がかかるので、少し待ってからアクセスする必要あり)
open "http://$(docker run --rm -it -v $PWD:/work -w /work hashicorp/terraform:1.3.6 output -raw public_ip)"
```

## Access to EC2
```shell
# ローカルにjqが入ってなければ入れる(`brew install jq`)
docker build -t private-isu-setup-cli:latest -f cli/Dockerfile --build-arg AWS_ACCESS_KEY_ID=$(cat terraform.tfvars.json | jq -r .access_key) --build-arg AWS_SECRET_ACCESS_KEY=$(cat terraform.tfvars.json | jq -r .secret_key) .
docker run --rm -it private-isu-setup-cli:latest aws ssm start-session --target $(docker run --rm -it -v $PWD:/work -w /work hashicorp/terraform:1.3.6 output -raw instance_id) --document-name private-isu-admin
sudo su --login 
```

## Destroy
```shell
docker run --rm -it -v $PWD:/work -w /work hashicorp/terraform:1.3.6 destroy
```
