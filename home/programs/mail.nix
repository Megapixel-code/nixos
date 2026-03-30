{
  pkgs,
  lib,
  config,
  user,
  ...
}:
{
  options = {
    my.aerc = {
      accounts = {
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
      isync = {
        home.path = lib.mkOption {
          description = "isync home folder";
          type = lib.types.str;
          default = "${config.xdg.configHome}/isync/";
        };
        maildir.path = lib.mkOption {
          description = "path of maildir WITH NO / AT THE END";
          type = lib.types.str;
          default = "${config.home.homeDirectory}/mail";
        };
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
      isync
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

          "?" = ":search<Space>-a<Space>";
          "/" = ":filter<Space>-a<Space>";
          "n" = ":next-result<Enter>";
          "N" = ":prev-result<Enter>";

          "T" = ":toggle-threads<Enter>";
          "<tab>" = ":fold -t<Enter>";
          "m" = ":menu -dc \"fzf\" -t \"Move to :\" :move<Enter>";
          "a" = ":archive flat<Enter>";
          "A" = ":unmark -a<Enter>:mark -T<Enter>:archive flat<Enter>"; # archive thread
          "s" = ":split<Enter>";
          "S" = ":vsplit<Enter>";

          "<C-r>" = ":check-mail<Enter>";
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
          "S" = ":save<Space>";
          "|" = ":pipe<Space>";
          "D" = ":delete<Enter>";
          "A" = ":archive flat<Enter>";

          "<C-y>" = ":copy-link<Space>";
          "<C-l>" = ":open-link<Space>";

          "f" = ":forward<Enter>";
          "rr" = ":reply<Enter>";
          "rq" = ":reply -q<Enter>";
          "Rr" = ":reply -a<Enter>";
          "Rq" = ":reply -aq<Enter>";

          "H" = ":toggle-headers<Enter>";
        };
        "view::passthrough" = {
          "$noinherit" = "true";
          "$ex" = "<C-x>";
          "<Esc>" = ":toggle-key-passthrough<Enter>";
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
          "a" = ":menu -c \"yazi --chooser-file=%f\" -t \"Add Attachment\" :attach<Enter> # Add attachment";
          "d" = ":detach<Space> # Remove attachment";
        };
        "terminal" = {
          "$noinherit" = "true";
          "$ex" = "<C-x>";
          "<C-p>" = ":prev-tab<Enter>";
          "<C-n>" = ":next-tab<Enter>";
        };
      };
      extraConfig = {
        general = {
          "unsafe-accounts-conf" = false;
        };
        compose = {
          "address-book-cmd" = "${config.sops.templates."emailbook".path} \"%s\"";
        };
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

        map_concat = one_m: all_m_nb: lib.strings.concatStringsSep "\n" (map one_m all_m_nb);
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
          source        = maildir://${config.my.aerc.isync.maildir.path}/${
            placeholder."mails/vfemail_${nb}/mail"
          }
          outgoing      = smtps://${placeholder."mails/vfemail_${nb}/mailUrlEncoded"}:${
            placeholder."mails/vfemail_${nb}/password"
          }@smtp.vfemail.net:465
          from          = ${user} <${placeholder."mails/vfemail_${nb}/mail"}>
          check-mail-cmd = ${config.sops.templates."mbsyncscript".path} ${
            placeholder."mails/vfemail_${nb}/mail"
          }
          check-mail-timeout = 30s
          check-mail         = 30s
          default            = INBOX
          folders-sort       = INBOX
          postpone           = Drafts
          copy-to            = Sent
        '';

        one_mbsync = nb: ''
          IMAPAccount ${config.sops.placeholder."mails/vfemail_${nb}/mail"}
          Host imap.vfemail.net
          Port 993
          User ${config.sops.placeholder."mails/vfemail_${nb}/mail"}
          Pass ${config.sops.placeholder."mails/vfemail_${nb}/password"}
          TLSType IMAPS

          IMAPStore ${config.sops.placeholder."mails/vfemail_${nb}/mail"}-remote
          Account ${config.sops.placeholder."mails/vfemail_${nb}/mail"}

          MaildirStore ${config.sops.placeholder."mails/vfemail_${nb}/mail"}-local
          Path ${config.my.aerc.isync.maildir.path}/${config.sops.placeholder."mails/vfemail_${nb}/mail"}/
          INBOX ${config.my.aerc.isync.maildir.path}/${
            config.sops.placeholder."mails/vfemail_${nb}/mail"
          }/INBOX
          Trash ${config.my.aerc.isync.maildir.path}/${
            config.sops.placeholder."mails/vfemail_${nb}/mail"
          }/Trash
          SubFolders Verbatim

          Channel ${config.sops.placeholder."mails/vfemail_${nb}/mail"}
          Far :${config.sops.placeholder."mails/vfemail_${nb}/mail"}-remote:
          Near :${config.sops.placeholder."mails/vfemail_${nb}/mail"}-local:
          Patterns *
          Create Both
          Remove Both
          SyncState *
        '';
        one_mbsync_script = nb: ''
          mkdir -m 700 -p ${config.my.aerc.isync.maildir.path}/${
            config.sops.placeholder."mails/vfemail_${nb}/mail"
          }
          mbsync -c ${config.my.aerc.isync.home.path}/mbsyncrc ${
            config.sops.placeholder."mails/vfemail_${nb}/mail"
          }
        '';

        all_secrets = lib.mergeAttrsList (
          [
            {
              "mails/emailbook" = { };
            }
          ]
          ++ (map one_gmail_secret all_gmail_nb)
          ++ (map one_vfemail_secret all_vfemail_nb)
        );
        all_content = lib.concatStringsSep "\n" [
          (map_concat one_gmail all_gmail_nb)
          (map_concat one_vfemail all_vfemail_nb)
        ];
        all_mbsync = lib.concatStringsSep "\n" [
          (map_concat one_mbsync all_vfemail_nb)
        ];
        all_mbsync_script = lib.concatStringsSep "\n" [
          (map_concat one_mbsync_script all_vfemail_nb)
        ];

      in
      {
        secrets = all_secrets;
        templates = {
          "accounts.conf" = {
            content = all_content;
            path = config.my.aerc.accounts.path;
            mode = "400";
          };
          "mbsyncrc" = {
            content = all_mbsync;
            path = config.my.aerc.isync.home.path + "/mbsyncrc";
            mode = "400";
          };
          "mbsyncscript" = {
            content = ''
              #!/usr/bin/env bash

            ''
            + all_mbsync_script;
            mode = "500";
          };
          "emailbook" = {
            content = ''
              #!/usr/bin/env sh
              # NOTE: using > https://git.sr.ht/~maxgyver83/emailbook/tree/main/item/emailbook

              searchall() {
                 # show entries with matching alias first
                 searchbyalias "$*"
                 searchbyvalueonly "$*"
              }
              searchbyalias() {
                 grep -i -E "$* :" "$filename" | sed -E 's/^[^:]+:\s*//'
              }
              searchbyvalueonly() {
                 # exclude matches found by searchbyalias
                 grep -i -E -v "$* :" "$filename" | sed -E 's/^[^:]+:\s*//' | grep -i -E "$*"
              }

              filename=${config.sops.secrets."mails/emailbook".path}

              searchall "$*"
            '';
            mode = "500";
          };
        };
      };
  };
}
