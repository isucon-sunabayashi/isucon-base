.PHONY: build-cfn
build-cfn: cloudformation.yml ## CFnファイルをbuild
	@([ -e tmp/cloudformation.yml ] && echo 'build済みです') || (echo 'buildします' && bash scripts/build-cfn.sh)
	@diff -ur cloudformation.yml tmp/cloudformation.yml

.PHONY: clean
clean: ## 掃除
	@rm cloudformation.yml
	@rm -rf tmp/*

.PHONY: bench
bench: ## benchmarkerを実行
	@echo 'ISUNARABEで実行してください'

.PHONY: check-authorized-keys
check-authorized-keys: cloudformation.yml ## ISUNARABEに登録する時のSSHの公開鍵
	$(eval SETUP_TOKEN := $(shell cat cloudformation.yml | yq --input-format yaml --output-format json | jq -r '.Parameters.SetupToken.Default'))
	@echo '公開鍵が出力されない場合: cloudformation.ymlが古い可能性があります。 make cleanしてやり直してください'
	@curl -s -H "Authorization: Bearer ${SETUP_TOKEN}" "https://api.isunarabe.org/api/setup/authorized_keys"

.PHONY: show-hosts
show-hosts: ## /etc/hostsに追加する記述を表示
	@bash scripts/show-hosts.sh

.PHONY: replace-pem
replace-pem: ## nginxの証明書をreplaceして、再起動
	@bash scripts/replace-pem.sh

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
