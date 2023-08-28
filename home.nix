{ config, pkgs, ... }:

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
  home.stateVersion = "23.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    alacritty
    bash
    coreutils
    cabal-install
    dateutils
    dig
    fetchutils
    findutils
    firefox
    ghc
    gnumake
    haskell-language-server
    idutils
    inetutils
    jq
    openssl
    tree
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

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.bash = {
    enable = true;
    initExtra = ''
      export LESS='--chop-long-lines --redraw-on-quit'
      GREEN="\[\033[32m\]"
      BLUE="\[\033[34m\]"
      NONE="\[\033[0m\]"
      TITLE="\[\033]0;\w\007\]"
      PS1="$TITLE$GREEN\u@\h$NONE:$BLUE\W$NONE\\$ "
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
    '';
    # sessionVariables = {};
    shellAliases = {
      ".." = "cd ..";
      e = "emacs --no-splash";
      gits = "git status";
      m = "make";
    };
  };

  programs.emacs = {
    enable = true;
    extraConfig = ''
      (setq initial-scratch-message nil)
      (if window-system (set-face-attribute 'default nil :family "Monospace" :height 140))
      (load-theme 'zenburn t)
      (set-background-color "black")
      (set-cursor-color "#ff4520")
      (set-mouse-color "#ffffff")
      (menu-bar-mode -1)
      (toggle-scroll-bar -1)
      (tool-bar-mode -1)
      (global-linum-mode 1)
      (global-hl-line-mode 1)
      (set-face-background 'hl-line "#050555")
      (setq standard-indent 2)
      (setq tab-width 2)
      (setq indent-tas-mode nil)
    '';
    extraPackages = epkgs: (with epkgs;
      [ epkgs.haskell-mode
        epkgs.nix-mode
        epkgs.zenburn-theme
      ]
    );
  };

  # https://github.com/jwiegley/nix-config/blob/master/config/home.nix
  programs.git = {
    enable = true;
    userEmail = "metaml@gmail.com";
    userName = "metaml";
    extraConfig = {
      core = {
        editor = "emacsclient";
        whitespace = "trailing-space,space-before-tab";
      };
      init.defaultBranch = "main";
    };
    # signing.key = "GPG-KEY-ID";
    # signing.signByDefault = true;
  };
}
