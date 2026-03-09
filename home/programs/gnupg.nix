{
  config,
  ...
}:
{
  programs.gpg = {
    enable = config.my.pkgs.utilities.system.enable;

    # follows xdg-data-dirs specification
    homedir = "${config.xdg.dataHome}/gnupg";

    settings = {
      use-agent = true;
    };
  };
}
