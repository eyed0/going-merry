{ pkgs, ... }:
{

  imports =
    [
      #./ivopro.nix
      #./iopro.nix
    ];
  
  fonts.packages = with pkgs; [
    lexend
    lohit-fonts.marathi
    marathi-cursive
    aspellDicts.mr
    atkinson-hyperlegible
    pkgs.nerd-fonts.iosevka
        
    # Add your custom fonts directory
    (pkgs.runCommand "my-custom-fonts" {} ''
      mkdir -p $out/share/fonts/truetype
      cp ${./fonts}/*.ttf $out/share/fonts/truetype/
    '')
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
