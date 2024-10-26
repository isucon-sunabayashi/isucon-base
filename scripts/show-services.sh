#!/usr/bin/env bash
set -eu
#set -x
# -e: エラーが発生した時点でスクリプトを終了
# -u: 未定義の変数を使用した場合にエラーを発生
# -x: スクリプトの実行内容を表示(debugで利用)

#
# 通知
#
echo '-------[ 🚀Show services🚀 ]'

#
# サービス一覧
# 決め打ちなので、柔軟に増やす
#
cat tmp/isu-servers | xargs -I{} ssh {} 'echo ----[ {} ] && systemctl list-units --type=service --all | rg "(isu|nginx|mysql|fluent-bit|prometheus)"'

#
# appのgolang版を探す
#
cat tmp/isu-servers | head -n1 | xargs -I{} ssh {} 'echo ----[ {} ] && find . -type d -name "golang"'

#
# Serviceの場所を探す
#
cat tmp/isu-servers | head -n1 | xargs -I{} ssh {} 'echo ----[ {} ] && ls -1 /etc/systemd/system/isu*'
