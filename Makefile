.PHONY: create-sshconfig
create-sshconfig: ## ~/.ssh/config-for-isucon.d/config 作成
	@bash scripts/create-sshconfig.sh

.PHONY: check-ssh
check-ssh: tmp/hosts.csv ## sshできるか確認
	@cat tmp/hosts.csv | cut -d',' -f1 | xargs -I{} bash -c 'echo "----[ {} ]" && ssh {} "ls"'

.PHONY: setup
setup: ## 各isu-serverのセットアップ
	@bash scripts/setup-apt-get.sh
	@bash scripts/setup-fluent-bit.sh
	@bash scripts/setup-mysql-users.sh

.PHONY: reup
reup: ## コンテナを再アップ
	@bash scripts/reup-containers.sh

################################################################################
# ポートフォワーディング for Loki
################################################################################
.PHONY: port-forward-3100-isu-1
port-forward-3100-isu-1: ## 3100番ポートをフォワード
	$(call port-forward-3100,isu-1)

.PHONY: port-forward-3100-isu-2
port-forward-3100-isu-2: ## 3100番ポートをフォワード
	$(call port-forward-3100,isu-2)

.PHONY: port-forward-3100-isu-3
port-forward-3100-isu-3: ## 3100番ポートをフォワード
	$(call port-forward-3100,isu-3)

.PHONY: port-forward-3100-isu-4
port-forward-3100-isu-4: ## 3100番ポートをフォワード
	$(call port-forward-3100,isu-4)

.PHONY: port-forward-3100-isu-5
port-forward-3100-isu-5: ## 3100番ポートをフォワード
	$(call port-forward-3100,isu-5)

################################################################################
# Kaizen
################################################################################
.PHONY: clean-logs
clean-logs: ## ログファイルを削除
	@bash scripts/clean-logs.sh

.PHONY: download-and-analyze-logs
download-and-analyze-logs: ## ログファイルをダウンロードして分析
	@bash scripts/download-and-analyze-logs.sh

.PHONY: alp-result
alp-result: ## alpの結果を表示
	@cat tmp/analysis/latest/analyzed-alp-nginx-access.log.*

.PHONY: slow-query-result
slow-query-result: ## slow-queryの結果を表示
	@cat tmp/analysis/latest/analyzed-pt-query-digest-slow.log.* | less

################################################################################
# Deploy
################################################################################
.PHONY: deploy-config
deploy-config: ## 各サーバに設定ファイルをデプロイ
	@bash scripts/deploy-config.sh

.PHONY: deploy-app
deploy-app: ## 各サーバにAppをデプロイ
	@bash scripts/deploy-app.sh

################################################################################
# Switch to golang app
################################################################################
.PHONY: switch-to-golang-isu-app
switch-to-golang-isu-app: ## golangのアプリケーションに切り替え
	@bash scripts/switch-to-golang-isu-app.sh

################################################################################
# Download
################################################################################
.PHONY: download
download: ## isucon関連の利用するファイルをダウンロード
	@bash scripts/download-webapp.sh
	@bash scripts/download-nginx.sh
	@bash scripts/download-mysql.sh
	@bash scripts/download-env.sh

################################################################################
# Info
################################################################################
.PHONY: show-services
show-services: ## isuconに関連があるサービス一覧表示
	@bash scripts/show-services.sh

.PHONY: show-table-counts
show-table-counts: ## isuconに関連があるdb.tableのカウント一覧
	@bash scripts/show-table-counts.sh

################################################################################
# Utility-Command help
################################################################################
.DEFAULT_GOAL := help

################################################################################
# マクロ
################################################################################
# Makefileの中身を抽出してhelpとして1行で出す
# $(1): Makefile名
# 使い方例: $(call help,{included-makefile})
define help
  grep -E '^[\.a-zA-Z0-9_-]+:.*?## .*$$' $(1) \
  | grep --invert-match "## non-help" \
  | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'
endef

# 指定されたhostに3100番のポートフォワーディング
# $(1): ホスト名
# 使い方例: $(call port-forward-3100,host名)
define port-forward-3100
  (grep '$(1)' tmp/isu-servers &> /dev/null && ssh $(1) -R 3100:localhost:3100 -N) || echo '$(1)がありません'
endef

################################################################################
# タスク
################################################################################
.PHONY: help
help: ## Make タスク一覧
	@echo '######################################################################'
	@echo '# Makeタスク一覧'
	@echo '# $$ make XXX'
	@echo '# or'
	@echo '# $$ make XXX --dry-run'
	@echo '######################################################################'
	@echo $(MAKEFILE_LIST) \
	| tr ' ' '\n' \
	| xargs -I {included-makefile} $(call help,{included-makefile})
