{
  lib,
  ...
}:
{
  my = {
    module-mango.enable = lib.mkDefault true;

    custom-cursor.enable = lib.mkDefault true;
    personal-networking.enable = lib.mkDefault true;
    module-bluetooth.enable = lib.mkDefault true;
    module-printing.enable = lib.mkDefault true;

    pkgs = {
      apps.enable = lib.mkDefault true;
      editors.enable = lib.mkDefault true;
      games.enable = lib.mkDefault true;

      utilities = {
        system.enable = lib.mkDefault true;
        user.enable = lib.mkDefault true;
      };
    };
  };
}
