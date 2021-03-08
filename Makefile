hoogle: hoogle_gen shell.nix
	nix-shell shell.nix --attr plutus_docs_env --command 'hoogle server --local'

hoogle_gen: shell.nix
	nix-shell shell.nix --attr plutus_docs_env --command 'hoogle generate --local=$$PLUTUS_DOCS_PATH'
