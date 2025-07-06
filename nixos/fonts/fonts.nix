{ pkgs, ... }:
{
  fonts.packages = with pkgs; [
    lexend
    lohit-fonts.marathi
    marathi-cursive
    aspellDicts.mr
    merriweather-sans
    atkinson-hyperlegible
    alegreya
    alegreya-sans
    # Add your custom fonts directory
    (pkgs.runCommand "my-custom-fonts" {} ''
      mkdir -p $out/share/fonts/truetype
      cp ${./fonts}/*.ttf $out/share/fonts/truetype/
    '')
  ];
  
  fonts = {
    fontconfig = {
      enable = true;
      cache32Bit = true;
      antialias = true;
      hinting = {
        enable = true;
        style = "full";  # Changed from "slight" to "full" for 1080p
        autohint = false;
      };
      subpixel = {
        rgba = "rgb";
        lcdfilter = "default";
      };
      
      # Improve font smoothing
      localConf = ''
      <fontconfig>
        <match target="font">
          <edit name="lcdfilter" mode="assign">
            <const>lcddefault</const>
          </edit>
        </match>
        <match target="font">
          <edit name="rgba" mode="assign">
            <const>rgb</const>
          </edit>
        </match>
        <!-- Better rendering for smaller fonts -->
        <match target="font">
          <test name="size" qual="any" compare="less">
            <double>12</double>
          </test>
          <edit name="hinting" mode="assign">
            <bool>true</bool>
          </edit>
          <edit name="hintstyle" mode="assign">
            <const>hintslight</const>
          </edit>
        </match>
      </fontconfig>
    '';
    };
  };
}
