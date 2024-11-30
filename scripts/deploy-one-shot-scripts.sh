#!/usr/bin/env bash
set -eu
#set -x
# -e: エラーが発生した時点でスクリプトを終了
# -u: 未定義の変数を使用した場合にエラーを発生
# -x: スクリプトの実行内容を表示(debugで利用)

#
# 通知
#
echo '-------[ 🚀Deploy one shot scripts🚀 ]'

#
# touch(ない時に備えて)
#
cat tmp/isu-servers | xargs -I{} mkdir -p ./{}/home/isucon/one-shot-scripts
cat tmp/isu-servers | xargs -I{} touch ./{}/home/isucon/one-shot-scripts/.keep

#
# deploy
#
cat tmp/isu-servers | xargs -I{} rsync -az "./{}/home/isucon/one-shot-scripts/" "{}:/home/isucon/one-shot-scripts/"

#
# 通知
#
echo '----'
echo '👍️Done: Deploy one shot scripts'
echo '----'
