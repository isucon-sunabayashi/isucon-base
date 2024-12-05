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
echo '-------[ 🚀Show /etc/hosts🚀 ]'

#
# isunarabe13への名前解決のための記述を表示
# ブラウザで見るためだけに必要
#
grep -A1 'isu-1' ~/.ssh/config-for-isucon.d/config | grep HostName | cut -d' ' -f4 | xargs -I{} echo "{} pipe.t.isucon.pw"
grep -A1 -E 'isu-\d' ~/.ssh/config-for-isucon.d/config | grep HostName | cut -d' ' -f4 | nl | while read n ip; do \
  echo "${ip} test00${n}.t.isucon.pw"; \
done

#
# 通知
#
echo '----'
echo '👍️Done: Shown /etc/hosts'
echo '上述されたIP host名をsudo vim /etc/hostsで記載することで、名前解決をすることが可能です'
echo 'また、make replace-pemをすることでNginxの証明書の置換が可能です'
echo '----'
