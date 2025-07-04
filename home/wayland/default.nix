{ config, lib, pkgs, ... }:

{
  imports = [
    #./mako.nix
	  ./niri.nix
	  ./fuzzel.nix
	  ./waybar.nix
	  #./idle_lock.nix
	  ./xdgdefault.nix
	  ./eww/default.nix
	  #./anyrun.nix # wait for next update
	  ./swaybg.nix
  ];

  home.packages = with pkgs; [
    wl-clipboard
    # clipman
    #mako
    libnotify
    kdePackages.plasma-nm
  ];
  programs.jq.enable = true;
  programs.eww-bar = {
    enable = true;
  };  
}



  # TODO https://sr.ht/~emersion/kanshi/
  # https://github.com/etu/nixconfig/blob/main/modules/graphical/window-managers/kanshi/default.nix
