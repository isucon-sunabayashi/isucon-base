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
  index_name='idx_post_id'
  ssh -n ${server} "sudo mysql ${DB_NAME} -e 'create index ${index_name} on comments (post_id);'" || echo "index: ${index_name}, 既存(Duplicate key nameならば)"
  # DROP Index
  #ssh -n ${server} "sudo mysql ${DB_NAME} -e 'drop index idx_post_id on comments;'" || echo 'index無し'
done < <(cat tmp/isu-servers)

echo 'make show-tables で確認してください'

#
# 通知
#
echo '----'
echo '👍️Done: Create index'
echo '----'
