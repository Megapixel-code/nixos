{
  pkgs,
  lib,
  config,
  ...
}:

let
  cursorPackage = pkgs.openzone-cursors;
  cursorName = "OpenZone_Black";
  cursorSize = 18;
in
{
  options = {
    custom_cursor.enable = lib.mkEnableOption "enable custom_cursor";
  };

  config = lib.mkIf config.custom_cursor.enable {
    home.pointerCursor = {
      package = cursorPackage;
      name = cursorName;
      size = cursorSize;
      x11.enable = true;
      gtk.enable = true;
    };

    gtk.cursorTheme = {
      package = cursorPackage;
      name = cursorName;
      size = cursorSize;
    };
  };
}
