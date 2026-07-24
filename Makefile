.PHONY: $(shell sed -n -e '/^$$/ { n ; /^[^ .\#][^ ]*:/ { s/:.*$$// ; p ; } ; }' $(MAKEFILE_LIST))

root_dir := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
# Name of the meta-repo's own directory, so we can always exclude it from
# `meta exec` runs (it's not a project in .meta but meta exec still visits it).
# Derived dynamically so this keeps working if the repo is cloned under a
# different name (e.g. eessi-pensjon-new).
CURRENT_DIR := $(notdir $(patsubst %/,%,$(root_dir)))

help:
	 @echo "$$(grep -hE '^\S+:.*##' $(MAKEFILE_LIST) | sed -e 's/:.*##\s*/:/' -e 's/^\(.\+\):\(.*\)/\\x1b[36m\1\\x1b[m:\2/' | column -c2 -t -s :)"

meta-update: ## Clone any repos that exist in your .meta file but aren't cloned locally
	@meta git update

pull: ## Run git pull --all --rebase --autostash on all repos
	@meta exec "git pull --all --rebase --autostash" --parallel

mainline: ## Switch all repos to mainline (main/master)
	@meta exec "$(root_dir)script/switch_to_mainline.sh"  --parallel

build: ## Run ./gradlew build
	@meta exec "$(root_dir)script/build.sh" --exclude "$(CURRENT_DIR)"

gw: ## Run ./gradlew <target> - (e.g run using make gw clean build)
	@meta exec "$(root_dir)script/gw.sh $(filter-out $@,$(MAKECMDGOALS))" --exclude "$(CURRENT_DIR),eessi-pensjon-saksbehandling-ui" --parallel

upgrade-gradle: ## Upgrade gradle in all projects - usage GRADLEW_VERSION=x.x.x make upgrade-gradle
	@meta exec "$(root_dir)script/upgrade_gradle.sh" --exclude "$(CURRENT_DIR),eessi-pensjon-saksbehandling-ui"
	script/upgrade_gradle.sh

upgrade-dependency: ## Upgrade dep in all projects usage DEPENDENCY=group-colon-name make upgrade-dependency
	@meta exec "$(root_dir)script/upgrade_dependency.sh | tail -n1" --exclude $(EP_LIBRARIES_SKIP) --parallel

upgrade-safe-dependencies: ## Upgrade "safe" (test) dependencies in all projects (see script/safe_dependency_updates.sh)
	@meta exec "$(root_dir)script/upgrade_safe_dependencies.sh | grep -A 100 'Commits:'" --exclude $(CURRENT_DIR)

check-if-up-to-date: ## check if all changes are commited and pushed - and that we are on the mainline with all changes pulled
	@meta exec "$(root_dir)script/check_if_we_are_up_to_date.sh" --exclude "$(CURRENT_DIR)" # --parallel seemed to skip some projects(?!)

list-local-commits: ## shows local, unpushed, commits
	@meta exec "git log --oneline origin/HEAD..HEAD | cat"

upgradable-dependencies-report: ## Lists dependencies that are outdated - across all projects - then sorted uniquely
	@make gw "dependencyUpdates --refresh-dependencies" 2>&1 | grep '\->' | grep -v "Gradle" | cut -d' ' -f3,4,6 | sed 's#\[##' | sed 's#\]##' | sort | uniq

prepush-review: ## let's you look at local commits across all projects and decide if you want to push
	@meta exec 'output=$$(git log --oneline origin/HEAD..HEAD) ; [ -n "$$output" ] && (git show --oneline origin/HEAD..HEAD | cat && echo "Pushe? (y/N)" && read a && [ "$$a" = "y" ] && git push) || true' --exclude $(CURRENT_DIR)

install-template-engine:
	@echo "Installerer jinja2 (template engine)..."
	@brew install --quiet jinja2-cli

generate-files: install-template-engine ## Oppdaterer filer fra templates i alle prosjekter
	@meta exec "$(root_dir)script/generate_files.sh $(filter-out $@,$(MAKECMDGOALS))" --exclude $(CURRENT_DIR)

