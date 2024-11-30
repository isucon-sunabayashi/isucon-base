#!/usr/bin/env bash
set -eu
#set -x
# -e: エラーが発生した時点でスクリプトを終了
# -u: 未定義の変数を使用した場合にエラーを発生
# -x: スクリプトの実行内容を表示(debugで利用)

#
# 通知
#
echo '-------[ 🚀tmp/db-tablesの作成(上書き)🚀 ]'

#
# DBテーブル一覧
# 以下の既存table_schemaを除く
# 'information_schema', 'mysql', 'sys', 'performance_schema'
# いざとなったら、手で作る
readonly SQL="select table_schema as DB, table_name from information_schema.tables where table_schema not in ('information_schema', 'mysql', 'sys', 'performance_schema') order by table_schema;"
echo "${SQL}"
cat tmp/isu-servers | head -n1 | xargs -I{} ssh {} "sudo mysql -e \"${SQL}\"" > tmp/db-tables

#
# 通知
#
echo '----'
echo '👍️Done: tmp/db-tablesの作成(上書き)'
cat tmp/db-tables
echo '----'
