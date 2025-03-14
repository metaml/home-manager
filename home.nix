{ config, pkgs, system, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "ml";
  home.homeDirectory = "/home/ml";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    bashInteractive
    bc
    coreutils
    csvtool
    dateutils
    dig
    # emacs
    fetchutils
    findutils
    gnugrep
    gnumake
    gnused
    google-cloud-sdk
    idutils
    inetutils
    jq
    meld
    nix-index
    less
    openssl
    pandoc
    p7zip
    tree
    unzip
    xlsfonts
    xorg.xhost
    zip
    zlib.dev
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # You can also manage environment variables but you will have to manually
  # source
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/ml/etc/profile.d/hm-session-vars.sh
  #
  # if you don't want to manage your shell through Home Manager.
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  programs.firefox.enable = true;
  # let home manager install and manage itself.
  programs.home-manager.enable = true;

  programs.alacritty = {
    enable = true;
    settings = {
      env = {
        TERM = "xterm-256color";
      };
      window = {
        dimensions = {
          columns = 91;
          lines = 31;
        };
        padding = {
          x = 0;
          y = 0;
        };
        dynamic_padding = false;
      };
      font = {
        normal = {
          style = "Light";
        };
        bold = {
          style = "Light";
        };
        italic = {
          style = "Light";
        };
        size = 9;
      };
    };
  };

  programs.bash = {
    enable = true;
    historySize = 1024;
    historyFileSize = 8192;
    shellOptions = [
      "histappend"
      "checkwinsize"
    ];
    enableCompletion = false;
    initExtra = ''
      GREEN="\[\033[32m\]"
      BLUE="\[\033[34m\]"
      NONE="\[\033[0m\]"
      TITLE="\[\033]0;\w\007\]"
      PS1="$TITLE$GREEN\u@\h$NONE|$BLUE\W$NONE\\$ "
      cdp() {
        if [ -z "$1" -a -z "$PROJECT" ]; then
           export PROJECT=~/p
        elif [ -z "$1" -a -n "$PROJECT" ]; then
           export PROJECT=$PROJECT
        else
           export PROJECT=~/p/$1
        fi
        builtin cd $PROJECT
      }
      cds() {
        if [ -z "$1" -a -z "$SOURCE" ]; then
           export SOURCE=~/s
        elif [ -z "$1" -a -n "$SOURCE" ]; then
           export SOURCE=$SOURCE
        else
           export SOURCE=~/s/$1
        fi
        builtin cd $SOURCE
      }
      unset LESS
    '';
    # sessionVariables = {};
    shellAliases = {
      e = "emacs --no-splash";
      g = "git";
      gits = "git status";
      gitd = "git difftool";
      ls = "ls --color";
      l = "ls --color";
      ll = "ls -l --color";
      lr = "ls -ltr --color";
      m = "make";
      n = "nix";
    };
  };

  programs.emacs = {
    enable = true;
    extraConfig = ''
      (setq initial-scratch-message nil)
      (load-theme 'zenburn t)
      (if window-system (set-face-attribute 'default nil :family "Monospace" :height 150))
      (if (not (display-graphic-p)) (set-face-background 'default "color-16"))
      (set-background-color "black")
      (set-face-bold-p 'bold nil)
      (set-cursor-color "#ff4520")
      (set-mouse-color "#ffffff")
      (menu-bar-mode -1)
      (toggle-scroll-bar -1)
      (toggle-tool-bar-mode-from-frame -1)
      (global-display-line-numbers-mode t)
      (column-number-mode 1)
      (global-hl-line-mode 1)
      (set-face-background 'hl-line "#050555")
      (setq indent-tab-mode nil)
      (setq standard-indent 2)
      (setq tab-width 2)
      (setq python-guess-indent nil)
      (setq python-indent-offset 2)
      (require 'purescript-mode-autoloads)
      (add-hook 'purescript-mode-hook 'turn-on-purescript-indentation)
      (add-hook 'write-file-hooks 'delete-trailing-whitespace)
    '';
    extraPackages = epkgs: (with epkgs;
      [ epkgs.dhall-mode
        epkgs.haskell-mode
        epkgs.json-mode
        epkgs.python-mode
        epkgs.terraform-mode
        epkgs.nix-mode
        epkgs.purescript-mode
        epkgs.ws-butler
        epkgs.yaml-mode
        epkgs.zenburn-theme
      ]
    );
  };

  # https://github.com/jwiegley/nix-config/blob/master/config/home.nixc
  programs.git = {
    enable    = true;
    userEmail = "metaml@gmail.com";
    userName  = "metaml";
    extraConfig = {
      core = {
        editor = "emacs";
        whitespace = "trailing-space,space-before-tab";
      };
      init.defaultBranch = "main";
      color    = { ui = "auto"; };
      diff     = { tool = "meld";
                   mnemonicprefix = true;
                 };
      difftool = { prompt = false; };
      merge    = { tool = "splice"; };
      push     = { default = "simple"; };
      pull     = { rebase = true; };
      branch   = { autosetupmerge = true; };
    };
    includes = [ { path = "~/.gitconfig.local"; } ];
    # signing.key = "GPG-KEY-ID";
    # signing.signByDefault = true;
  };

  # programs.vscode = {
  #   enable = true;
  #   extensions = with pkgs.vscode-extensions; [
  #   ];
  # };
}
