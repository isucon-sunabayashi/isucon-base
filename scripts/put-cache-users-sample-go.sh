#!/usr/bin/env bash
set -eu
#set -x
# -e: エラーが発生した時点でスクリプトを終了
# -u: 未定義の変数を使用した場合にエラーを発生
# -x: スクリプトの実行内容を表示(debugで利用)

#
# 通知
#
echo '-------[ 🚀cache_users_sample.goを置きます(not上書き)🚀 ]'

#
# cache_users_sample.goをコピー(no上書き)
#
if [ -e ${LOCAL_APP_PATH}/cache_users_sample.go ]; then
  echo "既に ${LOCAL_APP_PATH}/cache_users_sample.go は存在します"
else
  cp scripts/cache_users_sample.go ${LOCAL_APP_PATH}/
fi
cd ${LOCAL_APP_PATH}/ && go get github.com/orcaman/concurrent-map/v2 && cd -

#
# 通知
#
echo '----'
echo '👍️Done: cache_users_sample.goを置きました'
echo 'renameするなりして、変更して、デプロイしてください'
echo '以下にinitializeUserCache()を挿入してください'
grep -rni -E 'initialize' ${LOCAL_APP_PATH}
echo '--'
echo '`grep -rni "INSERT INTO " ${LOCAL_APP_PATH}` して、INSERT時にset〇〇Cacheするようにしてください'
grep -rni 'INSERT INTO `' ${LOCAL_APP_PATH}
echo '--'
echo '`grep -rni "UPDATE " ${LOCAL_APP_PATH}` して、UPDATE時にset〇〇Cacheするようにしてください'
grep -rni 'UPDATE `' ${LOCAL_APP_PATH}
echo '----'
