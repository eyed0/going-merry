{ config, lib, pkgs, ... }:

{
  # Enable Bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        Enable = "Source,Sink,Media,Socket";
        Experimental = true;
      };
    };
  };

  # Enable blueman for Bluetooth management
  services.blueman.enable = true;

# Add Bluetooth-related packages to your system packages
  environment.systemPackages = with pkgs; [
    bluez
    bluez-tools
	# Add tray icon support for Wayland
    libappindicator
    libayatana-appindicator
  ];

  systemd.user.services.blueman-applet = {
    enable = true;
    description = "Blueman applet";
    wantedBy = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.blueman}/bin/blueman-applet";
      Restart = "on-failure";
      RestartSec = 1;
      Environment = "XDG_CURRENT_DESKTOP=Unity"; # This can help with tray icon visibility
    };
  };
}
