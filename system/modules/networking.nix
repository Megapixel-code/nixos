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

      # NOTE: taken from https://github.com/NixOS/nixpkgs/blob/ed142ab1b3a092c4d149245d0c4126a5d7ea00b0/nixos/modules/config/networking.nix#L175
      sops.secrets."networking/localHostsIp/router" = { };
      sops.templates."hosts" = {
        content =
          let
            cfg = config.networking;
            hostNames = # Note: The FQDN (canonical hostname) has to come first:
              lib.optional (cfg.hostName != "" && cfg.domain != null) "${cfg.hostName}.${cfg.domain}"
              ++ lib.optional (cfg.hostName != "") cfg.hostName; # Then the hostname (without the domain)
            strHostNames = lib.concatStringsSep " " hostNames;
          in
          ''
            127.0.0.1 localhost
            ${lib.optionalString cfg.enableIPv6 "::1 localhost"}
            127.0.0.2 ${strHostNames}
            ${config.sops.placeholder."networking/localHostsIp/router"} router
          '';
        path = "/etc/hosts";
        mode = "444"; # make it readable  TODO: make it readable only by group and root
      };

      # FIXME: add groups and change permissions to g+r
      sops.secrets."ssh/privateKeys/personal" = { };
      sops.secrets."ssh/publicKeys/personal" = { };
      sops.secrets."ssh/publicKeys/known_hosts" = { };
      system.activationScripts."ssh-personal-init".text = ''
        mkdir -p "/home/${user}/.ssh";

        cp "${config.sops.secrets."ssh/privateKeys/personal".path}" "/home/${user}/.ssh/id_ed25519";
        cp "${config.sops.secrets."ssh/publicKeys/personal".path}" "/home/${user}/.ssh/id_ed25519.pub";
        cp "${config.sops.secrets."ssh/publicKeys/known_hosts".path}" "/home/${user}/.ssh/known_hosts";

        chmod +r "/home/${user}/.ssh/id_ed25519";
        chmod +r "/home/${user}/.ssh/id_ed25519.pub";
        chmod +r "/home/${user}/.ssh/known_hosts";
      '';

      services.openssh = {
        enable = false;
      };

      # Configure network proxy if necessary
      # networking.proxy.default = "http://user:password@proxy:port/";
      # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

      # Open ports in the firewall.
      # networking.firewall.allowedTCPPorts = [ ... ];
      # networking.firewall.allowedUDPPorts = [ ... ];
      # Or disable the firewall altogether.
      # networking.firewall.enable = false;
    })

    (lib.mkIf config.home-manager.users.${user}.my.networking.servers.enable {
      networking = {
      };

      sops.secrets."ssh/privateKeys/servers" = { };
      services.openssh = {
        enable = true;
        openFirewall = true;
        # generateHostKeys = false; # opt seems to not exist
        hostKeys = [ ]; # unset this opt to not generate keys

        # added in the config in /etc/ssh/sshd_config
        settings = {
          PasswordAuthentication = false;
          PermitRootLogin = "no";
          HostKey = config.sops.secrets."ssh/privateKeys/servers".path;
        };
      };

      sops.secrets."ssh/publicKeys/personal" = {
        path = "/etc/ssh/authorized_keys.d/${user}";
        mode = "444";
      };
    })
  ];
}
