{
  lib,
  user,
  import-tree,
  ...
}:

{
  imports = [
    ./options.nix

    (import-tree ./modules)
    (import-tree ./programs)
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
