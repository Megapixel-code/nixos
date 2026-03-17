{
  config,
  user,
  ...
}:
# let
#   secretUserName = "secrets";
# in
{
  sops = {
    defaultSopsFile = ../../secrets/secrets.yaml;
    defaultSopsFormat = "yaml";
    age.keyFile = "${config.home-manager.users.${user}.xdg.configHome}/sops/age/keys.txt";

    secrets."ssh/privateKeys/personal" = { };
    secrets."ssh/privateKeys/servers" = { };

    secrets."ssh/publicKeys/nixos-main" = { };
    secrets."ssh/publicKeys/nixos-school" = { };
    secrets."ssh/publicKeys/host1" = { };
  };

  # users = {
  #   users.${secretUserName} = {
  #     home = "/var/lib/${secretUserName}";
  #     createHome = true;
  #     isSystemUser = true;
  #     group = "${secretUserName}";
  #   };
  #
  #   groups.${secretUserName} = { };
  # };
  #
  # systemd.services =
  #   let
  #     serviceName = "authorizedKeys";
  #   in
  #   {
  #     # adds user@hostName to the end of the key
  #     ${serviceName} = {
  #       enable = true;
  #       wantedBy = [ "default.target" ];
  #       script = ''
  #         echo "$(cat ${
  #           config.sops.secrets."ssh/publicKeys/personal".path
  #         }) ${user}@${hostName}" > /var/lib/${secretUserName}/${serviceName}
  #       '';
  #       serviceConfig = {
  #         User = "${secretUserName}";
  #         WorkingDirectory = "/var/lib/${secretUserName}";
  #       };
  #     };
  #   };
}
