{
  pkgs,
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

    home.packages = with pkgs; [
      chafa # images in the terminal
    ];

    programs.aerc = {
      enable = true;

      extraBinds = {
        # NOTE: https://man.archlinux.org/man/aerc.1.en
        global = {
          "<C-p>" = ":prev-tab<Enter>";
          "<C-n>" = ":next-tab<Enter>";
          "<C-t>" = ":term<Enter>";
          "?" = ":help keys<Enter>";
        };
        messages = {
          "q" = ":prompt 'Quit?' quit<Enter>";

          "j" = ":next<Enter>";
          "k" = ":prev<Enter>";
          "<C-d>" = ":next 50%<Enter>";
          "<C-u>" = ":prev 50%<Enter>";
          "<C-f>" = ":next 100%<Enter>";
          "<C-b>" = ":prev 100%<Enter>";
          "g" = ":select 0<Enter>";
          "G" = ":select -1<Enter>";
          "zz" = ":align center<Enter>";
          "zt" = ":align top<Enter>";
          "zb" = ":align bottom<Enter>";

          "J" = ":next-folder<Enter>";
          "K" = ":prev-folder<Enter>";
          "H" = ":collapse-folder<Enter>";
          "L" = ":expand-folder<Enter>";

          "<Space>" = ":mark -t<Enter>:next<Enter>";
          "v" = ":mark -t<Enter>";
          "V" = ":mark -v<Enter>";
          "gv" = "remark<Enter>";

          "<Esc>" = ":clear<Enter>:unmark -a<Enter>";

          "/" = ":search<space>";
          "\\" = ":filter<space>";
          "n" = ":next-result<Enter>";
          "N" = ":prev-result<Enter>";

          "T" = ":toggle-threads<Enter>";
          "<tab>" = ":fold -t<Enter>";
          "a" = ":archive flat<Enter>";
          "A" = ":unmark -a<Enter>:mark -T<Enter>:archive flat<Enter>"; # archive thread
          "s" = ":split<Enter>";
          "S" = ":vsplit<Enter>";

          "d" = ":choose -o y 'Really delete this message' delete-message<Enter>";
          "D" = ":delete<Enter>";
          "<Enter>" = ":view<Enter>";
          "i" = ":compose<Enter>";
          "rr" = ":reply<Enter>";
          "rq" = ":reply -q<Enter>";
          "Rr" = ":reply -a<Enter>";
          "Rq" = ":reply -aq<Enter>";
        };
        "messages:folder=Drafts" = {
          "<Enter>" = ":recall<Enter>";
        };
        "view" = {
          "<C-k>" = ":prev-part<Enter>";
          "<C-j>" = ":next-part<Enter>";
          "J" = ":next<Enter>";
          "K" = ":prev<Enter>";

          "q" = ":close<Enter>";
          "o" = ":open -d<Enter>";
          "S" = ":save<space>";
          "|" = ":pipe<space>";
          "D" = ":delete<Enter>";
          "A" = ":archive flat<Enter>";

          "<C-y>" = ":copy-link <space>";
          "<C-l>" = ":open-link <space>";

          "f" = ":forward<Enter>";
          "rr" = ":reply<Enter>";
          "rq" = ":reply -q<Enter>";
          "Rr" = ":reply -a<Enter>";
          "Rq" = ":reply -aq<Enter>";

          "H" = ":toggle-headers<Enter>";
        };
        "compose" = {
          # Keybindings used when the embedded terminal is not selected in the compose view
          "$noinherit" = "true";
          "$ex" = "<C-x>";
          "$complete" = "<C-o>";
          "<C-k>" = ":prev-field<Enter>";
          "<C-j>" = ":next-field<Enter>";
          "<A-p>" = ":switch-account -p<Enter>";
          "<A-n>" = ":switch-account -n<Enter>";
          "<C-p>" = ":prev-tab<Enter>";
          "<C-n>" = ":next-tab<Enter>";
        };
        "compose::editor" = {
          # Keybindings used when the embedded terminal is selected in the compose view
          "$noinherit" = "true";
          "$ex" = "<C-x>";
          "<C-k>" = ":prev-field<Enter>";
          "<C-j>" = ":next-field<Enter>";
          "<C-p>" = ":prev-tab<Enter>";
          "<C-n>" = ":next-tab<Enter>";
        };
        "compose::review" = {
          "y" = ":send<Enter> # Send";
          "n" = ":abort<Enter> # Abort (discard message, no confirmation)";
          "s" = ":sign<Enter> # Toggle signing";
          "x" = ":encrypt<Enter> # Toggle encryption to all recipients";
          "v" = ":preview<Enter> # Preview message";
          "p" = ":postpone<Enter> # Postpone";
          "q" = ":choose -o d discard abort -o p postpone postpone<Enter> # Abort or postpone";
          "e" = ":edit<Enter> # Edit (body and headers)";
          "a" = ":attach<space> # Add attachment";
          "d" = ":detach<space> # Remove attachment";
        };
        "terminal" = {
          "$noinherit" = "true";
          "$ex" = "<C-x>";
          "<C-p>" = ":prev-tab<Enter>";
          "<C-n>" = ":next-tab<Enter>";
        };
      };
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
          "image/*" = "chafa -f symbols -s $(tput cols)x$(tput lines) -";
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
          postpone      = Drafts
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
