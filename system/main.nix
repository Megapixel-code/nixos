# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

# github search : "$thing language:nix"

{
  pkgs,
  lib,
  config,
  user,
  ...
}:

{
  imports = [
    ./environement.nix
    ./keyboard.nix

    ./pkgs/packages.nix
    ./pkgs/programs/gnupg-agent.nix
  ];

  config = lib.mkMerge [
    (lib.mkIf config.home-manager.users.${user}.my.module-bluetooth.enable {
      hardware.bluetooth = {
        enable = true;
        powerOnBoot = true;
        settings = {
          General = {
            # Shows battery charge of connected devices on supported
            # Bluetooth adapters. Defaults to 'false'.
            Experimental = true;
            # When enabled other devices can connect faster to us, however
            # the tradeoff is increased power consumption. Defaults to
            # 'false'.
            FastConnectable = false;
          };
          Policy = {
            # Enable all controllers when they are found. This includes
            # adapters present on start as well as adapters that are plugged
            # in later on. Defaults to 'true'.
            AutoEnable = true;
          };
        };
      };
    })

    (lib.mkIf config.home-manager.users.${user}.my.personal-networking.enable {
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

      # Enable the OpenSSH daemon.
      # services.openssh.enable = true;

      # Open ports in the firewall.
      # networking.firewall.allowedTCPPorts = [ ... ];
      # networking.firewall.allowedUDPPorts = [ ... ];
      # Or disable the firewall altogether.
      # networking.firewall.enable = false;
    })

    (lib.mkIf config.home-manager.users.${user}.my.module-printing.enable {
      services = {
        printing.enable = true;
        avahi = {
          enable = true;
          nssmdns4 = true;
          openFirewall = true;
        };
      };
    })

    (lib.mkIf config.home-manager.users.${user}.my.module-mango.enable {
      # Display manager :
      programs.regreet.enable = true;
      services.greetd = {
        enable = true;
        settings = {
          default_session = {
            command = "mango";
            user = "${user}"; # autologin
          };
        };
      };
    })

    {
      # enable flakes feature and the accompanying nix cmd-line tool
      nix.settings.experimental-features = [
        "nix-command"
        "flakes"
      ];

      # Use the systemd-boot EFI boot loader.
      boot.loader.systemd-boot.enable = true;
      boot.loader.efi.canTouchEfiVariables = true;

      # Set your time zone.
      time.timeZone = "Europe/Paris";

      # Select internationalisation properties.
      # Locales
      i18n = {
        defaultLocale = "en_US.UTF-8";
      };
      # console = {
      #   font = "Lat2-Terminus16";
      #   keyMap = "us";
      #   useXkbConfig = true; # use xkb.options in tty.
      # };

      # Enable sound.
      security.rtkit.enable = true;
      services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
        jack.enable = true;
      };

      # hardware accelerated graphics drivers. (hardware rendering, video encode/decode acceleration, etc)
      hardware.graphics.enable = true;

      users.users.${user} = {
        isNormalUser = true;
        extraGroups = [
          "wheel" # Enable ‘sudo’ for the user.
        ];
        shell = pkgs.zsh;
        ignoreShellProgramCheck = true; # NOTE: fine because programs.zsh.enable = true; in home
      };

      # Some programs need SUID wrappers, can be configured further or are
      # started in user sessions.
      # programs.mtr.enable = true;

      # This option defines the first version of NixOS you have installed on this particular machine,
      # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
      #
      # Most users should NEVER change this value after the initial install, for any reason,
      # even if you've upgraded your system to a new NixOS release.
      #
      # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
      # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
      # to actually do that.
      #
      # This value being lower than the current NixOS release does NOT mean your system is
      # out of date, out of support, or vulnerable.
      #
      # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
      # and migrated your data accordingly.
      #
      # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
      system.stateVersion = "25.05"; # Did you read the comment?
    }
  ];
}
