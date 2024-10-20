#!/usr/bin/env bash
set -eu
#set -x
# -e: エラーが発生した時点でスクリプトを終了
# -u: 未定義の変数を使用した場合にエラーを発生
# -x: スクリプトの実行内容を表示(debugで利用)

#
# 通知
#
echo '-------[ 🚀Show services🚀 ]'

#
# DBテーブル一覧
#
readonly SQL="select table_schema as DB, table_name from information_schema.tables where table_schema like '%isu%' order by table_schema;"
cat tmp/isu-servers | head -n1 | xargs -I{} ssh {} "sudo mysql -e \"${SQL}\"" | tee tmp/db-tables

#
# 各テーブルのテーブルのCOUNT
#
#cat tmp/db-tables | grep -v '^DB'
while read -r server; do
  echo "----[ ${server} ]"
  while read -r db table; do
    ssh -n ${server} "sudo mysql -e \"select '${db}.${table}', count(1) from ${db}.${table};\" | tail -n1"
  done < <(cat tmp/db-tables | grep -v '^DB')
done < <(cat tmp/isu-servers)
