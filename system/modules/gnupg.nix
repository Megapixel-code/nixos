{
  config,
  pkgs,
  user,
  ...
}:
{
  programs.gnupg.agent = {
    enable = config.home-manager.users.${user}.my.pkgs.utilities.system.enable;
    pinentryPackage = pkgs.pinentry-tty; # used to read passwords
    # enableSSHSupport = true;
  };
}
