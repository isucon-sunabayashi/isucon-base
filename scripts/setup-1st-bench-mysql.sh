#!/usr/bin/env bash
set -eu
#set -x
# -e: エラーが発生した時点でスクリプトを終了
# -u: 未定義の変数を使用した場合にエラーを発生
# -x: スクリプトの実行内容を表示(debugで利用)

#
# 通知
#
echo '-------[ 🚀Setup 1st Benchmark MySQL🚀 ]'

#
# MySQL
#
cat << 'EOF'
#
# * Basic Settings
#
user = mysql
bind-address = 0.0.0.0
mysqlx-bind-address = 0.0.0.0

# ...

#
# * Logging and Replication
#
log_error = /var/log/mysql/error.log
slow_query_log = 1
slow_query_log_file = /var/log/mysql/mysql-slow.log
long_query_time = 0
log-queries-not-using-indexes = ON
max_binlog_size = 100M
EOF

#
# 通知
#
echo '----'
echo '👍️Please: Copy & Paste to isu-common/etc/mysql/mysql.conf.d/mysqld.cnf'
echo '----'
