{ config, lib, pkgs, ... }:

{
  # Enable bluetooth and required services
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;  # Power up Bluetooth controller on boot
    settings = {
      General = {
        Enable = "Source,Sink,Media,Socket";
        Experimental = true;
        FastConnectable = true;
        KernelExperimental = true;
        MultiProfile = "multiple";
      };
      Policy = {
        AutoEnable = true;
      };
    };
  };

  # Enable blueman service
  services = {
    blueman.enable = true;
    dbus.enable = true;  # Required for Bluetooth
  };

  # Add necessary Bluetooth packages
  environment.systemPackages = with pkgs; [
    bluez
    bluez-tools
    blueman
    bluetuith
    playerctl
  ];
  
  # Optional: Enable power management for Bluetooth
  powerManagement = {
    enable = true;
    powertop.enable = true;
  };

  # Optional: Add udev rules for Bluetooth devices
  services.udev.extraRules = ''
    # Automatically power on Bluetooth adapters
    ACTION=="add", SUBSYSTEM=="bluetooth", KERNEL=="hci[0-9]*", RUN+="${pkgs.bluez}/bin/hciconfig %k up"
  '';

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
