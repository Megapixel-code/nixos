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
  config = lib.mkIf config.my.custom-cursor.enable {
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