setup-githooks: ## Configure git hooks for all repos with a .githooks folder
	@for repo in */; do \
		if [ -d "$$repo/.git" ] && [ -d "$$repo/.githooks" ]; then \
			echo "Configuring hooks in $$repo"; \
			(cd "$$repo" && git config core.hooksPath .githooks && chmod +x .githooks/prepare-commit-msg); \
		fi; \
	done

EP_LIBRARIES_SKIP := $(CURRENT_DIR),eessi-pensjon-saksbehandling-ui,ep-meta-analyse,fetch-api,tabell,land-verktoy,landvelger,flagg-ikoner

upgrade-ep-libraries-part-1: ## First (of eight) steps in upgrading the ep-*-libraries dependencies ...
	@meta exec "./gradlew dependencyUpdates --refresh-dependencies | tail -n1" --parallel --exclude $(EP_LIBRARIES_SKIP)
	@meta exec "$(root_dir)script/upgrade_dependency.sh no.nav.eessi.pensjon:ep-logging | tail -n1" --parallel --include-only ep-eux,ep-kodeverk,ep-personoppslag,ep-routing
	@meta exec "$(root_dir)script/upgrade_dependency.sh no.nav.eessi.pensjon:ep-metrics | tail -n1" --parallel --include-only ep-eux,ep-kodeverk,ep-personoppslag,ep-routing

upgrade-ep-libraries-part-2: ## ... second ...
	$(MAKE) prepush-review

upgrade-ep-libraries-part-3: ## ... third ...
	@echo "Vent til bibliotek er bygget og oppdatert på github package repo"

_upgrade-ep-lib: # internal helper - usage: LIB=no.nav.eessi.pensjon:ep-xxx make _upgrade-ep-lib
	@meta exec "$(root_dir)script/upgrade_dependency.sh $(LIB) | tail -n1" --parallel --exclude $(EP_LIBRARIES_SKIP)

upgrade-ep-libraries-part-4: ## ... fourth  ...
	$(MAKE) pull
	$(MAKE) _upgrade-ep-lib LIB=no.nav.eessi.pensjon:ep-logging
	$(MAKE) _upgrade-ep-lib LIB=no.nav.eessi.pensjon:ep-metrics
	@meta exec "git push" --exclude $(EP_LIBRARIES_SKIP)
	@echo "Vent til app'er er deployet og sjekk at det gikk bra"

upgrade-ep-libraries-part-5: ## ... fifth ...
	$(MAKE) pull
	$(MAKE) _upgrade-ep-lib LIB=no.nav.eessi.pensjon:ep-eux
	@meta exec "git push" --exclude $(EP_LIBRARIES_SKIP)
	@echo "Vent til app'er er deployet og sjekk at det gikk bra"

upgrade-ep-libraries-part-6: ## ... sixth ...
	$(MAKE) pull
	$(MAKE) _upgrade-ep-lib LIB=no.nav.eessi.pensjon:ep-personoppslag
	@meta exec "git push" --exclude $(EP_LIBRARIES_SKIP)
	@echo "Vent til app'er er deployet og sjekk at det gikk bra"

upgrade-ep-libraries-part-7: ## ... seventh ...
	$(MAKE) pull
	$(MAKE) _upgrade-ep-lib LIB=no.nav.eessi.pensjon:ep-kodeverk
	@meta exec "git push" --exclude $(EP_LIBRARIES_SKIP)
	@echo "Vent til app'er er deployet og sjekk at det gikk bra"

upgrade-ep-libraries-part-8: ## ... eighth and final step.
	$(MAKE) pull
	$(MAKE) _upgrade-ep-lib LIB=no.nav.eessi.pensjon:ep-routing
	@meta exec "git push" --exclude $(EP_LIBRARIES_SKIP)
	@echo "Vent til app'er er deployet og sjekk at det gikk bra"
	@echo "Deretter er du done!"
