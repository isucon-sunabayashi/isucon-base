#!/usr/bin/env bash
set -eu
#set -x
# -e: エラーが発生した時点でスクリプトを終了
# -u: 未定義の変数を使用した場合にエラーを発生
# -x: スクリプトの実行内容を表示(debugで利用)

#
# 通知
#
echo '-------[ 🚀Download Logs🚀 ]'

#
# ログや設定など分析用のファイル群をダウンロードして分析まで
#
# OUTPUT:
# - tmp/analysis/${CURRENT_TIME}/
# - シンボリックリンク: tmp/analysis/latest -> tmp/analysis/${CURRENT_TIME}/
#
readonly CURRENT_TIME="$(TZ='Asia/Tokyo' date +"%Y-%m-%dT%H:%M:%S%z")"
readonly OUTPUT_DIR_PATH="tmp/analysis/${CURRENT_TIME}"
readonly INPUT_FILE="tmp/isu-servers"

#
# ディレクトリ作成
#
mkdir -p "${OUTPUT_DIR_PATH}"

#
# Nginx
#
while read server; do
  rsync -az ${server}:/var/log/nginx/access.log ${OUTPUT_DIR_PATH}/nginx-access.log.${server}
done < ${INPUT_FILE}

#
# MySQL
#
while read server; do
  rsync -az ${server}:/var/log/mysql/mysql-slow.log ${OUTPUT_DIR_PATH}/mysql-slow.log.${server}
done < ${INPUT_FILE}

#
# シンボリックリンク
#
readonly LATEST_DIR_PATH="tmp/analysis/latest"
rm -f ${LATEST_DIR_PATH}
ln -sf $(realpath ${OUTPUT_DIR_PATH}) ${LATEST_DIR_PATH}

########################################################################################################################
# 分析
########################################################################################################################
#
# 通知
#
echo '-------[ 🚀Analyze Logs🚀 ]'
#
# コマンドの有無チェック
#
required_commands=("alp" "pt-query-digest")
missing_commands=()
for cmd in "${required_commands[@]}"; do
  if ! command -v "$cmd" &> /dev/null; then
    missing_commands+=("$cmd")
  fi
done
if [ ${#missing_commands[@]} -ne 0 ]; then
  echo "以下のコマンドが見つかりません。インストールしてください:"
  for cmd in "${missing_commands[@]}"; do
    echo "- $cmd"
  done
  exit 1
fi

#
# Nginxのアクセスログを分析
# alp: -m オプションの部分を柔軟に変更する必要がある
#
while read server; do
  OUTPUT_FILE="${LATEST_DIR_PATH}/analyzed-alp-nginx-access.log.${server}"
  echo ${server} > "${OUTPUT_FILE}"
  echo 'P90: レスポンスの90%がこの数値以下のレスポンスタイム' >> "${OUTPUT_FILE}"
  echo 'STDDEV: 標準偏差(Standard Deviation)、値が大きいほどばらつきが大きい(=不安定)' >> "${OUTPUT_FILE}"
  alp json --sort=sum --reverse --file ${LATEST_DIR_PATH}/nginx-access.log.${server} \
    -m '/image/\d+.(jpg|png|gif),/posts/\d+,/@\w+' \
    >> "${OUTPUT_FILE}"
  echo "less ${OUTPUT_FILE}"
done < ${INPUT_FILE}

#
# MySQLのスロークエリを分析
#
while read server; do
  OUTPUT_FILE="${LATEST_DIR_PATH}/analyzed-pt-query-digest-slow.log.${server}"
  pt-query-digest --limit 10 ${LATEST_DIR_PATH}/mysql-slow.log.${server} > "${OUTPUT_FILE}"
  echo "less ${OUTPUT_FILE}"
done < <(cat ${INPUT_FILE})

#
# 通知
#
echo '----'
echo '👍️Done: Download and analyze logs'
echo '----'
