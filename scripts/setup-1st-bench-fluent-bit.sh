#!/usr/bin/env bash
set -eu
#set -x
# -e: エラーが発生した時点でスクリプトを終了
# -u: 未定義の変数を使用した場合にエラーを発生
# -x: スクリプトの実行内容を表示(debugで利用)

#
# 通知
#
echo '-------[ 🚀Setup 1st Benchmark Fluent-bit🚀 ]'

#
# Fluent-bit
#
cp -rf snippets/etc/fluent-bit isu-common/etc/

#
# 通知
#
echo '👍️Done: isu-common/etc/fluent-bit'
