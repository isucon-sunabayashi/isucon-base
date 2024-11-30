#!/usr/bin/env bash
set -eu
#set -x
# -e: エラーが発生した時点でスクリプトを終了
# -u: 未定義の変数を使用した場合にエラーを発生
# -x: スクリプトの実行内容を表示(debugで利用)

#
# 通知
#
echo '-------[ 🚀writeout-imageディレクトリを置きます🚀 ]'

#
# writeout-image ディレクトリをコピー
#
while read server; do
  dir_path="${server}/home/isucon/one-shot-scripts/writeout-images"
  if [ -d ${dir_path} ]; then
    echo "${dir_path} は既に有ります"
  else
    mkdir -p ${dir_path}
    cp -rf snippets/writeout-image/* ${dir_path}/
  fi
done < <(cat tmp/isu-servers)

#
# 通知
#
echo '----'
echo '👍️Done: one-shot-scripts/writeout-imageディレクトリを置きました'
echo 'make deploy-one-time-scriptsをしてください)'
echo '----'
