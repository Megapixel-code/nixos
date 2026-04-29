{
  inputs,
  system,
  user,
  ...
}:
let
  nixpkgs = inputs.nixpkgs;
  lib = nixpkgs.lib;
  pkgs = nixpkgs.legacyPackages.${system};
in
{
  nixpkgs.config.allowUnfree = true;

  makeWrapper =
    {
      package,
      package_exec,
      script,
    }:
    pkgs.symlinkJoin {
      name = package;
      paths = [
        (pkgs.writers.writeBashBin package_exec (
          script
          + ''
            exec ${package}/bin/${package_exec} "$@"
          ''
        ))
        package
      ];
    };
}
