{
  description = "Nix flake for ogmios";
  inputs = {
    hackage = {
      url = "github:input-output-hk/hackage.nix";
      flake = false;
    };
    CHaP = {
      url = "github:IntersectMBO/cardano-haskell-packages?ref=repo";
      flake = false;
    };
    iogx = {
      url = "github:input-output-hk/iogx";
      inputs = {
        hackage.follows = "hackage";
        CHaP.follows = "CHaP";
      };
    };
    nixpkgs.follows = "iogx/nixpkgs";
    cardano-world.url = "github:IntersectMBO/cardano-world";
    cardano-node.follows = "cardano-world/cardano-node";
    ogmios = {
      url = "git+https://github.com/CardanoSolutions/ogmios?tag=v6.8.0&submodules=1";
      flake = false;
    };
  };
  outputs = inputs@{ self, ... }:
    let
      # TODO enable ogmios supported OS's
      systems = [ "x86_64-linux" ];
    in
    inputs.iogx.lib.mkFlake {
      inherit inputs systems;
      repoRoot = ./.;
      outputs = import ./nix/outputs.nix;
      flake = import ./nix/nixos.nix self;
    };
  nixConfig = {
    extra-substituters = [
      "https://cache.iog.io"
    ];
    extra-trusted-public-keys = [
      "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ="
    ];
    allow-import-from-derivation = true;
  };
}

