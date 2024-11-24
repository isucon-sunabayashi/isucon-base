#!/usr/bin/env bash
set -eu
#set -x
# -e: エラーが発生した時点でスクリプトを終了
# -u: 未定義の変数を使用した場合にエラーを発生
# -x: スクリプトの実行内容を表示(debugで利用)

#
# 通知
#
echo '-------[ 🚀Setup alp🚀 ]'

#
# git clone
#
cat tmp/isu-servers | xargs -I{} ssh {} 'ls alp > /dev/null || git clone --depth 1 https://github.com/tkuchiki/alp.git'

#
# build & install
#
cat tmp/isu-servers | xargs -I{} ssh {} "(command -v alp && echo 'alpはインストール済みです') || (export PATH=\$PATH:/home/isucon/.local/go/bin && cd alp && make build && sudo mv alp /usr/local/bin/)"

#
# 確認
#
cat tmp/isu-servers | xargs -I{} ssh {} "echo -n 'alp version = ' && alp -v"

#
# 通知
#
echo '----'
echo '👍️Done: Setup alp'
echo "👍️Installed: alp"
echo '----'
