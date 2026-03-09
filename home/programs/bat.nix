{
  config,
  ...
}:
{
  programs.bat = {
    enable = config.my.pkgs.utilities.user.enable;

    config = {
      # run `bat --help` to get a list of all possible configuration options.

      # batcat --list-themes
      theme = "base16";
      tabs = "3";
      color = "always";
      style = "auto,+header-filesize";

      # Syntax mappings: map a certain filename pattern to a language.
      #   Example 1: use the C++ syntax for Arduino .ino files
      #   Example 2: Use ".gitignore"-style highlighting for ".ignore" files
      # --map-syntax "*.ino:C++"
      # --map-syntax ".ignore:Git Ignore"
      # map-syntax = [
      #   "*.ino:C++"
      #   ".ignore:Git Ignore"
      # ];
    };
  };
}
