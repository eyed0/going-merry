{ config, pkgs, ... }:

let
  ivoPro = pkgs.iosevka.override {
    set = "IvoPro";
    privateBuildPlan = {
      family = "IvoPro";
      spacing = "term";
      serifs = "sans";
      
      variants = {
        inherits = "ss08";
        design = {

          capital-a = "straight-serifless";
          capital-b = "standard-bilateral-serifless";
          capital-c = "serifless";
          capital-d = "standard-serifless";
          capital-e = "serifless";
          capital-f = "serifless";
          capital-g = "toothless-corner-serifless-capped";
          capital-h = "serifless";
          capital-i = "serifless";
          capital-j = "serifless";
          capital-k = "straight-serifless";
          capital-l = "serifless";
          capital-m = "hanging-serifless";
          capital-n = "standard-serifless";
          capital-o = "serifless";
          capital-p = "serifless";
          capital-q = "detached-bend-serifless";
          capital-r = "straight-serifless";
          capital-s = "serifless";
          capital-t = "serifless";
          capital-u = "toothless-rounded-serifless";
          capital-v = "straight-serifless";
          capital-w = "straight-flat-top-serifless";
          capital-x = "straight-serifless";
          capital-y = "straight-serifless";
          capital-z = "straight-serifless-with-crossbar";
          
          a = "double-storey-serifless";
          b = "toothless-rounded-serifless";
          c = "serifless";
          d = "toothless-rounded-serifless";
          e = "flat-crossbar";
          f = "straight-serifless";
          g = "single-storey-flat-hook-serifless";
          h = "straight-serifless";
          i = "serifed-flat-tailed";
          j = "serifed-flat-tailed";
          k = "straight-serifless";
          l = "serifed-flat-tailed";
          m = "earless-rounded-double-arch-serifless";
          n = "earless-rounded-straight-serifless";
          o = "serifless";
          p = "earless-rounded-serifless";
          q = "earless-rounded-serifless";
          r = "serifless";
          s = "serifless";
          t = "standard";
          u = "toothless-rounded-serifless";
          v = "straight-serifless";
          w = "straight-flat-top-serifless";
          x = "straight-serifless";
          y = "straight-turn-serifless";
          z = "straight-serifless-with-crossbar";
          
          zero = "dotted";
          one = "flat-top-base";
          two = "straight-neck-serifless";
          three = "two-arcs";
          four = "closed-serifless";
          five = "straight-upper-left-serifless";
          six = "straight-bar";
          seven = "straight-serifless";
          eight = "crossing";
          nine = "straight-bar";
          
          # Symbols - PragmataPro style
          at = "fourfold-solid";
          ampersand = "flat-top";
          dollar = "through";
          percent = "dots";
          question = "smooth";
          asterisk = "turn-hex-low";
        };
      };
      
      widths = {
        normal = 480;
      };
      
      slopes = {
        upright = 0;
        italic = 9.4;
      };
      
      weights = {
        regular = 380;
        bold = 680;
      };
    };
  };

  # Patch with Nerd Fonts
  ivoProNerd = pkgs.nerdfonts.override {
    fonts = [ ivoPro ];
  };
in
{
  # For system-wide installation (configuration.nix)
  fonts.packages = [ ivoProNerd ];
  
  # OR for home-manager (home.nix)
  # home.packages = [ ivoProNerd ];
  
  # Optional: Set as default monospace font
  #fonts.fontconfig.defaultFonts.monospace = [ "IvoPro Nerd Font" ];
}
