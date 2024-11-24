#!/usr/bin/env bash
set -eu
#set -x
# -e: エラーが発生した時点でスクリプトを終了
# -u: 未定義の変数を使用した場合にエラーを発生
# -x: スクリプトの実行内容を表示(debugで利用)

#
# 通知
#
echo '-------[ 🚀Setup 1st Benchmark Nginx🚀 ]'

#
# Nginx
#
cat << 'EOF'
http {
  # ...

  ##
  # Logging Settings
  ##

  log_format json escape=json '{"time":"$time_local",'
                              '"host":"$remote_addr",'
                              '"forwardedfor":"$http_x_forwarded_for",'
                              '"req":"$request",'
                              '"status":"$status",'
                              '"method":"$request_method",'
                              '"uri":"$request_uri",'
                              '"body_bytes":$body_bytes_sent,'
                              '"referer":"$http_referer",'
                              '"ua":"$http_user_agent",'
                              '"request_time":$request_time,'
                              '"cache":"$upstream_http_x_cache",'
                              '"runtime":"$upstream_http_x_runtime",'
                              '"response_time":"$upstream_response_time",'
                              '"vhost":"$host"}';
  access_log /var/log/nginx/access.log json;

  # ...
}
EOF

#
# 通知
#
echo '----'
echo '👍️Please: 手動でコピー&ペーストしてください to isu-common/etc/nginx/nginx.conf'
echo '----'
