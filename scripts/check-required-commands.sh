#!/usr/bin/env bash
set -eu #set -x
# -e: エラーが発生した時点でスクリプトを終了
# -u: 未定義の変数を使用した場合にエラーを発生
# -x: スクリプトの実行内容を表示(debugで利用)

#
# 通知
#
echo '-------[ 🚀Check required commands🚀 ]'

#
# コマンドの有無チェック
#
required_commands=("alp" "pt-query-digest" "jq" "yq" "realpath" "aws" "aws-vault" "direnv")
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
# 通知
#
echo '----'
echo '👍️Done: 必要なコマンドは全て入っています'
echo '----'

