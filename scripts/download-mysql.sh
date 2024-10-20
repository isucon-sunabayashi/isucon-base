#!/usr/bin/env bash
set -eu
#set -x
# -e: エラーが発生した時点でスクリプトを終了
# -u: 未定義の変数を使用した場合にエラーを発生
# -x: スクリプトの実行内容を表示(debugで利用)

#
# 通知
#
echo '-------[ 🚀Download mysql🚀 ]'

#
# mysql
#
readonly MYSQLD_CONF_PATH='/etc/mysql/mysql.conf.d/mysqld.cnf'
mkdir -p ./isu-common/etc/mysql/mysql.conf.d/
cat tmp/isu-servers | head -n1 | xargs -I{} rsync -az --exclude app {}:${MYSQLD_CONF_PATH} ./isu-common/etc/mysql/mysql.conf.d/mysqld.cnf

#
# 通知
#
echo '----'
echo '👍️Done: Download mysql'
echo '----'
