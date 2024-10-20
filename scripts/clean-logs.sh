#!/usr/bin/env bash
set -eu
#set -x
# -e: エラーが発生した時点でスクリプトを終了
# -u: 未定義の変数を使用した場合にエラーを発生
# -x: スクリプトの実行内容を表示(debugで利用)

#
# 通知
#
echo '-------[ 🚀Clean logs🚀 ]'

#
# Nginx
#
echo '----[ 🚀Clean Nginx logs🚀 ]'
readonly NGINX_ACCESS_LOG_PATH='/var/log/nginx/access.log'
readonly NGINX_ERROR_LOG_PATH='/var/log/nginx/error.log'
cat tmp/isu-servers | xargs -I{} ssh {} "(ls ${NGINX_ACCESS_LOG_PATH} &> /dev/null && sudo mv ${NGINX_ACCESS_LOG_PATH} ${NGINX_ACCESS_LOG_PATH}.old) || echo 'アクセスログが存在しません'; (ls ${NGINX_ERROR_LOG_PATH} &> /dev/null && sudo mv ${NGINX_ERROR_LOG_PATH} ${NGINX_ERROR_LOG_PATH}.old) || echo 'エラーログが存在しません'"
cat tmp/isu-servers | xargs -I{} ssh {} "sudo nginx -t && sudo systemctl reload nginx"
cat tmp/isu-servers | xargs -I{} ssh {} 'sudo chown -R www-data:www-data /var/log/nginx/ && sudo chmod 777 -R /var/log/nginx/'

#
# MySQL
#
echo '----[ 🚀Clean MySQL logs🚀 ]'
readonly MYSQL_SLOW_QUERY_LOG_PATH='/var/log/mysql/mysql-slow.log'
readonly MYSQL_ERROR_LOG_PATH='/var/log/mysql/error.log'
cat tmp/isu-servers | xargs -I{} ssh {} "(ls ${MYSQL_SLOW_QUERY_LOG_PATH} &> /dev/null && sudo mv ${MYSQL_SLOW_QUERY_LOG_PATH} ${MYSQL_SLOW_QUERY_LOG_PATH}.old) || echo 'スロークエリログが存在しません'; (ls ${MYSQL_ERROR_LOG_PATH} &> /dev/null && sudo mv ${MYSQL_ERROR_LOG_PATH} ${MYSQL_ERROR_LOG_PATH}.old) || echo 'エラーログが存在しません'"
cat tmp/isu-servers | xargs -I{} ssh {} 'sudo systemctl restart mysql'
cat tmp/isu-servers | xargs -I{} ssh {} 'sudo chown -R mysql:mysql /var/log/mysql/ && sudo chmod 777 -R /var/log/mysql/'

#
# Fluent-Bit
#
echo '----[ 🚀Clean Fluent-Bit logs🚀 ]'
readonly FLUENT_BIT_LOG_PATH='/var/log/fluent-bit/fluent-bit.log'
cat tmp/isu-servers | xargs -I{} ssh {} "(ls ${FLUENT_BIT_LOG_PATH} &> /dev/null && sudo mv ${FLUENT_BIT_LOG_PATH} ${FLUENT_BIT_LOG_PATH}.old) || echo 'fluent-bit.log が存在しません'"
cat tmp/isu-servers | xargs -I{} ssh {} '(curl -s "http://localhost:3100/ready" &> /dev/null && sudo systemctl restart fluent-bit) || echo "fluent-bit は再起動しませんでした"'

#
# 通知
#
echo '----'
echo '👍️Done: Clean logs'
echo '----'
