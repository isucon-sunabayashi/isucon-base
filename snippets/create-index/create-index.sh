#!/usr/bin/env bash
set -eu
#set -x
# -e: エラーが発生した時点でスクリプトを終了
# -u: 未定義の変数を使用した場合にエラーを発生
# -x: スクリプトの実行内容を表示(debugで利用)

#
# 通知
#
echo '----[ 🚀Create index🚀 ]'

#
# index
#
readonly DB_NAME='isuconp'
while read server; do
  ssh -n ${server} "sudo mysql ${DB_NAME} -e 'create index idx_post_id on comments (post_id);'" || echo '既にindex有り'
  # DROP Index
  #ssh -n ${server} "sudo mysql ${DB_NAME} -e 'drop index idx_post_id on comments;'" || echo 'index無し'
done < <(cat tmp/isu-servers)

#
# 通知
#
echo '----'
echo '👍️Done: Create index'
echo '----'
