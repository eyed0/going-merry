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
        design = {
          # Numbers
          one = "no-base";
          two = "straight-neck-serifless";
          three = "two-arcs";
          four = "closed-serifless";
          five = "oblique-arched-serifless";
          six = "straight-bar";
          seven = "curly-serifless";
          eight = "crossing";
          nine = "straight-bar";
          zero = "diamond-dotted";
          
          # Uppercase letters
          capital-a = "curly-serifless";
          capital-b = "standard-serifless";
          capital-c = "serifless";
          capital-d = "more-rounded-serifless";
          capital-e = "serifless";
          capital-f = "serifless";
          capital-g = "toothless-rounded-serifless-capped";
          capital-h = "serifless";
          capital-i = "short-serifed";
          capital-j = "serifless";
          capital-k = "curly-serifless";
          capital-l = "serifless";
          capital-m = "flat-bottom-serifless";
          capital-n = "asymmetric-serifless";
          capital-p = "closed-serifless";
          capital-q = "straight";
          capital-r = "curly-serifless";
          capital-s = "serifless";
          capital-t = "serifless";
          capital-u = "toothless-rounded-serifless";
          capital-v = "curly-serifless";
          capital-w = "curly-serifless";
          capital-x = "curly-serifless";
          capital-y = "curly-serifless";
          capital-z = "curly-serifless";
          
          # Lowercase letters
          a = "double-storey-serifless";
          b = "toothless-corner-serifless";
          c = "serifless";
          d = "toothless-corner-serifless";
          e = "flat-crossbar";
          f = "serifless";
          g = "double-storey";
          h = "straight-serifless";
          i = "hooky-bottom";
          j = "flat-hook-serifed";
          k = "curly-serifless";
          l = "zshaped";
          m = "serifless";
          n = "straight-serifless";
          p = "eared-serifless";
          q = "top-cut-straight-serifed";
          r = "earless-corner-serifless";
          s = "serifless";
          t = "flat-hook";
          u = "toothless-corner-serifless";
          v = "curly-serifless";
          w = "curly-serifless";
          x = "curly-serifless";
          y = "curly-serifless";
          z = "curly-serifless";
          
          # Special characters and symbols
          lower-pi = "tailed";
          punctuation-dot = "round";
          braille-dot = "round";
          tilde = "low";
          asterisk = "penta-low";
          caret = "high";
          paren = "flat-arc";
          brace = "straight";
          guillemet = "curly";
          ampersand = "upper-open";
          at = "threefold-tall";
          dollar = "open";
          percent = "rings-segmented-slash";
          bar = "force-upright";
          question = "smooth";
          decorative-angle-brackets = "middle";
          
          # Ligatures
          lig-ltgteq = "slanted";
          lig-neq = "slightly-slanted-dotted";
          lig-equal-chain = "with-notch";
          lig-hyphen-chain = "with-notch";
        };
      };
      
      weights = {
        regular = {
          shape = 370;  # Even lighter for PragmataPro feel
          menu = 370;
          css = 370;
        };
        bold = {
          shape = 650;  # Medium-bold rather than heavy
          menu = 650;
          css = 650;
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
          angle = 11;   # Slightly more italic angle like PragmataPro
          shape = "italic";
          menu = "italic";
          css = "italic";
        };
      };
      
      widths = {
        normal = {
          shape = 470;  # Slightly more compact
          menu = 5;
          css = "normal";
        };
      };
      
      # Metric overrides for better PragmataPro matching
      metricOverride = {
        leading = 1250;           # Line height
        winAscent = 880;          # Windows ascent
        winDescent = 220;         # Windows descent
        typoAscent = 860;         # Typographic ascent  
        typoDescent = -140;       # Typographic descent
        xHeight = 520;            # x-height for better proportions
        capHeight = 720;          # Capital height
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
    
    meta = ivoPro.meta // {
      description = "IvoPro font patched with Nerd Fonts (PragmataPro-inspired)";
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
  fonts.packages = [ ivoProNerd ];
  
  # Optional: Font configuration for better rendering
  fonts.fontconfig = {
    enable = true;
    defaultFonts = {
      monospace = [ "IvoPro Nerd Font" ];
    };
    localConf = ''
      <alias>
        <family>IvoPro</family>
        <prefer>
          <family>IvoPro Nerd Font</family>
        </prefer>
      </alias>
    '';
  };
}
