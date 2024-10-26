#!/usr/bin/env bash
set -eu
#set -x
# -e: エラーが発生した時点でスクリプトを終了
# -u: 未定義の変数を使用した場合にエラーを発生
# -x: スクリプトの実行内容を表示(debugで利用)

#
# 通知
#
echo '-------[ 🚀Setup 1st Benchmark prometheus-mysqld-exporter🚀 ]'

#
# Prometheus
#
mkdir -p isu-common/etc/default/
cp snippets/etc/default/prometheus-mysqld-exporter isu-common/etc/default/

#
# 通知
#
echo '----'
echo '👍️Done: isu-common/etc/default/prometheus-mysqld-exporter'
echo '----'
