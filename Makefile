# This makefile should be
# called from inside the nix-shell environment
#
hoogle:
	hoogle server --local

pab_servers:
	@echo "Starting plutus servers."
	plutus-pab --config=${PAB_CONFIG_FILE} all-servers

pab_db:
	@echo "Generating pab db at ${PAB_DB_PATH}"
	plutus-pab --config=${PAB_CONFIG_FILE} migrate

install_contracts:
	plutus-pab --config=${PAB_CONFIG_FILE} contracts install --path "$(shell stack path --local-install-root)/bin/liqwid-contracts-pab"
# plutus-pab --config=${PAB_CONFIG_FILE} contracts install STACK OUTPUT GOES HERE

contracts:
	stack build

liquid-contracts.cabal: package.yaml
	hpack -f
