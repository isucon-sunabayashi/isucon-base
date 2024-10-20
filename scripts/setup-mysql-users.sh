#!/usr/bin/env bash
set -eu
#set -x
# -e: エラーが発生した時点でスクリプトを終了
# -u: 未定義の変数を使用した場合にエラーを発生
# -x: スクリプトの実行内容を表示(debugで利用)

#
# 通知
#
echo '-------[ 🚀Setup MySQL users🚀 ]'

#
# isuconユーザの作成
# user: isucon
# pass: isucon
# 権限: 全て
#
cat tmp/isu-servers | xargs -I{} ssh {} "sudo mysql -e \"create user if not exists 'isucon'@'%' identified by 'isucon';\""
cat tmp/isu-servers | xargs -I{} ssh {} "sudo mysql -e \"grant all privileges on *.* to 'isucon'@'%';\""

#
# prometheusユーザの作成
# user: prometheus
# pass: prometheus
# 権限: 全てのDB.全てのテーブル に対して、 process, replication client, select
#
cat tmp/isu-servers | xargs -I{} ssh {} "sudo mysql -e \"create user if not exists 'prometheus'@'localhost' identified by 'prometheus';\""
cat tmp/isu-servers | xargs -I{} ssh {} "sudo mysql -e \"grant process, replication client, select on *.* to 'prometheus'@'localhost';\""

#
# 通知
#
echo '----'
echo '👍️Done: Setup MySQL users'
cat tmp/isu-servers | xargs -I{} ssh {} "echo ----[ {} ] && sudo mysql -e 'SELECT CONCAT_WS(\"@\", User, Host) FROM mysql.user;'"
echo '----'
