#!/usr/bin/env bash
set -eu
#set -x
# -e: エラーが発生した時点でスクリプトを終了
# -u: 未定義の変数を使用した場合にエラーを発生
# -x: スクリプトの実行内容を表示(debugで利用)

#
# 通知
#
echo '-------[ 🚀Download env🚀 ]'

#
# env.sh
#
readonly ENV_SH_PATH='/home/isucon/env.sh'
cat tmp/isu-servers | xargs -I{} mkdir -p {}/home/isucon/
cat tmp/isu-servers | xargs -I{} rsync -az {}:${ENV_SH_PATH} ./{}/home/isucon/env.sh

#
# 通知
#
echo '👍️Done: Download env'
