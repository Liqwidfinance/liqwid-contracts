let

  # Use master for now, we could pin this like with plutus;
  #haskellNix_src = builtins.fetchTarball https://github.com/input-output-hk/haskell.nix/archive/master.tar.gz;
  #haskellNix = (import haskellNix_src) {};

  ### Pin nixpkgs 20.09 with haskellNix overlays and config added
  #nixpkgs_src = haskellNix.sources.nixpkgs2009;
  #nixpkgs = (import nixpkgs_src) haskellNix.nixpkgsArgs;

  bootstrap = import <nixpkgs> {} ;

  # Plutus
  plutus_git = builtins.fromJSON (builtins.readFile ./plutus_rev.json);
  plutus_src = bootstrap.fetchFromGitHub {
    owner = "input-output-hk";
    repo = "plutus";
    inherit (plutus_git) rev sha256;
  };

  plutus = (import plutus_src) {};



in

plutus.plutus.haskell.project.shellFor {
  # Select packages who's dependencies should be added to the shell env
  packages = ps : [];

  # Select packages which should be added to the shell env, with their dependencies
  additional = ps: with ps; [
    plutus-pab plutus-tx plutus-tx-plugin
    plutus-contract
    plutus-ledger plutus-ledger-api
    playground-common
  ];

  # Local hoogle index of all packages
  withHoogle = true;

  # Extra haskell tools (arg passed on to mkDerivation)
  # Using the plutus.pkgs to use nixpkgs version from plutus (nixpkgs-unstable, mostly)
  propagatedBuildInputs = with plutus.pkgs; [
    ormolu stack hlint haskell-language-server
  ];


 #tools = {
 #   stack  = { version = "2.5.1.1";   };
 #   ormolu = { version = "0.1.2.0"; };
 #   hlint  = { version = "3.2.7";   };
 # };

}
