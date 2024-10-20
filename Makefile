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
# Download
################################################################################
.PHONY: download
download: ## isucon関連の利用するファイルをダウンロード
	@bash scripts/download-webapp.sh
	@bash scripts/download-nginx.sh
	@bash scripts/download-mysql.sh

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
