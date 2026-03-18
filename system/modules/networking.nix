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

      # FIXME: add groups and change permissions to g+r
      system.activationScripts."ssh-personal-init".text = ''
        mkdir -p "/home/${user}/.ssh";

        cp "${config.sops.secrets."ssh/privateKeys/personal".path}" "/home/${user}/.ssh/id_ed25519";
        cp "${config.sops.secrets."ssh/publicKeys/personal".path}" "/home/${user}/.ssh/id_ed25519.pub";
        cp "${config.sops.secrets."ssh/publicKeys/known_hosts".path}" "/home/${user}/.ssh/known_hosts";

        chmod +r "/home/${user}/.ssh/id_ed25519";
        chmod +r "/home/${user}/.ssh/id_ed25519.pub";
        chmod +r "/home/${user}/.ssh/known_hosts";
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
        settings = {
          PasswordAuthentication = false;
          PermitRootLogin = "no";
          HostKey = "/run/secrets/ssh/privateKeys/servers";
        };
      };

      system.activationScripts."authorized-keys-files".text = ''
        mkdir -p "/etc/ssh/authorized_keys.d";
        cp ${config.sops.secrets."ssh/publicKeys/personal".path} "/etc/ssh/authorized_keys.d/${user}";
        chmod +r "/etc/ssh/authorized_keys.d/${user}";
      '';
    })
  ];
}
