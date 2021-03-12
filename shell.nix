let

  # Use master for now, we could pin this like with plutus;
  #haskellNix_src = builtins.fetchTarball https://github.com/input-output-hk/haskell.nix/archive/master.tar.gz;
  #haskellNix = (import haskellNix_src) {};

  #### Pin nixpkgs 20.09 with haskellNix overlays and config added
  #nixpkgs_src = haskellNix.sources.nixpkgs-unstable;
  #nixpkgs = (import nixpkgs_src) haskellNix.nixpkgsArgs;
  bootstrap = import <nixpkgs> {} ;

  # Plutus
  plutus_git = builtins.fromJSON (builtins.readFile ./plutus_rev.json);
  plutus_src = bootstrap.fetchFromGitHub {
    owner = "input-output-hk";
    repo = "plutus";
    fetchSubmodules = true;
    leaveDotGit = true;
    inherit (plutus_git) rev sha256;
  };

  plutus = (import plutus_src) {};

  plutus_pab_exe = plutus.plutus-pab.pab-exes.plutus-pab;

  plutus_pab_client    = plutus.plutus-pab.client;
  plutus_pab_conf      = (import ./pab_conf.nix) // { client = plutus_pab_client; };
  plutus_pab_conf_file = plutus.plutus-pab.mkConf plutus_pab_conf;

  # The plutus build by default misses this
  plutus_ledger_with_docs = plutus.plutus.haskell.packages.plutus-ledger.components.library.override {
    doHaddock = true;
    configureFlags = ["-f defer-plugin-errors"];
  };

in

# Maybe it would be easier to just call the nix shell in plutus/shell.nix ...
plutus.plutus.haskell.project.shellFor {
  # Select packages who's dependencies should be added to the shell env
  packages = ps : [];

  # Select packages which should be added to the shell env, with their dependencies
  # Should try and get the extra cardano dependencies in here...
  additional = ps: with ps; [
    plutus-pab plutus-tx plutus-tx-plugin
    plutus-contract
    plutus-ledger-api plutus_ledger_with_docs
    plutus-core
    playground-common
    prettyprinter-configurable
    plutus-use-cases
    freer-extras

    # cardano-base
    cardano-binary
    cardano-slotting

    cardano-crypto

    # cardano-prelude
    cardano-prelude
    cardano-prelude-test

    # ouroboros-network
    ouroboros-network
    ouroboros-network-framework
  ];

  withHoogle = true;

  # Extra haskell tools (arg passed on to mkDerivation)
  # Using the plutus.pkgs to use nixpkgs version from plutus (nixpkgs-unstable, mostly)
  propagatedBuildInputs = with plutus.pkgs; [
    # Haskell Tools
    ormolu stack hlint haskell-language-server

    # Pab
    plutus_pab_exe plutus_pab_client

  ];

  buildInputs = [
    plutus.pkgs.zlib
  ];

  PAB_CONFIG_FILE = plutus_pab_conf_file;
  PAB_CLIENT_PATH = plutus_pab_client;
  PAB_DB_PATH     = plutus_pab_conf.db-file;

  PLUTUS_GAMe = plutus.plutus-game;

}
