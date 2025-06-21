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

    hardware.enableRedistributableFirmware = true;

    hardware.amdgpu.opencl.enable = true;
    services.ollama.enable = true;
    services.ollama.acceleration = "rocm";

    environment.systemPackages = with pkgs; [
      lact
      lutris

      #wineWowPackages.stagingFull
      #wineWowPackages.waylandFull
      wineWowPackages.unstableFull
      
      umu-launcher
      ryujinx
      protonup
      protonup-qt
      scanmem
      winetricks
      protontricks
      #nexusmods-app
      mesa
      # veloren # rpg game
      # cemu
    ];

    programs = {
        gamemode.enable = true;
        gamescope.enable = true;
        coolercontrol.enable = true;
    };
}
