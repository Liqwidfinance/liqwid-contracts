 let

  bootstrap = import <nixpkgs> { };

  nixpkgs_git = builtins.fromJSON (builtins.readFile ./nixpkgs20_09.json);
  plutus_git = builtins.fromJSON (builtins.readFile ./plutus_rev.json);

  nixpkgs_src = bootstrap.fetchFromGitHub {
    owner = "NixOS";
    repo  = "nixpkgs";
    inherit (nixpkgs_git) rev sha256;
  };

  plutus_src = bootstrap.fetchFromGitHub {
    owner = "input-output-hk";
    repo = "plutus";
    inherit (plutus_git) rev sha256;
  };

  nixpkgs = import nixpkgs_src {  };

  plutus_docs = (import plutus_src { }).docs.combined-haddock;

  plutus_docs_env = nixpkgs.stdenv.mkDerivation {
    name = "plutus_docs_env";
    propagatedBuildInputs = [ plutus_docs nixpkgs.haskellPackages.hoogle];
    PLUTUS_DOCS_PATH = plutus_docs;
  };
in
{
  inherit plutus_docs_env;
}
