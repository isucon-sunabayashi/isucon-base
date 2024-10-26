#!/usr/bin/env bash
set -eu
#set -x
# -e: エラーが発生した時点でスクリプトを終了
# -u: 未定義の変数を使用した場合にエラーを発生
# -x: スクリプトの実行内容を表示(debugで利用)

#
# 通知
#
echo '-------[ 🚀Switch to golang isu-app🚀 ]'

#
# Switch
# .envにて DEFAULT_APP_NAME, GO_APP_NAME を設定していること
# 例: DEFAULT_APP_NAME=isu-ruby, GO_APP_NAME=isu-go
cat tmp/isu-servers | xargs -I{} ssh {} "sudo systemctl disable --now ${DEFAULT_APP_NAME} && sudo systemctl enable --now ${GO_APP_NAME}"

#
# 通知
#
echo '----'
echo '👍️Done: Switch to golang isu-app'
cat tmp/isu-servers | xargs -I{} ssh {} "echo '----[ {} ]' && systemctl status ${GO_APP_NAME}"
echo '----'
