{
  config,
  ...
}:
{
  programs.nh = {
    enable = config.my.pkgs.utilities.system.enable;
  };
}
