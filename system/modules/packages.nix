{
  config,
  user,
  lib,
  pkgs,
  pkgs-unstable,
  ...
}:
let
  makeWrapper =
    name: script_content:
    pkgs.symlinkJoin {
      name = name;
      paths = [
        (pkgs.writers.writeBashBin name (
          script_content
          + ''
            exec ${pkgs.${name}}/bin/${name} "$@"
          ''
        ))
        pkgs.${name}
      ];
    };

  stablePackages =
    with pkgs;
    [
      # always on
      git
      tmux
      home-manager
    ]
    ++ [
      # languages
      cargo
      typst
      lua
      fpc # free pascal
      python3
      scala
    ]
    ++ (lib.lists.optionals config.home-manager.users.${user}.my.module-mango.enable [
      mangowc
      waybar
      sunsetr
      brightnessctl
      slurp # select region in wayland
      grim # screenshoot tool
      imagemagick # image manipulation tool (used for color picker)
      pscircle # proccess viewer image generator
      awww # bg daemon
      wofi # app launcher
      swaynotificationcenter # notification deamon
    ])
    ++ (lib.lists.optionals config.home-manager.users.${user}.my.networking.personal.enable [
      impala # Network TUI control
    ])
    ++ (lib.lists.optionals config.home-manager.users.${user}.my.module-bluetooth.enable [
      bluetui # Bluetooth TUI control
    ])
    ++ (lib.lists.optionals config.home-manager.users.${user}.my.pkgs.apps.enable [
      kitty
      deezer-desktop
      obs-studio
      libreoffice
      vlc
    ])
    ++ (lib.lists.optionals config.home-manager.users.${user}.my.pkgs.editors.enable [
      inkscape # pdf/svg editor
      gimp3
      (makeWrapper "davinci-resolve" ''
        HOME=$XDG_DATA_HOME/DaVinciResolve
        mkdir -p $HOME
      '')
    ])
    ++ (lib.lists.optionals config.home-manager.users.${user}.my.pkgs.games.enable [
      (makeWrapper "steam" ''
        HOME=$XDG_DATA_HOME/Steam
        mkdir -p $HOME
      '')
      prismlauncher # minecraft
    ])
    ++ (lib.lists.optionals config.home-manager.users.${user}.my.pkgs.utilities.system.enable [
      man-pages
      glibcInfo
      gnumake
      cmake
      gcc
      curl
      wget
      nh
      sops
      age # simple encryption
      bear # used to create compilation db for clang

      unzip
      gzip
      gnutar
      ntfs3g # read/fix ntfs file systems

      fzf
      pdfgrep

      wl-clipboard
      inotify-tools
      ffmpeg
    ])
    ++ (lib.lists.optionals config.home-manager.users.${user}.my.pkgs.utilities.user.enable [
      ncpamixer # audio TUI control
      stow
      tree
      fastfetch
      cbonsai
      htop-vim # interactive process viewer
      skim # command line fuzy finder
      pass-wayland # password manager
    ]);

  unstablePackages = with pkgs-unstable; [
    # always on
  ];
in
{
  # required for:
  #   yazi's 7zz
  #   factorio
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  environment.systemPackages = stablePackages ++ unstablePackages;

  fonts.packages = with pkgs; [
    nerd-fonts.blex-mono
  ];
}
