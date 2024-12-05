#!/usr/bin/env bash
set -eu
#set -x
# -e: エラーが発生した時点でスクリプトを終了
# -u: 未定義の変数を使用した場合にエラーを発生
# -x: スクリプトの実行内容を表示(debugで利用)
# -o pipefail: パイプライン内のコマンドが失敗した場合にパイプライン全体を失敗として扱う

# Check using commands
required_commands=("jq" "yq" "envsubst" "curl")
missing_commands=()
for cmd in "${required_commands[@]}"; do
  if ! command -v "$cmd" &> /dev/null; then
    missing_commands+=("$cmd")
  fi
done
if [ ${#missing_commands[@]} -ne 0 ]; then
  echo "以下のコマンドが見つかりません。インストールしてください:"
  for cmd in "${missing_commands[@]}"; do
    echo "- $cmd"
  done
  exit 1
fi


#
# ISUNARABEのcloudformation.ymlを修正したCFnファイルをビルド
#
# INPUT1: cloudformation.template.yml
# INPUT2: cloudformation.yml # ISUNARABEからDLしたCFnファイル
# OUTPUT: tmp/cloudformation.yml
#
# したいこと: MyIPからのみ接続を許可する
#
export ENV_MY_IP="$(curl -s https://ipinfo.io/ip)/32"
export ENV_SETUP_TOKEN="$(cat cloudformation.yml | yq --input-format yaml --output-format json | jq -r '.Parameters.SetupToken.Default')"
envsubst '$ENV_MY_IP $ENV_SETUP_TOKEN' < cloudformation.template.yml > tmp/cloudformation.yml
