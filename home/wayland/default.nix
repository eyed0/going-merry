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
	#./ewwright.nix
  ];
}


# TODO https://sr.ht/~emersion/kanshi/
# https://github.com/etu/nixconfig/blob/main/modules/graphical/window-managers/kanshi/default.nix
