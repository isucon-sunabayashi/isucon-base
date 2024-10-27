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
grep -v -E '^#' ./isu-common/etc/mysql/mysql.conf.d/mysqld.cnf \
| grep -v -E '(bind-address|slow_query_log|max_binlog_size)' \
| awk '
/^user/ {
  print "user = mysql"
  print "bind-address = 0.0.0.0"
  print "mysqlx-bind-address = 0.0.0.0"
  next
}
/^log_error/ {
  print
  print "slow_query_log = 1"
  print "slow_query_log_file = /var/log/mysql/mysql-slow.log"
  print "long_query_time = 0"
  print "log-queries-not-using-indexes = ON"
  print "max_binlog_size = 100M"
  next
}
{ print }
' > tmp/mysqld.cnf && mv tmp/mysqld.cnf ./isu-common/etc/mysql/mysql.conf.d/mysqld.cnf

#
# 通知
#
echo '👍️Done: isu-common/etc/mysql/mysql.conf.d/mysqld.cnf'
