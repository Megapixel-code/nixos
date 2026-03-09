{
  lib,
  ...
}:
{
  imports = [
    ../personal-home-defaults.nix
  ];

  my.pkgs = {
    editors.enable = lib.mkForce false;
    games.enable = lib.mkForce false;
  };
}
