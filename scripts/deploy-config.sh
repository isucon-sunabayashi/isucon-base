#!/usr/bin/env bash
set -eu
#set -x
# -e: エラーが発生した時点でスクリプトを終了
# -u: 未定義の変数を使用した場合にエラーを発生
# -x: スクリプトの実行内容を表示(debugで利用)

#
# 通知
#
echo '-------[ 🚀Deploy config🚀 ]'

#
# Nginx
#
echo '----[ 🚀Deploy Nginx config🚀 ]'
readonly NGINX_CONF_PATH='/etc/nginx/nginx.conf'
readonly NGINX_SITES_AVAILABLE_PATH='/etc/nginx/sites-available/'
cat tmp/isu-servers | xargs -I{} rsync -az --rsync-path='sudo rsync' "./isu-common${NGINX_CONF_PATH}" "{}:${NGINX_CONF_PATH}"
cat tmp/isu-servers | xargs -I{} rsync -az --rsync-path='sudo rsync' "./isu-common${NGINX_SITES_AVAILABLE_PATH}" "{}:${NGINX_SITES_AVAILABLE_PATH}"
cat tmp/isu-servers | xargs -I{} ssh {} "sudo chown root:root ${NGINX_CONF_PATH} && sudo chmod 644 ${NGINX_CONF_PATH}"
cat tmp/isu-servers | xargs -I{} ssh {} "sudo chown -R root:root ${NGINX_SITES_AVAILABLE_PATH} && sudo chmod 644 ${NGINX_SITES_AVAILABLE_PATH}*"
cat tmp/isu-servers | xargs -I{} ssh {} 'sudo mkdir -p /var/log/nginx/ && sudo chown -R www-data:www-data /var/log/nginx/ && sudo chmod 777 -R /var/log/nginx/'
cat tmp/isu-servers | xargs -I{} ssh {} 'sudo nginx -t && sudo systemctl reload nginx'
cat tmp/isu-servers | xargs -I{} ssh {} 'sudo chown -R www-data:www-data /var/log/nginx/ && sudo chmod 777 -R /var/log/nginx/'
cat tmp/isu-servers | xargs -I{} ssh {} 'echo ----[ {} ] && systemctl status nginx'

#
# MySQL
#
echo ''
echo '----[ 🚀Deploy MySQL config🚀 ]'
readonly MYSQLD_CONF_PATH='/etc/mysql/mysql.conf.d/mysqld.cnf'
cat tmp/isu-servers | xargs -I{} rsync -az --rsync-path='sudo rsync' "./isu-common${MYSQLD_CONF_PATH}" "{}:${MYSQLD_CONF_PATH}"
cat tmp/isu-servers | xargs -I{} ssh {} "sudo chown root:root ${MYSQLD_CONF_PATH} && sudo chmod 644 ${MYSQLD_CONF_PATH}"
cat tmp/isu-servers | xargs -I{} ssh {} 'sudo mkdir -p /var/log/mysql/ && sudo chown -R mysql:mysql /var/log/mysql/ && sudo chmod 777 -R /var/log/mysql/'
cat tmp/isu-servers | xargs -I{} ssh {} 'sudo systemctl restart mysql'
cat tmp/isu-servers | xargs -I{} ssh {} 'sudo chown -R mysql:mysql /var/log/mysql/ && sudo chmod 777 -R /var/log/mysql/'
cat tmp/isu-servers | xargs -I{} ssh {} 'echo ----[ {} ] && systemctl status mysql'

#
# prometheus-mysqld-exporter
#
echo ''
echo '----[ 🚀Deploy prometheus-mysqld-exporter config🚀 ]'
readonly PROMETHEUS_MYSQLD_EXPORTER_PATH='/etc/default/prometheus-mysqld-exporter'
cat tmp/isu-servers | xargs -I{} rsync -az --rsync-path='sudo rsync' "./isu-common${PROMETHEUS_MYSQLD_EXPORTER_PATH}" "{}:${PROMETHEUS_MYSQLD_EXPORTER_PATH}"
cat tmp/isu-servers | xargs -I{} ssh {} "sudo chown prometheus:prometheus ${PROMETHEUS_MYSQLD_EXPORTER_PATH} && sudo chmod 644 ${PROMETHEUS_MYSQLD_EXPORTER_PATH}"
cat tmp/isu-servers | xargs -I{} ssh {} 'sudo systemctl restart prometheus-mysqld-exporter'
cat tmp/isu-servers | xargs -I{} ssh {} 'echo ----[ {} ] && systemctl status prometheus-mysqld-exporter'

#
# Fluent-Bit
#
echo ''
echo '----[ 🚀Deploy Fluent-Bit config🚀 ]'
readonly FLUENT_BIT_CONF_PATH='/etc/fluent-bit/fluent-bit.conf'
cat tmp/isu-servers | xargs -I{} rsync -az --rsync-path='sudo rsync' "./isu-common${FLUENT_BIT_CONF_PATH}" "{}:${FLUENT_BIT_CONF_PATH}"
cat tmp/isu-servers | xargs -I{} ssh {} "sudo chown root:root ${FLUENT_BIT_CONF_PATH} && sudo chmod 644 ${FLUENT_BIT_CONF_PATH}"
cat tmp/isu-servers | xargs -I{} ssh {} '(curl -s "http://localhost:3100/ready" &> /dev/null && sudo systemctl restart fluent-bit) || echo "fluent-bit は再起動しませんでした"'
cat tmp/isu-servers | xargs -I{} ssh {} 'echo ----[ {} ] && systemctl status fluent-bit'

#
# 通知
#
echo '----'
echo '👍️Done: Deploy config'
echo '----'
