{
  lib,
  config,
  user,
  ...
}:
let
  all_nb = [
    "1"
    "2"
    "3"
    "4"
    "5"
  ];

  one_secret = nb: {
    "mails/gmail_${nb}/mail" = { };
    "mails/gmail_${nb}/mailUrlEncoded" = { };
    "mails/gmail_${nb}/clientId" = { };
    "mails/gmail_${nb}/clientSecret" = { };
    "mails/gmail_${nb}/refreshTokenUrlEncoded" = { };
  };
  all_secrets = lib.mergeAttrsList (map one_secret all_nb);

  one_gmail = nb: ''
    [${config.sops.placeholder."mails/gmail_${nb}/mail"}]
    from     = ${user} <${config.sops.placeholder."mails/gmail_${nb}/mail"}>
    source   = imaps+oauthbearer://${config.sops.placeholder."mails/gmail_${nb}/mailUrlEncoded"}:${
      config.sops.placeholder."mails/gmail_${nb}/refreshTokenUrlEncoded"
    }@imap.gmail.com:993?client_id=${
      config.sops.placeholder."mails/gmail_${nb}/clientId"
    }&client_secret=${
      config.sops.placeholder."mails/gmail_${nb}/clientSecret"
    }&token_endpoint=https%3A%2F%2Foauth2.googleapis.com%2Ftoken
    outgoing = smtps+oauthbearer://${config.sops.placeholder."mails/gmail_${nb}/mailUrlEncoded"}:${
      config.sops.placeholder."mails/gmail_${nb}/refreshTokenUrlEncoded"
    }@smtp.gmail.com:465?client_id=${
      config.sops.placeholder."mails/gmail_${nb}/clientId"
    }&client_secret=${
      config.sops.placeholder."mails/gmail_${nb}/clientSecret"
    }&token_endpoint=https%3A%2F%2Foauth2.googleapis.com%2Ftoken
    default       = INBOX
    folders-sort  = INBOX
    postpone      = [Gmail]/Drafts
    cache-headers = true
  '';
  all_gmail = lib.strings.concatStringsSep "\n" (map one_gmail all_nb);
in
{
  # TODO: https://man.sr.ht/~rjarry/aerc/configurations/mailto.md

  config = lib.mkIf config.my.pkgs.apps.enable {
    programs.aerc = {
      enable = true;

      extraBinds = { };
      extraConfig = {
        ui = {
          reverse-thread-order = false;
          threading-enabled = true;
        };
        filters = {
          "text/plain" = "colorize";
          "text/calendar" = "calendar";
          "message/delivery-status" = "colorize";
          "message/rfc822" = "colorize";
          "text/html" = "! html";
          ".headers" = "colorize";
        };
      };
    };

    sops.secrets = all_secrets;
    sops.templates."accounts.conf" = {
      content = all_gmail;
      path = "${config.xdg.configHome}/aerc/accounts.conf";
      mode = "400";
    };
  };
}
