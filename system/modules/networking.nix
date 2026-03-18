{
  lib,
  config,
  user,
  hostName,
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

      system.activationScripts."ssh-personal-init".text = ''
        mkdir -p "/home/${user}/.ssh";
        rm "/home/${user}/.ssh/id_ed25519*"
        cp "${config.sops.secrets."ssh/privateKeys/personal".path}" "/home/${user}/.ssh/id_ed25519";
        cp "${config.sops.secrets."ssh/publicKeys/${hostName}".path}" "/home/${user}/.ssh/id_ed25519.pub";
        chmod +r "/home/${user}/.ssh/id_ed25519";
        chmod +r "/home/${user}/.ssh/id_ed25519.pub";
      '';

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
        # generateHostKeys = false; # opt seems to not exist
        hostKeys = [ ]; # unset this opt to not generate keys

        # added in the config in /etc/ssh/sshd_config
        authorizedKeysFiles = [
          config.sops.secrets."ssh/publicKeys/nixos-main".path
          config.sops.secrets."ssh/publicKeys/nixos-school".path
        ];
        settings = {
          PasswordAuthentication = false;
          PermitRootLogin = "no";
          HostKey = "/run/secrets/ssh/privateKeys/servers";
        };
      };
    })
  ];
}
