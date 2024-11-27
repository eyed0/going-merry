{ config, pkgs, inputs, ... }:

{
  imports = [
    ./home/stylix/stylix.nix 
	  ./home/wayland/default.nix
	  ./home/kdeconnect.nix
	  #./home/mpv/mpv.nix
    ./home/jujutsu.nix
  ];
  home.username = "heehaw";
  home.homeDirectory = "/home/heehaw";
  nix.package = pkgs.nix;

  home.stateVersion = "24.05"; # Please read the comment before changing.

  home.packages = [
    #pkgs.eza
	pkgs.mpv
	pkgs.scrcpy
  ];

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

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/heehaw/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

}
