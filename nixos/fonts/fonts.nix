{ pkgs, ... }:
{
  fonts.packages = with pkgs; [
    lexend
    lohit-fonts.marathi
    marathi-cursive
    aspellDicts.mr
    atkinson-hyperlegible
    pkgs.nerd-fonts.iosevka
    
    # # Custom configured Iosevka
    # (iosevka.override {
    #   set = "custom";
    #   privateBuildPlan = {
    #     family = "Iosevka Custom";
    #     spacing = "normal";  # or "term", "fontconfig-mono", "fixed"
    #     serifs = "sans";     # or "slab"
    #     no-cv-ss = false;
    #     export-glyph-names = false;
        
    #     variants = {
    #       inherits = "ss08";  # Pragmata Pro style
    #       # You can override specific characters:
    #       # cv01 = 1;  # Alternative style for 'a'
    #       # cv02 = 1;  # Alternative style for 'g'
    #       # ss01 = 1;  # Stylistic set 1
    #     };
        
    #     weights = {
    #       regular = {
    #         shape = 400;
    #         menu = 400;
    #         css = 400;
    #       };
    #       bold = {
    #         shape = 700;
    #         menu = 700;
    #         css = 700;
    #       };
    #     };
        
    #     slopes = {
    #       upright = {
    #         angle = 0;
    #         shape = "upright";
    #         menu = "upright";
    #         css = "normal";
    #       };
    #       italic = {
    #         angle = 9.4;
    #         shape = "italic";
    #         menu = "italic";
    #         css = "italic";
    #       };
    #     };
        
    #     widths = {
    #       normal = {
    #         shape = 500;
    #         menu = 5;
    #         css = "normal";
    #       };
    #     };
    #   };
    # })
    
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
