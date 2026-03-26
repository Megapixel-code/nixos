{
  config,
  user,
  ...
}:
{
  sops = {
    defaultSopsFile = ../secrets/secrets.yaml;
    defaultSopsFormat = "yaml";
    age.keyFile = "${config.home-manager.users.${user}.xdg.configHome}/sops/age/keys.txt";
  };
}
