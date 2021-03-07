{ nixpkgs ? <nixpkgs> }:
let
  pkgs = import
    (builtins.fetchTarball {
      name = "nixos-20.09";
      url = https://github.com/NixOS/nixpkgs/archive/20.09.tar.gz;
    })
    { };
    runtimeGhc = pkgs.haskell.packages.ghc8102.ghcWithPackages (ps: with ps; 
    [ 
      zlib 
    ]
    );
  fetchFromGitHub = pkgs.fetchFromGitHub;

  plutusMonoRepo = fetchFromGitHub { 
    owner = "input-output-hk";
    repo = "plutus";
    rev = "e4d8d1c298faa52fa874131af2506ee6216488a2";
    sha256 = "0nkk492aa7pr0d30vv1aw192wc16wpa1j02925pldc09s9m9i0r3";
  };

  plutus = import plutusMonoRepo;



  haskellPackages = pkgs.haskell.packages.ghc8102.override {
    overrides = {
      plutus-core = plutus.haskell.packages.plutus-core;
      plutus-tx = plutus.haskell.packages.plutus-tx;
    };
  };
in 
  rec { liqwid-contracts = haskellPackages.callCabal2nix "liqwid-contracts" (./.) {};
  }


