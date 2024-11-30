package main

import (
	"log"
	"net/http"
	_ "net/http/pprof"
	"runtime"
)

// 使い方
// main()にpprof()を記載
// アプリをデプロイ
//
// ベンチ直前(60秒間プロファイリング)
// go tool pprof -seconds 70 -http=0.0.0.0:1080 http://localhost:6060/debug/pprof/profile
//
// 60秒後に、${パブリックIP}:1080でアクセス可能
// pprof/ディレクトリ以下に収集したプロファイルが出力される
// go tool pprof -http=0.0.0.0:1080 pprof/pprof.app.samples.cpu.001.pb.gz
// で、収集後のファイルを利用して1080で開くことも可能
//
// `lsof -i:6060` で確認可能
// `kill -9 $(lsof -t -i:6060)` でプロセスも削除可能
// 最後は消す
func pprof() {
	runtime.SetBlockProfileRate(1)
	runtime.SetMutexProfileFraction(1)
	go func() {
		log.Fatal(http.ListenAndServe("localhost:6060", nil))
	}()
}
