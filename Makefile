switch: ## home-manager switch
	home-manager switch --flake .

clean: ## clean
	find . -name \*~ | xargs rm -f

dev: ## nix develop
	nix develop

help: ## help
	-@grep --extended-regexp '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
	| sed 's/^Makefile://1' \
	| awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-18s\033[0m %s\n", $$1, $$2}'
