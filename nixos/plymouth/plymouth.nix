{ config, pkgs, ... }:

let
  plymouth-hexagon = pkgs.callPackage ./plymouth-hexagon.nix {};
in
{
  # Enable Plymouth
  boot.plymouth = {
    enable = true;
    themePackages = [ plymouth-hexagon ];
    theme = "hexagon_alt";
  };

  # Required kernel parameters for smooth boot
  boot.kernelParams = [
    "quiet"
    "splash"
    "plymouth.ignore-serial-consoles"
    "rd.systemd.show_status=false"
    "rd.udev.log_level=3"
    "udev.log_priority=3"
  ];

  # If you use disk encryption
  boot.plymouth.enableCryptsetup = true;

  # For better resolution during boot
  boot.loader.systemd-boot.consoleMode = "max";

  # Optional: disable console output during boot
  console.earlySetup = false;
}
