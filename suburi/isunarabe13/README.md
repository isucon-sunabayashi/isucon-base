isunarabe13
----

- isucon13 v1.0のcloudformation.ymlの自分のIP制限版を作る
- 必要: ISUNARABEからisucon13 v1.0の最新のcloudformation.ymlをDLしておく
  - build時に利用するTOKENは時間が経過すると更新が必要そうだったため

SSHできるかは公開鍵が取得できるか次第
----

ISUNARABEは、DLしたcloudformation.ymlにあるSetupTokenを利用して公開鍵を取得している

```shell
make check-authorized-keys
# で公開鍵が取得できたらOK
```

必要なコマンド
----

1. curl
  - 自分のIPを取得する
2. yq
  - yml形式をjsonに変更する
3. jq
  - jsonから情報(SetupToken)を引っこ抜く
4. envsubst
  - テンプレートファイルに対して、環境変数を置換する

実行
----

```
make build-cfn
```

インスタンスタイプ料金(毎時)
----

- c5やc6iはintel
- c5.large
  - $0.107, 2 vCPU, 4GiB
- c6i.large
  - $0.107, 2 vCPU, 4GiB
- c7i,large
  - $0.11235, 2vCPU, 4GiB
