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
echo '-------[ 🚀nginxの証明書を置換🚀 ]'

# Check using commands
required_commands=("gh" "jq" "curl")
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
# 最新の証明書を取得
#
mkdir -p tmp/nginx-tls/

if [ -f tmp/nginx-tls/_.t.isucon.pw.crt ]; then
  echo '証明書はDL済みなので、DLはしません'
  echo 'DLからやり直したい場合: rm -rf tmp/nginx-tls/'
else
  gh release view --repo KOBA789/t.isucon.pw --json assets --jq '.assets[] | select(.name == "key.pem" or .name == "fullchain.pem") | .url' | xargs -I{} curl -s -L --output-dir tmp/nginx-tls/ -O {}
  mv tmp/nginx-tls/key.pem tmp/nginx-tls/_.t.isucon.pw.key
  mv tmp/nginx-tls/fullchain.pem tmp/nginx-tls/_.t.isucon.pw.crt
fi

#
# 各サーバーの証明書置換とNginx再起動
#
# ssh -n で標準入力を/dev/nullにリダイレクトすることで、whileで回しても途中で終わらないようにする
while read -r host; do
  echo "--[ host:${host} Nginxの証明書置換と再起動 ]"
  rsync -az -e ssh --rsync-path="sudo rsync" tmp/nginx-tls/ ${host}:/etc/nginx/tls/
  ssh -n ${host} 'sudo systemctl reload nginx'
done < <(grep -E 'isu-\d' ~/.ssh/config-for-isucon.d/config | cut -d' ' -f2)

#
# 通知
#
echo '----'
echo '👍️Done: Nginxの証明書を置換'
echo '----'
