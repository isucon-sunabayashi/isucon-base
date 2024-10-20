#!/usr/bin/env bash
set -eu
#set -x
# -e: エラーが発生した時点でスクリプトを終了
# -u: 未定義の変数を使用した場合にエラーを発生
# -x: スクリプトの実行内容を表示(debugで利用)

#
# 通知
#
echo '-------[ 🚀Re:up containers🚀 ]'

#
# prometheus.yml作成
# Node Exporterのポート番号: 9100
# MySQL Exporterのポート番号: 9104
# Nginx Exporterのポート番号: 9113
# OUTPUT:
# - tmp/prometheus.yml
#
#
export ENV_NODE_EXPORTER_TARGETS=$(cat tmp/hosts.csv | grep -v 'bench' | cut -d',' -f2 | xargs -I{} echo '"{}:9100"' | tr '\n' ',' | sed 's/,$//' | awk '{print "["$0"]"}')
export ENV_MYSQL_EXPORTER_TARGETS=$(cat tmp/hosts.csv | grep -v 'bench' | cut -d',' -f2 | xargs -I{} echo '"{}:9104"' | tr '\n' ',' | sed 's/,$//' | awk '{print "["$0"]"}')
export ENV_NGINX_EXPORTER_TARGETS=$(cat tmp/hosts.csv | grep -v 'bench' | cut -d',' -f2 | xargs -I{} echo '"{}:9113"' | tr '\n' ',' | sed 's/,$//' | awk '{print "["$0"]"}')
envsubst '$ENV_NODE_EXPORTER_TARGETS $ENV_MYSQL_EXPORTER_TARGETS $ENV_NGINX_EXPORTER_TARGETS' < containers/prometheus/prometheus.template.yml > tmp/prometheus.yml

#
# Down
#
docker compose down

#
# Clean up
#
rm -rf tmp/containers

#
# Lokiのデータストレージ作成
#
mkdir -p tmp/containers/loki/

#
# Up
#
docker compose up
