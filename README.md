# private-isu-setup
## Note
c5.largeインスタンスが起動します。

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
docker build -t private-isu-setup-cli:latest -f cli/Dockerfile \
  --build-arg AWS_ACCESS_KEY_ID=$(cat terraform.tfvars.json | grep -o '"access_key": "[^"]*' | grep -o '[^"]*$') \
  --build-arg AWS_SECRET_ACCESS_KEY=$(cat terraform.tfvars.json | grep -o '"secret_key": "[^"]*' | grep -o '[^"]*$') .

docker run --rm -it private-isu-setup-cli:latest aws ssm start-session --document-name private-isu-admin \
  --target $(docker run --rm -it -v $PWD:/work -w /work hashicorp/terraform:1.3.6 output -raw instance_id)

# rootに切り替える
sudo su --login
```

## Destroy
```shell
docker run --rm -it -v $PWD:/work -w /work hashicorp/terraform:1.3.6 destroy
```
