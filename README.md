# aws-ec2-postgresql

🦬🦬🦬 AWS上でEC2とPostreSQLを構築するためのTerraformの設定ファイルです。  
以下のリソースから構成されています。  

* VPC
* Subnet
* Internet Gateway
* Route Table
* Security Group
* EC2
* RDS(PostgreSQL)

## 環境情報

| Name | Version |
| ---- | ---- |
| terraform | v1.3.7 |
| AWS CLI | 2.9.17 |

## 実行方法

`terraform`ディレクトリに移動します。  
`terraform.tfvars.example`をコピーして`terraform.tfvars`を作成し、適切な値を設定してください。  
次に、以下のコマンドを実行して、リソースを作成します。  

```shell
terraform init
terraform plan
terraform apply
```

リソースを削除する場合は以下のコマンドを実行してください。  

```shell
terraform destroy
```

## その他イロイロ

ファイアウォールルールは以下の通りです。  

* インバウンド通信はSSH(22)・HTTP(80)・HTTPS(443)のみ許可
* SSHは自分のIPアドレスのみ許可
* アウトバウンド通信は全て許可

DBへのアクセスは、インターネットとEC2インスタンスから許可しています。  
インターネットからのアクセスはテストのためです。  
`.tf`ファイル内の`// DBマイグレーション用`とコメントアウトされている箇所を修正して、インターネットアクセスを禁止して、EC2からのみアクセスを許可することもできます。  

## 各種設定

### Terraform

[公式サイト](https://developer.hashicorp.com/terraform/downloads)にそって、Terraformをダウンロードしてください。  
インストール後は、以下のコマンドを実行して、Terraformのバージョンを確認してください。  

```shell
terraform version
```

正しくインストールされていない場合には、パスが通っていない可能性があります。  
パスが通っていない場合は、以下のコマンドを実行して、パスを通してください。  

```shell
# Windows
$env:PATH += ";C:/★パス★"

# Unix系
export PATH=$PATH:/★パス★
```

### AWS CLI

[公式サイト](https://docs.aws.amazon.com/ja_jp/cli/latest/userguide/getting-started-install.html)にそって、AWS CLIをインストールしてください。  

インストール後は、以下のコマンドを実行して、AWSのアクセスキーとシークレットキーを設定してください。  

```shell
aws configure
```

必要な情報は以下の通りです。  

* AWS Access Key ID
* AWS Secret Access Key

AWSのアクセスキーとシークレットキーは、AWSのマネジメントコンソールから取得します。  
マネジメントコンソールにログインし、右上のアカウント名をクリックします。  
その後、マイセキュリティ資格情報をクリックします。  

左のメニューに表示されているユーザをクリックします。  
その後、対象のユーザを選択します。  
ユーザがない場合は、ユーザを作成します。  

ユーザを選択したら、アクセスキーを作成します。  
アクセスキーを作成すると、アクセスキーIDとシークレットアクセスキーが表示されます。  
アクセスキーIDとシークレットアクセスキーは、AWS CLIの設定に使用します。  
