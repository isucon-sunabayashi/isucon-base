#!/usr/bin/env bash
set -eu
#set -x
# -e: エラーが発生した時点でスクリプトを終了
# -u: 未定義の変数を使用した場合にエラーを発生
# -x: スクリプトの実行内容を表示(debugで利用)

#
# 通知
#
echo '-------[ 🚀Download webapp🚀 ]'

#
# webapp
#
readonly WEBAPP_APP_DIR='/home/isucon/private_isu/webapp/golang'
cat tmp/isu-servers | head -n1 | xargs -I{} rsync -az --exclude app {}:${WEBAPP_APP_DIR} ./isu-webapp/

#
# 通知
#
echo '👍️Done: Download webapp'
