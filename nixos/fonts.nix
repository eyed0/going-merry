{ pkgs, ... }:

{
  
  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "VictorMono" "SpaceMono" "RobotoMono" "FiraCode"]; })
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
	fontconfig = {
      enable = true;
      hinting.enable = true;
      cache32Bit = true;
	};
  };
  
}
