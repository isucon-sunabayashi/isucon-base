#!/usr/bin/env bash
set -eu
#set -x
# -e: エラーが発生した時点でスクリプトを終了
# -u: 未定義の変数を使用した場合にエラーを発生
# -x: スクリプトの実行内容を表示(debugで利用)

#
# OUTPUT:
# - tmp/hosts.csv                     // host名、IPアドレスのCSV
# - tmp/isu-servers                   // benchを除いたhost名のリスト
#

#
# AWS CLIが上手く接続できるか確認
#
aws-vault exec main -- aws sts get-caller-identity || exit 1

#
# tmp/hosts.csvを作成
#
aws-vault exec main -- aws ec2 describe-instances --filters 'Name=instance-state-name,Values=running' --output json --query 'Reservations[].Instances[]' \
  | jq -rc '.[] | {ip: .NetworkInterfaces[0].Association.PublicIp, name: .Tags[] | select(.Key == "Name") | .Value}' \
  | jq -src '. | sort_by(.name)[] | ["isu-\(.name | split("-")[1])", .ip] | @csv' \
  | sed 's/"//g' \
  > tmp/hosts.csv
