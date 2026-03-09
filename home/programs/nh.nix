{
  config,
  ...
}:
{
  programs.nh = {
    enable = config.my.pkgs.utilities.user.enable;
  };
}
