#!/bin/sh
# docker compose up 時に terraform init / apply を1回実行し、
# その後は docker compose exec で追加のコマンドを受け付けられるよう待機する。
# init / apply が失敗した場合は、そのコマンドの終了コードでコンテナを終了する。

set -e

terraform init -input=false -lockfile=readonly
terraform apply -auto-approve -input=false

# docker compose stop / down で速やかに終了できるようにする
trap 'exit 0' TERM INT
tail -f /dev/null &
wait $!
