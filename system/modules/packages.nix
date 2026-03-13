{
  config,
  user,
  lib,
  pkgs,
  pkgs-unstable,
  ...
}:
let
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
      scala
      fpc # free pascal
      python3
    ]
    ++ (lib.lists.optionals config.home-manager.users.${user}.my.module-mango.enable [
      waybar
      sunsetr
      brightnessctl
      slurp # select region in wayland
      grim # screenshoot tool
      imagemagick # image manipulation tool (used for color picker)
      pscircle # proccess viewer image generator
      swww # bg daemon: TODO: change later to awww when pkg will be available
      rofi # app launcher
      swaynotificationcenter # notification deamon
    ])
    ++ (lib.lists.optionals config.home-manager.users.${user}.my.personal-networking.enable [
      impala # Network TUI control
    ])
    ++ (lib.lists.optionals config.home-manager.users.${user}.my.module-bluetooth.enable [
      bluetui # Bluetooth TUI control
    ])
    ++ (lib.lists.optionals config.home-manager.users.${user}.my.pkgs.apps.enable [
      kitty
      deezer-enhanced
      obs-studio
      libreoffice
      vlc
    ])
    ++ (lib.lists.optionals config.home-manager.users.${user}.my.pkgs.editors.enable [
      inkscape # pdf/svg editor
      gimp3
      davinci-resolve
    ])
    ++ (lib.lists.optionals config.home-manager.users.${user}.my.pkgs.games.enable [
      prismlauncher # minecraft
      # factorio TODO:
    ])
    ++ (lib.lists.optionals config.home-manager.users.${user}.my.pkgs.utilities.system.enable [
      # utilities
      gnumake
      cmake
      gcc
      curl
      wget
      sops
      age # simple encryption
      bear # used to create compilation db for clang

      unzip
      gzip
      gnutar
      ntfs3g # read/fix ntfs file systems

      fzf
      ripgrep
      pdfgrep
      fd # find rewrite, directory searching # TODO: remove this shit

      wl-clipboard
      inotify-tools
      ffmpeg
      # git-crypt # manage secrets TODO: later
      # lynx # see html in terminal; TODO: dependency of neomutt maybe not needed
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

  unstablePackages =
    with pkgs-unstable;
    [
      # always on
    ]
    ++ (lib.lists.optionals config.home-manager.users.${user}.my.module-mango.enable [
      mangowc
    ]);
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
