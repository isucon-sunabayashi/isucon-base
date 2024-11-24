.PHONY: build-cfn
build-cfn: ## CFnファイルをbuild
	@([ -e tmp/cloudformation.yml ] && echo 'build済みです') || (echo 'buildします' && bash scripts/build-cfn.sh)
	@diff -ur cloudformation.template.yml tmp/cloudformation.yml

.PHONY: clean
clean: ## 掃除
	@rm -rf tmp/*

.PHONY: bench
bench: ## benchmarkerを実行
	ssh isu-bench "private_isu.git/benchmarker/bin/benchmarker -u private_isu.git/benchmarker/userdata -t http://192.168.1.10/"

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
