.PHONY: $(shell sed -n -e '/^$$/ { n ; /^[^ .\#][^ ]*:/ { s/:.*$$// ; p ; } ; }' $(MAKEFILE_LIST))

root_dir := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))

help:
	 @echo "$$(grep -hE '^\S+:.*##' $(MAKEFILE_LIST) | sed -e 's/:.*##\s*/:/' -e 's/^\(.\+\):\(.*\)/\\x1b[36m\1\\x1b[m:\2/' | column -c2 -t -s :)"

meta-update: ## Clone any repos that exist in your .meta file but aren't cloned locally
	@meta git update

pull: ## Run git pull --all --rebase --autostash on all repos
	@meta exec "git pull --all --rebase --autostash" --parallel

mainline: ## Switch all repos to mainline (main/master)
	@meta exec "$(root_dir)script/switch_to_mainline.sh"  --parallel

build: ## Run ./gradlew build
	@meta exec "$(root_dir)script/build.sh" --exclude "eessi-pensjon"

gw: ## Run ./gradlew <target> - (e.g run using make gw clean build)
	@meta exec "$(root_dir)script/gw.sh $(filter-out $@,$(MAKECMDGOALS))" --exclude "eessi-pensjon,eessi-pensjon-saksbehandling-ui" --parallel

upgrade-gradle: ## Upgrade gradle in all projects - usage GRADLEW_VERSION=x.x.x make upgrade-gradle
	@meta exec "$(root_dir)script/upgrade_gradle.sh" --exclude "eessi-pensjon,eessi-pensjon-saksbehandling-ui"
	script/upgrade_gradle.sh

upgrade-dependency: ## Upgrade dep in all projects usage DEPENDENCY=group-colon-name make upgrade-dependency
	@meta exec "$(root_dir)script/upgrade_dependency.sh | tail -n1" --exclude eessi-pensjon --parallel

upgrade-safe-dependencies: ## Upgrade "safe" (test) dependencies in all projects (see script/safe_dependency_updates.sh)
	@meta exec "$(root_dir)script/upgrade_safe_dependencies.sh | grep -A 100 'Commits:'" --exclude eessi-pensjon

check-if-up-to-date: ## check if all changes are commited and pushed - and that we are on the mainline with all changes pulled
	@meta exec "$(root_dir)script/check_if_we_are_up_to_date.sh" --exclude "eessi-pensjon" # --parallel seemed to skip some projects(?!)

list-local-commits: ## shows local, unpushed, commits
	@meta exec "git log --oneline origin/HEAD..HEAD | cat"

upgradable-dependencies-report: ## Lists dependencies that are outdated - across all projects - then sorted uniquely
	@make gw "dependencyUpdates --refresh-dependencies" 2>&1 | grep '\->' | grep -v "Gradle" | cut -d' ' -f3,4,6 | sed 's#\[##' | sed 's#\]##' | sort | uniq

prepush-review: ## let's you look at local commits across all projects and decide if you want to push
	@meta exec 'output=$$(git log --oneline origin/HEAD..HEAD) ; [ -n "$$output" ] && (git show --oneline origin/HEAD..HEAD | cat && echo "Pushe? (y/N)" && read a && [ "$$a" = "y" ] && git push) || true' --exclude eessi-pensjon

install-template-engine:
	@echo "Installerer jinja2 (template engine)..."
	@brew install --quiet jinja2-cli

generate-files: install-template-engine ## Oppdaterer filer fra templates i alle prosjekter
	@meta exec "$(root_dir)script/generate_files.sh $(filter-out $@,$(MAKECMDGOALS))" --exclude eessi-pensjon

upgrade-ep-libraries-part-1: ## First (of nine) steps in upgrading the ep-*-libraries dependencies ...
	@meta exec "./gradlew dependencyUpdates --refresh-dependencies | tail -n1" --parallel --exclude eessi-pensjon,eessi-pensjon-saksbehandling-ui,ep-meta-analyse
	@meta exec "$(root_dir)script/upgrade_dependency.sh no.nav.eessi.pensjon:ep-logging | tail -n1" --parallel --include-only ep-security-sts,ep-pensjonsinformasjon,ep-eux,ep-kodeverk,ep-personoppslag
	@meta exec "$(root_dir)script/upgrade_dependency.sh no.nav.eessi.pensjon:ep-metrics | tail -n1" --parallel --include-only ep-security-sts,ep-pensjonsinformasjon,ep-eux,ep-kodeverk,ep-personoppslag

upgrade-ep-libraries-part-2: ## ... second ...
	$(MAKE) prepush-review

upgrade-ep-libraries-part-3: ## ... third ...
	@echo "Vent til bibliotek er bygget og oppdatert på github package repo"

upgrade-ep-libraries-part-4: ## ... fourth  ...
	$(MAKE) pull
	@meta exec "$(root_dir)script/upgrade_dependency.sh no.nav.eessi.pensjon:ep-logging | tail -n1" --parallel --exclude eessi-pensjon,ep-meta-analyse
	@meta exec "$(root_dir)script/upgrade_dependency.sh no.nav.eessi.pensjon:ep-metrics | tail -n1" --parallel --exclude eessi-pensjon,ep-meta-analyse
	@meta exec "git push" --exclude eessi-pensjon
	@echo "Vent til app'er er deployet og sjekk at det gikk bra"

upgrade-ep-libraries-part-5: ## ... fifth ...
	$(MAKE) pull
	@meta exec "./gradlew dependencyUpdates --refresh-dependencies | tail -n1" --parallel --exclude eessi-pensjon,eessi-pensjon-saksbehandling-ui,ep-meta-analyse
	@meta exec "$(root_dir)script/upgrade_dependency.sh no.nav.eessi.pensjon:ep-pensjonsinformasjon | tail -n1" --parallel --exclude eessi-pensjon,ep-meta-analyse
	@meta exec "git push" --exclude eessi-pensjon
	@echo "Vent til app'er er deployet og sjekk at det gikk bra"

upgrade-ep-libraries-part-6: ## ... sixth ...
	$(MAKE) pull
	@meta exec "$(root_dir)script/upgrade_dependency.sh no.nav.eessi.pensjon:ep-personoppslag | tail -n1"  --parallel --exclude eessi-pensjon,ep-meta-analyse
	@meta exec "git push" --exclude eessi-pensjon
	@echo "Vent til app'er er deployet og sjekk at det gikk bra"

upgrade-ep-libraries-part-7: ## ... seventh ...
	$(MAKE) pull
	@meta exec "$(root_dir)script/upgrade_dependency.sh no.nav.eessi.pensjon:ep-kodeverk | tail -n1"  --parallel --exclude eessi-pensjon,ep-meta-analyse
	@meta exec "git push" --exclude eessi-pensjon
	@echo "Vent til app'er er deployet og sjekk at det gikk bra"

upgrade-ep-libraries-part-8: ## ... eigth and final step.
	$(MAKE) pull
	@meta exec "$(root_dir)script/upgrade_dependency.sh no.nav.eessi.pensjon:ep-eux | tail -n1"  --parallel --exclude eessi-pensjon,ep-meta-analyse
	@meta exec "$(root_dir)script/upgrade_dependency.sh no.nav.eessi.pensjon:ep-security-sts | tail -n1"  --parallel --include-only eessi-pensjon-onprem-proxy
	@meta exec "git push" --exclude eessi-pensjon
	@echo "Vent til app'er er deployet og sjekk at det gikk bra"
	@echo "Deretter er du done!"
