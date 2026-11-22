# local-gcp

## 起動手順

コンテナを起動します。

```bash
docker compose up -d
```

## gcloud コマンドの実行方法

`gcloud` コンテナ内でコマンドを実行します。

```bash
docker compose exec gcloud {gcloudコマンド}
```

## Terraform の実行方法

`terraform` コンテナは floci-gcp が healthy になってから起動し、`docker compose up` 時に [docker/terraform/run.sh](docker/terraform/run.sh) で `terraform init` と `terraform apply` を1回実行します。実行後もコンテナは起動したままです。
[terraform/main.tf](terraform/main.tf) は環境に依存しない記述だけを持ち、環境ごとの値は `terraform/env/<環境>/` に置きます。

| ファイル | 内容 |
|---|---|
| [terraform/env/docker/backend.hcl](terraform/env/docker/backend.hcl) | tfstate の保存先 (`terraform init -backend-config=...`) |
| [terraform/env/docker/terraform.tfvars](terraform/env/docker/terraform.tfvars) | プロジェクト、バケット名、floci-gcp への接続先 (`-var-file=...`) |

docker 環境では、これらは compose.yaml の `TF_CLI_ARGS_*` 環境変数で自動的に渡されます。
実環境を追加するときは `terraform/env/<環境>/` に同じ2ファイルを作り、エンドポイントとトークンは指定しません。

実行結果はログで確認できます。

```bash
docker compose logs terraform
```

`terraform/` は読み取り専用でマウントしています。tfstate と `.terraform` は名前付きボリューム `terraform-state`（実体は `local-gcp_terraform-state`）に出力されます。`docker compose down -v` でこのボリュームも削除されます。

追加の terraform コマンドは `docker compose exec` で実行できます。

```bash
docker compose exec terraform terraform plan
```

`init` と `apply` をもう一度実行する場合は、コンテナを再起動します。

```bash
docker compose restart terraform
```

`init` や `apply` が失敗するとコンテナは終了します（`docker compose ps -a` で `Exited (1)` になります）。`docker compose logs terraform` でエラーを確認してください。

作成したバケットは `docker compose exec gcloud gcloud storage ls` などで確認できます。

他のサービスをエミュレータで使う場合は、プロバイダ設定に対応する `*_custom_endpoint` を追加してください。
