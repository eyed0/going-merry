{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    swaybg
  ];

  systemd.user.services.swaybg = {
    Unit = {
      Description = "Wallpaper setter for Wayland using swaybg";
      PartOf = ["graphical-session.target"];
      After = ["graphical-session.target"];
    };

    Service = {
      ExecStart = "${pkgs.swaybg}/bin/swaybg -i ${config.lib.file.mkOutOfStoreSymlink "/home/${config.home.username}/flake/wall/yotsuba.jpeg"} -m fill";
      Restart = "always";
    };

    Install = {
      WantedBy = ["graphical-session.target"];
    };
  };
}
