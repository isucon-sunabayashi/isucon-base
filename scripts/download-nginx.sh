#!/usr/bin/env bash
set -eu
#set -x
# -e: エラーが発生した時点でスクリプトを終了
# -u: 未定義の変数を使用した場合にエラーを発生
# -x: スクリプトの実行内容を表示(debugで利用)

#
# 通知
#
echo '-------[ 🚀Download nginx🚀 ]'

#
# nginx
#
readonly NGINX_CONF_PATH='/etc/nginx/nginx.conf'
readonly NGINX_SITES_AVAILABLE_PATH='/etc/nginx/sites-available'
mkdir -p ./isu-common/etc/nginx/
cat tmp/isu-servers | head -n1 | xargs -I{} rsync -az {}:${NGINX_CONF_PATH} ./isu-common/etc/nginx/nginx.conf
cat tmp/isu-servers | head -n1 | xargs -I{} rsync -az {}:${NGINX_SITES_AVAILABLE_PATH} ./isu-common/etc/nginx/

#
# 通知
#
echo '👍️Done: Download nginx'
