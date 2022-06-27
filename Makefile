.PHONY: $(shell sed -n -e '/^$$/ { n ; /^[^ .\#][^ ]*:/ { s/:.*$$// ; p ; } ; }' $(MAKEFILE_LIST))

root_dir := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))

help:
	 @echo "$$(grep -hE '^\S+:.*##' $(MAKEFILE_LIST) | sed -e 's/:.*##\s*/:/' -e 's/^\(.\+\):\(.*\)/\\x1b[36m\1\\x1b[m:\2/' | column -c2 -t -s :)"

meta-update: ## Clone any repos that exist in your .meta file but aren't cloned locally
	@meta git update

pull: ## Run git pull --all --rebase --autostash on all repos
	@meta exec "$(root_dir)script/pull_from_repo.sh"

mainline: ## Switch all repos to mainline (main/master)
	@meta exec "$(root_dir)script/switch_to_mainline.sh"

build: ## Run ./gradlew build
	@meta loop "$(root_dir)script/build.sh" --exclude "eessi-pensjon"

gw: ## Run ./gradlew <target> - (e.g run using: make gw clean build)
	@meta loop "$(root_dir)script/gw.sh $(filter-out $@,$(MAKECMDGOALS))" --exclude "eessi-pensjon" --parallel

upgrade-gradle: ## Upgrade gradle in all projects - usage GRADLEW_VERSION=x.x.x make upgrade-gradle
	@meta exec "$(root_dir)script/upgrade_gradle.sh" --exclude "eessi-pensjon"
	script/upgrade_gradle.sh
