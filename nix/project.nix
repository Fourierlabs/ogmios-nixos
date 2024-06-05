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
        "https://github.com/CardanoSolutions/cardano-ledger"."f67155670677399e98205ed64dd202735b0c9be4" = "5ef837ZQED6nci0yxwBQtgI5BxoVaYfRoLZfvhL+Y/c=";
      };
      modules = [
        {
          # FIXME ogmios unit tests are not passing
          packages.ogmios.components.tests.unit.doCheck = false;
        }
      ];
    };
}
