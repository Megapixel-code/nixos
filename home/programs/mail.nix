{
  lib,
  config,
  user,
  ...
}:
{
  options = {
    my.aerc.accounts = {
      total_gmails = lib.mkOption {
        description = "Indicate the number of gmails accounts you have in your sops secrets";
        type = lib.types.int;
        default = 0;
      };
      total_vfemails = lib.mkOption {
        description = "Indicate the number of vfemails accounts you have in your sops secrets";
        type = lib.types.int;
        default = 0;
      };
      path = lib.mkOption {
        description = "path of accounts.conf";
        type = lib.types.str;
        default = "${config.xdg.configHome}/aerc/accounts.conf";
      };
    };
  };

  # TODO: https://man.sr.ht/~rjarry/aerc/configurations/mailto.md

  config = lib.mkIf config.my.pkgs.apps.enable {
    my.aerc.accounts = {
      total_gmails = 5;
      total_vfemails = 1;
    };

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

    sops =
      let
        placeholder = config.sops.placeholder;

        numberize = cfg: if cfg > 0 then map builtins.toString (lib.range 1 cfg) else [ ];
        all_gmail_nb = numberize config.my.aerc.accounts.total_gmails;
        all_vfemail_nb = numberize config.my.aerc.accounts.total_vfemails;

        one_gmail_secret = nb: {
          "mails/gmail_${nb}/mail" = { };
          "mails/gmail_${nb}/mailUrlEncoded" = { };
          "mails/gmail_${nb}/clientId" = { };
          "mails/gmail_${nb}/clientSecret" = { };
          "mails/gmail_${nb}/refreshTokenUrlEncoded" = { };
        };
        one_vfemail_secret = nb: {
          "mails/vfemail_${nb}/mail" = { };
          "mails/vfemail_${nb}/mailUrlEncoded" = { };
          "mails/vfemail_${nb}/password" = { };
        };

        concat_mails = one_m: all_m_nb: lib.strings.concatStringsSep "\n" (map one_m all_m_nb);
        one_gmail = nb: ''
          [${placeholder."mails/gmail_${nb}/mail"}]
          source   = imaps+oauthbearer://${placeholder."mails/gmail_${nb}/mailUrlEncoded"}:${
            placeholder."mails/gmail_${nb}/refreshTokenUrlEncoded"
          }@imap.gmail.com:993?client_id=${placeholder."mails/gmail_${nb}/clientId"}&client_secret=${
            placeholder."mails/gmail_${nb}/clientSecret"
          }&token_endpoint=https%3A%2F%2Foauth2.googleapis.com%2Ftoken
          outgoing = smtps+oauthbearer://${placeholder."mails/gmail_${nb}/mailUrlEncoded"}:${
            placeholder."mails/gmail_${nb}/refreshTokenUrlEncoded"
          }@smtp.gmail.com:465?client_id=${placeholder."mails/gmail_${nb}/clientId"}&client_secret=${
            placeholder."mails/gmail_${nb}/clientSecret"
          }&token_endpoint=https%3A%2F%2Foauth2.googleapis.com%2Ftoken
          from          = ${user} <${placeholder."mails/gmail_${nb}/mail"}>
          default       = INBOX
          folders-sort  = INBOX
          postpone      = [Gmail]/Drafts
          cache-headers = true
        '';
        one_vfemail = nb: ''
          [${placeholder."mails/vfemail_${nb}/mail"}]
          source        = imaps://${placeholder."mails/vfemail_${nb}/mailUrlEncoded"}:${
            placeholder."mails/vfemail_${nb}/password"
          }@imap.vfemail.net:993
          outgoing      = smtps://${placeholder."mails/vfemail_${nb}/mailUrlEncoded"}:${
            placeholder."mails/vfemail_${nb}/password"
          }@smtp.vfemail.net:465
          from          = ${user} <${placeholder."mails/vfemail_${nb}/mail"}>
          default       = INBOX
          cache-headers = true
        '';

        all_secrets = lib.mergeAttrsList (
          (map one_gmail_secret all_gmail_nb) ++ (map one_vfemail_secret all_vfemail_nb)
        );
        all_content = lib.concatStringsSep "\n" [
          (concat_mails one_gmail all_gmail_nb)
          (concat_mails one_vfemail all_vfemail_nb)
        ];
      in
      {
        secrets = all_secrets;
        templates."accounts.conf" = {
          content = all_content;
          path = config.my.aerc.accounts.path;
          mode = "400";
        };
      };
  };
}
