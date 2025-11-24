{ pkgs, ... }:
let
  cursorPackage = pkgs.openzone-cursors;
  cursorName = "OpenZone_Black";
  cursorSize = 18;
in
{
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
}
