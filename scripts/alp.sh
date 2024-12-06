#!/usr/bin/env bash
set -eu -o pipefail
#set -x
# -e: エラーが発生した時点でスクリプトを終了
# -u: 未定義の変数を使用した場合にエラーを発生
# -x: スクリプトの実行内容を表示(debugで利用)
# -o pipefail: パイプライン内のコマンドが失敗した場合にパイプライン全体を失敗として扱う

#
# 通知
#
echo '-------[ 🚀alp🚀 ]'

#
# コマンド
#
readonly LATEST_DIR_PATH="tmp/analysis/latest"
readonly COMMAND="alp json --sort=sum --reverse --file ${LATEST_DIR_PATH}/nginx-access.log.isu-1 -m '${ALP_MATCHING_GROUPS}'"
echo '--[ COMMAND ]'
echo "${COMMAND}"
echo '--'

echo 'P90: レスポンスの90%がこの数値以下のレスポンスタイム'
echo 'STDDEV: 標準偏差(Standard Deviation)、値が大きいほどばらつきが大きい(=不安定)'
$(echo ${COMMAND})

echo 'alp結果を参照しながら、.envのALP_MATCHING_GROUPSを調整してください'
