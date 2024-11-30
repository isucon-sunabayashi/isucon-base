#!/usr/bin/env bash
set -eu
#set -x
# -e: エラーが発生した時点でスクリプトを終了
# -u: 未定義の変数を使用した場合にエラーを発生
# -x: スクリプトの実行内容を表示(debugで利用)

#
# 通知
#
echo '-------[ 🚀pprof.goを置きます🚀 ]'

#
# pprof.goをコピー
#
cp scripts/pprof.go isu-webapp/golang/

# 使い方
# main()にpprof()を記載
# アプリをデプロイ
#
# ベンチ直前(60秒間プロファイリング)
# go tool pprof -seconds 60 -http=0.0.0.0:1080 http://localhost:6060/debug/pprof/profile
#
# 60秒後に、${パブリックIP}:1080でアクセス可能
# pprof/ディレクトリ以下に収集したプロファイルが出力される
# go tool pprof -seconds 60 -http=0.0.0.0:1080 pprof/pprof.app.samples.cpu.001.pb.gz
# で、収集後のファイルを利用して1080で開くことも可能
#
# `lsof -i:6060` で確認可能
# `kill -9 $(lsof -t -i:6060)` でプロセスも削除可能
# 最後は消す

#
# 通知
#
echo '----'
echo '👍️Done: pprof.goを置きました(make deploy-appをしてください)'
echo 'ベンチ前に `go tool pprof -seconds 60 -http=0.0.0.0:1080 http://localhost:6060/debug/pprof/profile` をするとプロファイリング可能です'
echo 'プロファイルは pprof/以下にできます'
echo '後になって見る場合は、 `go tool pprof -http=0.0.0.0:1080 pprof/プロファイル名.pb.gz` で可能です'
echo '参考1: [Go言語のプロファイリングツール、pprofのWeb UIがめちゃくちゃ便利なので紹介する](https://medium.com/eureka-engineering/go%E8%A8%80%E8%AA%9E%E3%81%AE%E3%83%97%E3%83%AD%E3%83%95%E3%82%A1%E3%82%A4%E3%83%AA%E3%83%B3%E3%82%B0%E3%83%84%E3%83%BC%E3%83%AB-pprof%E3%81%AEweb-ui%E3%81%8C%E3%82%81%E3%81%A1%E3%82%83%E3%81%8F%E3%81%A1%E3%82%83%E4%BE%BF%E5%88%A9%E3%81%AA%E3%81%AE%E3%81%A7%E7%B4%B9%E4%BB%8B%E3%81%99%E3%82%8B-6a34a489c9ee)'
echo '参考2: [ISUCONの為のpprof](https://docs.google.com/presentation/d/1Fghxd31leQN2N2dW9h9D0KivPSSh-ROnzlsdqfsaGVw/edit#slide=id.g5d10333e70_1_79)'
echo '----'
