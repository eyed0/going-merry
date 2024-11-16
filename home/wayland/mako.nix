{ config, pkgs, lib, ... }:

{
  # Enable Mako service
  services.mako = {
    enable = true;
    
    # Default notification settings
    defaultTimeout = 5000; # 5 seconds
    layer = "overlay";    # Show on top of fullscreen windows
    
    # Visual appearance
    #font = "PragmataProLiga Nerd Font 11";
    width = 300;
    height = 100;
    margin = "20";
    padding = "15";
    borderSize = 2;
    borderRadius = 2;
    
    # Specify icons theme
    icons = true;
    maxIconSize = 24;
  };
}
