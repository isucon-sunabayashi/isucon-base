#!/usr/bin/env bash
set -eu -o pipefail
#set -x
# -e: エラーが発生した時点でスクリプトを終了
# -u: 未定義の変数を使用した場合にエラーを発生
# -x: スクリプトの実行内容を表示(debugで利用)
# -o pipefail: パイプライン内のコマンドが失敗した場合にパイプライン全体を失敗として扱う

#
# 通知
#
echo '-------[ 🚀Initialize(ベンチマーク時に叩かれるURL)🚀 ]'

#
# SSH_COMMAND
#
readonly SSH_COMMAND="curl -s -X${INITIALIZE_HTTP_REQUEST_METHOD} 'http://localhost:8080${INITIALIZE_URL_PATH}'"
echo '--[ SSH_COMMAND ]'
echo "${SSH_COMMAND}"
echo '--'

#
# Initialize
#
while read -r server; do
  echo "--[ ${server} initialize ]"
  ssh -n ${server} "${SSH_COMMAND}"
done < <(cat tmp/isu-servers)

#
# 通知
#
echo '----'
echo '👍️Done: initialize'
echo '----'
