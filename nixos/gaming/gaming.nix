{ config, pkgs, ... }:

{

    hardware.graphics = {
        enable = true;
        enable32Bit = true;
        extraPackages = with pkgs; [
          amdvlk
        ];
    };

    environment.systemPackages = with pkgs; [
      lact
      lutris
      wineWowPackages.staging
      ryujinx
      protonup
      protonup-qt
      scanmem
      winetricks
      protontricks
      nexusmods-app
      vulkan-tools
      mesa
    ];

    programs = {
        gamemode.enable = true;
        gamescope.enable = true;
    };


}
