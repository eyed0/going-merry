{ pkgs, ... }:

{
  
  fonts.packages = with pkgs; [
    #(nerd-fonts.override { fonts = [ "VictorMono" "SpaceMono" "RobotoMono" "FiraCode"]; })
    lexend
    lohit-fonts.marathi
    marathi-cursive
    aspellDicts.mr
    merriweather-sans
    atkinson-hyperlegible
    alegreya
    alegreya-sans	
  ];

  fonts = {
    #enableDefaultPackages = true; # Enable a basic set of fonts
    fontconfig = {
      enable = true;
      cache32Bit = true;
      antialias = true;
      hinting.enable = true;
      hinting.style = "slight";
      subpixel.rgba = "rgb";
      subpixel.lcdfilter = "default";
    };
  };
  
}
