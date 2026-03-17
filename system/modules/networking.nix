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
        enable = true;
        authorizedKeysInHomedir = false;
        openFirewall = config.services.openssh.enable; # FIXME: cant set it to false ?

        knownHosts.servers = {
          publicKey = "balls";
        };

        # added in /etc/ssh/
        extraConfig = "HostKey /run/secrets/ssh/privateKeys/personal";
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
        openFirewall = true;

        # added in the config in /etc/ssh/sshd_config
        authorizedKeysFiles = [
          config.sops.secrets."ssh/publicKeys/nixos-main".path
          config.sops.secrets."ssh/publicKeys/nixos-school".path
        ];
        extraConfig = "HostKey /run/secrets/ssh/privateKeys/servers";
      };
    })
  ];
}
