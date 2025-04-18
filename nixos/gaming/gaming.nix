{ config, pkgs, ... }:

{

    hardware.graphics = {
        enable = true;
        enable32Bit = true;
        extraPackages = with pkgs; [
          amdvlk
		  vulkan-loader
          vulkan-tools
          libvdpau
          libva
        ];
    };

    environment.systemPackages = with pkgs; [
      lact
      lutris
      wineWowPackages.stagingFull
      ryujinx
      protonup
      protonup-qt
      scanmem
      winetricks
      protontricks
      nexusmods-app
      vulkan-tools
      mesa
	  # veloren # rpg game
    ];

    programs = {
        # gamemode.enable = true;
        gamescope.enable = true;
    };


}
