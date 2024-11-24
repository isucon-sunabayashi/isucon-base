#!/usr/bin/env bash
set -eu
#set -x
# -e: エラーが発生した時点でスクリプトを終了
# -u: 未定義の変数を使用した場合にエラーを発生
# -x: スクリプトの実行内容を表示(debugで利用)

#
# OUTPUT:
# - ~/.ssh/config-for-isucon.d/config // ssh接続設定ファイル
#

mkdir -p ~/.ssh/config-for-isucon.d

#
# ~/.ssh/config-for-isucon.d/configを作成
#
cat tmp/hosts.csv \
  | awk -F, '{print "Host "$1"\n  HostName "$2"\n  User isucon\n  IdentityFile ~/.ssh/id_rsa\n  StrictHostKeyChecking no\n  UserKnownHostsFile /dev/null\n  LogLevel quiet"}' \
  > ~/.ssh/config-for-isucon.d/config
chmod 644 ~/.ssh/config-for-isucon.d/config

#
# 通知
#
echo '~/.ssh/config-for-isucon.d/configを作成しました'
echo '----------------------------------------'
cat ~/.ssh/config-for-isucon.d/config
echo '----------------------------------------'
echo '~/.ssh/configの先頭に以下を記述してください'
echo 'Include ~/.ssh/config-for-isucon.d/config'

#
# tmp/isu-serversを作成
#
cat tmp/hosts.csv | grep -v 'bench' | cut -d',' -f1 > tmp/isu-servers
