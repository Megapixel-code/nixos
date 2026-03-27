{
  config,
  ...
}:
{
  programs.git = {
    enable = true;
    settings = {
      user.name = "megapixel-code";
      user.email = "chainemegapixel@gmail.com";
      init.defaultBranch = "main";
      credential.helper = "store";
    };
  };

  sops.secrets."git/credentials" = {
    path = "${config.xdg.configHome}/git/credentials";
  };
}
