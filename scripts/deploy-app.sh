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
echo '-------[ 🚀Deploy App🚀 ]'

#
# ビルドコマンド
#
readonly SSH_COMMAND="export PATH=\$PATH:${ISU_GOLANG_PATH} && cd ${REMOTE_APP_PATH} && ${BUILD_COMMAND} && sudo systemctl restart ${GO_APP_NAME}"
echo '--[ 各サーバーでrsync後、以下のコマンドを打ちます ]'
echo "SSH_COMMAND: ${SSH_COMMAND}"
echo '--'

#
# rsync と  deploy
#
while read -r server; do
  echo "--[ ${server} ]"
  rsync -az "${LOCAL_APP_PATH}/" "${server}:${REMOTE_APP_PATH}/"
  ssh -n ${server} "${SSH_COMMAND}"
done < <(cat tmp/isu-servers)

#
# 通知
#
echo '----'
echo '👍️Done: Deploy App'
echo '----'
