# This makefile should be
# called from inside the nix-shell environment
#
hoogle:
	hoogle server --local

pab_servers: pab_db install_contracts
	@echo "Starting plutus servers."
	plutus-pab --config=${PAB_CONFIG_FILE} all-servers

pab_db:
	@echo "Generating pab db at ${PAB_DB_PATH}"
	plutus-pab --config=${PAB_CONFIG_FILE} migrate

install_contracts: pab_db contracts
# plutus-pab --config=${PAB_CONFIG_FILE} contracts install STACK OUTPUT GOES HERE

contracts: liquid-contracts.cabal
	stack build

liquid-contracts.cabal: package.yaml
	hpack -f
