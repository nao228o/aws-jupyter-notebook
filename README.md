# aws-jupyter-notebook
AWSにJupyter Notebook環境を構築するためのTerraformコード

## 概要
このリポジトリには、AWSにJupyter Notebook環境を構築するためのTerraformの設定ファイルが含まれています。

## 構成
- EC2インスタンス (Amazon Linux 2)
- VPC、サブネット
- セキュリティグループ
- Systems Manager用のVPCエンドポイント
- IAMロール (Systems Manager接続用)

## 使用方法
1. このリポジトリをクローン
2. 必要に応じて`variables.tf`の値を編集
3. 以下のコマンドを実行:







