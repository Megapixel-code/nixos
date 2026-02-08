{
  hostName,
  ...
}:
{
  xdg.configFile = {
    "mango/config.conf" = {
      force = true;
      text = ''
        source=~/.config/mango/main.conf
        source=~/.config/mango/hosts/${hostName}.conf
      '';
    };
  };
}
