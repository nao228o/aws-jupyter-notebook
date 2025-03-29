# aws-jupyter-notebook
AWSにJupyter Notebook環境を構築するためのTerraformコード

## 概要
このリポジトリには、AWSにJupyter Notebook環境を構築するためのTerraformの設定ファイルが含まれています。

## 構成
- EC2インスタンス (Amazon Linux 2023)
- VPC、サブネット
- セキュリティグループ
- Systems Manager用のVPCエンドポイント
- IAMロール (Systems Manager接続用)

## 使用方法
1. このリポジトリをクローン
2. 必要に応じて`variables.tf`の値を編集
3. 以下のコマンドを実行:
```bash
terraform init
terraform plan
terraform apply
```
4. EC2に接続して、以下のコマンドを実行
```bash
# システムの更新
sudo dnf update -y

# Pythonと必要なパッケージのインストール
sudo dnf install -y python3-pip python3-devel

# pipのアップグレード
python3 -m pip install --upgrade pip

# Jupyterのインストール
python3 -m pip install jupyter

# パスを通す（必要な場合）
export PATH="$HOME/.local/bin:$PATH"

# 現在のシェルセッションでパスを反映
source ~/.bashrc

#jupyter notebookのworkspaceを作成し、その場所に移動
sudo mkdir workspace
sudo chown ssm-user:ssm-user workspace
cd workspace

# Jupyterを起動
jupyter notebook --ip=0.0.0.0 --no-browser --port=8888
```





