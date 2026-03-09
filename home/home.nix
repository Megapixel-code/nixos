{
  lib,
  user,
  ...
}:

{
  imports = [
    ./formatters.nix
    ./xdg-desktop.nix
    ./cursor.nix
    ./options.nix

    ./programs/mango.nix
    ./programs/firefox.nix
    ./programs/git.nix
    ./programs/nvim.nix
    ./programs/yazi.nix
    ./programs/bat.nix
    ./programs/sunsetr.nix
    ./programs/gnupg.nix
    ./programs/zsh.nix
    ./programs/mail.nix
  ];

  home = {
    username = "${user}";
    homeDirectory = "/home/${user}";

    activation = {
      create-screenshoot-folder = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        mkdir -p $GRIM_DEFAULT_DIR
      ''; # $HOME/pictures/screenshoots/
      create-documents-folder = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        mkdir -p $HOME/documents/projects/
      ''; # $HOME/documents/projects/
    };
  };

  # This value determines the home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update home Manager without changing this value. See
  # the home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "25.05";
}
