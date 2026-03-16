{
  config,
  user,
  hostName,
  ...
}:
let
  secretUserName = "secrets";
in
{
  sops = {
    defaultSopsFile = ../../secrets/secrets.yaml;
    defaultSopsFormat = "yaml";
    age.keyFile = "${config.home-manager.users.${user}.xdg.configHome}/sops/age/keys.txt";

    secrets."ssh/privateKeys/personal" = { };
    secrets."ssh/authorizedKeys/nixos-main" = { };
    secrets."ssh/authorizedKeys/nixos-school" = { };
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
  #           config.sops.secrets."ssh/authorizedKeys/personal".path
  #         }) ${user}@${hostName}" > /var/lib/${secretUserName}/${serviceName}
  #       '';
  #       serviceConfig = {
  #         User = "${secretUserName}";
  #         WorkingDirectory = "/var/lib/${secretUserName}";
  #       };
  #     };
  #   };
}
