{ config, lib, pkgs, ... }:

{
  imports = [
    ./mako.nix
	./niri.nix
	./fuzzel.nix
	./waybar.nix
	./idle_lock.nix
	./xdgdefault.nix
	./eww/default.nix
	#./anyrun.nix # wait for next update
	./swaybg.nix
  ];

  home.packages = with pkgs; [
    wl-clipboard
    clipman
    mako
  ];
  programs.jq.enable = true;
  programs.eww-bar = {
    enable = true;
  };

  systemd.user.services.clipman = {
    Unit = {
      Description = "Clipboard Manager Service";
      PartOf = ["graphical-session.target"];
    };
    Service = {
      ExecStart = "${pkgs.clipman}/bin/clipman listen";
      Restart = "always";
    };
    Install = {
      WantedBy = ["graphical-session.target"];
    };
  };
  
}



# TODO https://sr.ht/~emersion/kanshi/
# https://github.com/etu/nixconfig/blob/main/modules/graphical/window-managers/kanshi/default.nix
