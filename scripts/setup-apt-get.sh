#!/usr/bin/env bash
set -eu
#set -x
# -e: エラーが発生した時点でスクリプトを終了
# -u: 未定義の変数を使用した場合にエラーを発生
# -x: スクリプトの実行内容を表示(debugで利用)

#
# 通知
#
echo '-------[ 🚀Setup apt-get🚀 ]'

#
# apt-get
#
readonly APT_TOOLS=(
  "tmux"
  "neovim"
  "make"
  "jq"
  # "yq" # isunarabe13ではpackageがなかったため、コメントアウト
  "git"
  "ripgrep"
  "tree"
  "psmisc"                     # pstree
  "percona-toolkit"            # pt-query-digest
  "gv"                         # pprofで利用
  "graphviz"                   # pprofで利用
  #"prometheus-node-exporter"   # for prometheus
  #"prometheus-mysqld-exporter" # for prometheus
  #"prometheus-nginx-exporter"  # for prometheus
)
cat tmp/isu-servers | xargs -I{} ssh {} "sudo apt-get update && sudo apt-get install -y ${APT_TOOLS[*]}"

#
# 通知
#
echo '----'
echo '👍️Done: Setup apt-get'
echo "👍️Installed: ${APT_TOOLS[*]}"
echo '----'
