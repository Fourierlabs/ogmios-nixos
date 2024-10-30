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
        "https://github.com/CardanoSolutions/cardano-ledger"."8112c9872f52e5147e28fbdd76a034cdb6eb7fea" = "sha256-qzey+5bwR1RpU1fx0jOMpaCAjyL4iFMwE7+PQ5kr/1M=";
      };
      modules = [
        {
          # FIXME ogmios unit tests are not passing
          packages.ogmios.components.tests.unit.doCheck = false;
          # FIXME hjsonschema tests not building
          packages.hjsonschema.components.tests.local.buildable = lib.mkForce false;
          packages.hjsonschema.components.tests.spec.buildable = lib.mkForce false;
          packages.hjsonschema.components.tests.remote.buildable = lib.mkForce false;
        }
      ];
    };
}
