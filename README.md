# private-isu-setup
## 注意
c6i.xlargeインスタンスとc6i.largeインスタンスが起動します。

## 各種リソースの作成
```shell
# terraform.tfvars.jsonにAWSのクレデンシャルを記載する
echo '{
  "access_key": "<AWS_ACCESS_KEY>",
  "secret_key": "<AWS_SECRET_KEY>"
}' > terraform.tfvars.json

# SSHキーを作成
ssh-keygen -f ~/.ssh/id_rsa.private_isu

# terraformを実行
docker run --rm -it -v $PWD:/work -v ~/.ssh:/.ssh -w /work hashicorp/terraform:1.3.6 init
docker run --rm -it -v $PWD:/work -v ~/.ssh:/.ssh -w /work hashicorp/terraform:1.3.6 apply

# 出力されたpublic_ipにアクセス(サーバー起動に少し時間がかかるので、少し待ってからアクセスする必要あり)
open "http://$(docker run --rm -it -v $PWD:/work -w /work hashicorp/terraform:1.3.6 output -raw public_ip)"
```

## インスタンスへのアクセス
### 1. 準備
```shell
docker build -t private-isu-setup-cli:latest -f cli/Dockerfile \
  --build-arg AWS_ACCESS_KEY_ID=$(cat terraform.tfvars.json | grep -o '"access_key": "[^"]*' | grep -o '[^"]*$') \
  --build-arg AWS_SECRET_ACCESS_KEY=$(cat terraform.tfvars.json | grep -o '"secret_key": "[^"]*' | grep -o '[^"]*$') .
```

### 2-a. 競技者用インスタンスへのアクセス
```shell
## SSM
docker run --rm -it private-isu-setup-cli:latest aws ssm start-session --document-name private-isu-admin \
  --target $(docker run --rm -it -v $PWD:/work -w /work hashicorp/terraform:1.3.6 output -raw private_isu_id)

sudo su - isucon

## SSH
ssh -i ~/.ssh/id_rsa.private_isu ubuntu@$(docker run --rm -it -v $PWD:/work -w /work hashicorp/terraform:1.3.6 output -raw public_ip)

sudo su - isucon
```

### 2-b. ベンチマーカー用インスタンスへのアクセス
```shell
docker run --rm -it private-isu-setup-cli:latest aws ssm start-session --document-name private-isu-admin \
  --target $(docker run --rm -it -v $PWD:/work -w /work hashicorp/terraform:1.3.6 output -raw benchmark_id)

sudo su - isucon
```

## 各種リソースの削除
```shell
docker run --rm -it -v $PWD:/work -w /work hashicorp/terraform:1.3.6 destroy
```
