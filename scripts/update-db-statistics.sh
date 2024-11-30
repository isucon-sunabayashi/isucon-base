#!/usr/bin/env bash
set -eu
#set -x
# -e: エラーが発生した時点でスクリプトを終了
# -u: 未定義の変数を使用した場合にエラーを発生
# -x: スクリプトの実行内容を表示(debugで利用)

#
# 通知
#
echo '-------[ 🚀各テーブルの統計情報を更新します🚀 ]'



#
# 各テーブルのテーブルのCOUNT
#
#cat tmp/db-tables | grep -v '^DB'
while read -r server; do
  echo "----[ ${server} ]"
  while read -r db table; do
    sql="ANALYZE TABLE ${db}.${table};"
    echo "${sql}"
    ssh -n ${server} "sudo mysql -e \"${sql}\""
    echo "--"
  done < <(cat tmp/db-tables | grep -v '^DB')
done < <(cat tmp/isu-servers)

#
# 通知
#
echo '----'
echo '👍️Done: 各テーブルの統計情報を更新'
echo '----'
