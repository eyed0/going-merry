{ config, pkgs, ... }:
let
  iopro = pkgs.iosevka.override {
    set = "Iopro";
    privateBuildPlan = {
      family = "Iopro";
      spacing = "term";
      serifs = "sans";
      noCvSs = true;
      exportGlyphNames = false;
      
      variants = {
        inherits = "ss08";
        design = {
          zero = "diamond-broken-reverse-slash";
          i = "hooky";
          l = "hooky";
          paren = "normal";
          at = "threefold-tall";
        };
      };
      
      weights = {
        regular = {
          shape = 400;  # Even lighter for PragmataPro feel
          menu = 400;
          css = 400;
        };
        bold = {
          shape = 680;  # Medium-bold rather than heavy
          menu = 680;
          css = 680;
        };
      };
      
      # Metric overrides for better PragmataPro matching
      metricOverride = {
        leading = 1180;           # Line height
        winAscent = 975;         # Windows ascent
        winDescent = 175;         # Windows descent
        typoAscent = 975;         # Typographic ascent (match winAscent)
        typoDescent = -175;       # Typographic descent (match winDescent)
        xHeight = 530;            # x-height for better proportions
        capHeight = 780;          # Capital height
      };
    };
  };
  
  # Patch with Nerd Fonts using font-patcher
  ioproNerd = pkgs.stdenv.mkDerivation {
    pname = "iopro-nerd-font";
    version = iopro.version;
    
    src = iopro;
    
    nativeBuildInputs = with pkgs; [
      nerd-font-patcher
    ];
    
    buildPhase = ''
      mkdir -p $out/share/fonts/truetype
      
      # Patch all font files with careful settings to preserve metrics
      for font in $src/share/fonts/truetype/*.ttf; do
        fontname=$(basename "$font")
        echo "Patching font: $fontname"
        
        nerd-font-patcher \
          --complete \
          --careful \
          --adjust-line-height \
          --outputdir $out/share/fonts/truetype \
          "$font"
      done
    '';
    
    installPhase = "true"; # Files already in place from buildPhase
    
    meta = iopro.meta // {
      description = "Iopro font patched with Nerd Fonts (PragmataPro-inspired)";
      longDescription = ''
        Custom Iosevka build configured to closely match PragmataPro's appearance,
        including distinctive character shapes, metrics, and programming-friendly features.
        Patched with complete Nerd Fonts icon set.
      '';
    };
  };
in
{
  # For system-wide installation (configuration.nix)
  fonts.packages = [ ioproNerd ];
  
  # # Optional: Font configuration for better rendering
  # fonts.fontconfig = {
  #   enable = true;
  #   defaultFonts = {
  #     monospace = [ "Iopro Nerd Font" ];
  #   };
  #   localConf = ''
  #     <alias>
  #       <family>Iopro</family>
  #       <prefer>
  #         <family>Iopro Nerd Font</family>
  #       </prefer>
  #     </alias>
  #   '';
  # }
  #;
}



  # leading (1200)

  # Total line height (space between baselines of consecutive lines)
  # Higher = more space between lines of text
  # 1200 units = slightly tighter than default Iosevka

  # winAscent (1000) & winDescent (200)

  # Windows-specific measurements for clipping
  # Define the absolute bounds of the character box
  # Total character box height = winAscent + winDescent = 1200 units

  # typoAscent (800) & typoDescent (-200)

  # Typography measurements for proper text layout
  # More precise than win metrics
  # Used by modern layout engines

  # xHeight (520)

  # Height of lowercase letters like 'x', 'a', 'e'
  # Affects readability and visual weight of text
  # 520 = slightly shorter x-height (more compact look)

  # capHeight (735)

  # Height of uppercase letters like 'A', 'B', 'C'
  # 735 = slightly shorter caps (less imposing uppercase)
