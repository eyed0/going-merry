{ config, pkgs, ... }:
let
  ivoPro = pkgs.iosevka.override {
    set = "IvoPro";
    privateBuildPlan = {
      family = "IvoPro";
      spacing = "term";
      serifs = "sans";
      no-cv-ss = false;
      export-glyph-names = false;
      
      variants = {
        inherits = "ss08";
        # Start with minimal variants, add more once this works
        design = {
          # Just a few key PragmataPro characteristics
          zero = "dotted";
          # one = "flat-top-base";
          four = "closed-serifless";
          g = "single-storey-flat-hook-serifless";
          a = "double-storey-serifless";
        };
      };
      
      weights = {
        regular = {
          shape = 380;  # Lighter than standard 400
          menu = 380;
          css = 380;
        };
        bold = {
          shape = 680;  # Lighter than standard 700
          menu = 680;
          css = 680;
        };
      };
      
      slopes = {
        upright = {
          angle = 0;
          shape = "upright";
          menu = "upright";
          css = "normal";
        };
        italic = {
          angle = 9.4;
          shape = "italic";
          menu = "italic";
          css = "italic";
        };
      };
      
      widths = {
        normal = {
          shape = 480;  # More compact than 500
          menu = 5;
          css = "normal";
        };
      };
    };
  };
  
  # Patch with Nerd Fonts using font-patcher
  ivoProNerd = pkgs.stdenv.mkDerivation {
    pname = "ivopro-nerd-font";
    version = ivoPro.version;
    
    src = ivoPro;
    
    nativeBuildInputs = with pkgs; [
      nerd-font-patcher
    ];
    
    buildPhase = ''
      mkdir -p $out/share/fonts/truetype
      
      # Patch all font files
      for font in $src/share/fonts/truetype/*.ttf; do
        echo "Patching font: $(basename "$font")"
        nerd-font-patcher \
          --complete \
          --outputdir $out/share/fonts/truetype \
          "$font"
      done
    '';
    
    installPhase = "true"; # Files already in place from buildPhase
    
    meta = ivoPro.meta // {
      description = "IvoPro font patched with Nerd Fonts";
    };
  };
in
{
  # For system-wide installation (configuration.nix)
  fonts.packages = [ ivoProNerd ];
}
