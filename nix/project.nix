{ lib, pkgs, inputs, ... }: lib.iogx.mkHaskellProject {
  cabalProject = pkgs.haskell-nix.cabalProject'
    {
      src = pkgs.haskell-nix.haskellLib.cleanSourceWith {
        name = "ogmios";
        src = "${inputs.ogmios}/server";
        filter = path: type:
          builtins.all (x: x) [
            (baseNameOf path != "package.yaml")
          ];
      };
      # `compiler-nix-name` upgrade policy: as soon as inputs.ogmios
      compiler-nix-name = lib.mkDefault "ghc96";
      inputMap = {
        "https://input-output-hk.github.io/cardano-haskell-packages" = inputs.iogx.inputs.CHaP;
      };
      sha256map = {
        "https://github.com/CardanoSolutions/cardano-ledger"."9ab8b326981a94d4b57cb0427709845ab67ef975" = "sha256-Aed1QrKsdY/srz0CX1x3yQ7NF+1vIwv+c0bRRw+Oi9M=";
      };
      modules = [
        {
          # FIXME ogmios unit tests are not passing
          packages.ogmios.components.tests.unit.doCheck = false;
        }
      ];
    };
}
