# Terraform AWS Infrastructure

このリポジトリは、AWSインフラストラクチャをTerraformで管理するためのコードを含んでいます。

## 構成

- VPC
- サブネット
- EC2インスタンス（Jupyter Notebook用）
- セキュリティグループ
- VPCエンドポイント（SSM接続用）
- IAMロール（SSM用）

## 前提条件

- Terraform >= 1.0
- AWS CLIがインストール済みで設定完了
- AWS認証情報の設定完了

## ディレクトリ構造

```
v1/
├── dev/
│   ├── vpc/
│   ├── subnet/
│   └── ec2/
```

## 使用方法

### tf.shを使用する場合

1. スクリプトに実行権限を付与：
```bash
chmod +x tf.sh
```

2. スクリプトを実行：
```bash
# 初期化
./tf.sh init

# 実行計画の確認
./tf.sh plan

# インフラの作成
./tf.sh apply

# インフラの削除
./tf.sh destroy
```

### 手動で実行する場合

各ディレクトリで以下のコマンドを順番に実行：

```bash
# 初期化
terraform init

# 実行計画の確認
terraform plan

# インフラの作成
terraform apply
```

## 注意事項

- `.terraform`ディレクトリはGitで管理されていません
- 本番環境では適切なIPレンジ制限を設定してください
