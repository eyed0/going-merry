{ config, pkgs, ... }:

{

    hardware.graphics = {
        enable = true;
        enable32Bit = true;
        extraPackages = with pkgs; [
          amdvlk
          vulkan-loader
          vulkan-tools
          vulkan-validation-layers
          libvdpau
          libva
          libva-vdpau-driver
        ];
    };

    hardware.enableRedistributableFirmware = true;
    hardware.amdgpu.amdvlk.supportExperimental.enable = true;

    # # Whether to enable amdgpu overdrive mode for overclocking.
    # hardware.amdgpu.overdrive.enable = true;

    services.lact.enable = true;

    # hardware.amdgpu.opencl.enable = true;
    # services.ollama.enable = true;
    # services.ollama.acceleration = "rocm";

    programs.steam.enable = true;

    environment.systemPackages = with pkgs; [
      lutris

      #wineWowPackages.stagingFull
      #wineWowPackages.waylandFull
      wineWowPackages.unstableFull
      
      umu-launcher
      ryubing
      protonup
      protonup-qt
      scanmem
      winetricks
      protontricks
      #nexusmods-app
      mesa
      # veloren # rpg game
      # cemu

      steamtinkerlaunch
      
    ];

    programs = {
        gamemode.enable = true;
        gamescope.enable = true;
        #coolercontrol.enable = true;
    };
}
