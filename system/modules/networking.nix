{
  lib,
  config,
  user,
  ...
}:
{
  # id_ed25519
  # with :
  # -------begin ssh .......
  # id_ed25519.pub
  # with :
  # ed25519 dakjfldskjfa ivan@nixosmain

  config = lib.mkMerge [
    (lib.mkIf config.home-manager.users.${user}.my.networking.personal.enable {
      users.users.${user} = {
        extraGroups = [
          "networkmanager"
        ];
      };

      networking = {
        networkmanager.enable = true;
        wireless.iwd.enable = true; # needed for using impala network manager
      };

      # Configure network proxy if necessary
      # networking.proxy.default = "http://user:password@proxy:port/";
      # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

      services.openssh = {
        enable = false;
      };

      # Open ports in the firewall.
      # networking.firewall.allowedTCPPorts = [ ... ];
      # networking.firewall.allowedUDPPorts = [ ... ];
      # Or disable the firewall altogether.
      # networking.firewall.enable = false;
    })

    (lib.mkIf config.home-manager.users.${user}.my.networking.servers.enable {
      # TODO: add nnetworking ? maybe not needed
      # networking = {
      #   networkmanager.enable = true;
      #   wireless.iwd.enable = true; # needed for using impala network manager
      # };

      services.openssh = {
        enable = true;

        # added in the config in /etc/ssh/sshd_config
        authorizedKeysFiles = [
          config.sops.secrets."ssh/authorizedKeys/nixos-main".path
          config.sops.secrets."ssh/authorizedKeys/nixos-school".path
        ];

        extraConfig = "HostKey /run/secrets/ssh/privateKeys/personal";
      };
    })
  ];
}
