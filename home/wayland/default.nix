{ config, lib, pkgs, ... }:

{
  imports = [
    ./mako.nix
	./niri.nix
	./fuzzel.nix
	./waybar.nix
	./waybar.nix
	./idle_lock.nix
	./xdgdefault.nix
	./eww/default.nix
	#./anyrun.nix # wait for next update
	./clipboard.nix
  ];

  home.packages = [
	#pkgs.jq
	pkgs.mako
  ];
  programs.jq.enable = true;
  programs.eww-bar = {
    enable = true;
  };
  
}



# TODO https://sr.ht/~emersion/kanshi/
# https://github.com/etu/nixconfig/blob/main/modules/graphical/window-managers/kanshi/default.nix
