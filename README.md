## isucon

issuesに貼り付ける

1. CloudFormationで環境を整える
2. 待っている間、アプリドキュメンテーションを読む
3. make create-sshconfig
4. make check-ssh
5. make setup
6. make download
7. make show-services
  - [ ] サービス一覧の確認した
  - [ ] DB名の確認した
  - [ ] DBのユーザーの確認した
  - [ ] DBのユーザーのパスワードを確認した
  - [ ] テーブル一覧の確認した
  - [ ] テーブル一覧の確認した
8. make switch-to-golang-isu-app

## 継続的Kaizenの準備

必要なら少しいじる

- make deploy-config
- make deploy-app
- make clean-logs

## ベンチマーク

1. make deploy-config
2. make deploy-app
3. make show-table-counts
4. make clean-logs
5. ベンチマーク
6. make show-table-counts
7. make download-and-analyze-logs

## Kaizen

- make-sho-tables
- make alp-result
- make slow-query-result
