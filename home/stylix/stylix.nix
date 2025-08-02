{
  pkgs,
  inputs,
  config,
  ...
}: {
  stylix.enable = true;
  stylix.image = ./../../wall/yotsuba.jpeg;
  stylix.polarity = "dark";
  stylix.autoEnable = true;
  stylix.targets.qt.enable = false;
  #stylix.targets.nixos-icons.enable = true;
  #stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/vesper.yaml";
  stylix.base16Scheme = {

    # base00 = "000000";
    # base01 = "1E2326"; 
    # base02 = "272E33";
    # base03 = "414B50";
    # base04 = "859289";
    # base05 = "D3C6AA";
    # base06 = "E4E1CD";
    # base07 = "FDF6E3";
    # base08 = "FF8F88";
    # base09 = "F5AD7B";
    # base0A = "FCCE7B";
    # base0B = "A7C08C";
    # base0C = "89BAB4";
    # base0D = "7FBBB3";
    # base0E = "D699B6";
    # base0F = "E67E80";

    # base00 = "0f1419"; # Default Background - very dark blue-grey
    # base01 = "1a1f29"; # Lighter Background (status bars, line numbers)
    # base02 = "232834"; # Selection Background - dark grey-blue
    # base03 = "2d3343"; # Comments, Invisibles, Line Highlighting
    # base04 = "4a5462"; # Dark Foreground (status bars)
    # base05 =  "a7b7c6"; # Default Foreground - muted blue-grey
    # base06 = "b8c5d1"; # Light Foreground (not often used)
    # base07 = "d3dae3"; # Light Background (not often used)
    # base08 = "d67e7e"; # Variables, XML Tags, Markup Link Text - muted red
    # base09 = "d69e5a"; # Integers, Boolean, Constants - darker orange
    # base0A = "c2b680"; # Classes, Markup Bold, Search Text Background - muted yellow
    # base0B = "7fb069"; # Strings, Inherited Class, Markup Code - forest green
    # base0C = "6bb3a0"; # Support, Regular Expressions, Escape Characters - teal
    # base0D = "7aa2d4"; # Functions, Methods, Attribute IDs, Headings - muted blue
    # base0E =  "b4a7d6"; # Keywords, Storage, Selector, Markup Italic - muted purple
    # base0F = "c17b69"; # Deprecated, Opening/Closing Embedded Language Tags - rust

    # base00 = "#1a1d23"; # Default Background - much darker
    # base01 = "#1f2329"; # Lighter Background - darker than original
    # base02 = "#2a2f38"; # Selection Background - significantly darker
    # base03 = "#4a423d"; # Comments, Invisibles - darker brown
    # base04 = "#6b5f5a"; # Dark Foreground - muted brown
    # base05 = "#7a6f65"; # Default Foreground - darker beige
    # base06 = "#9d8a7a"; # Light Foreground - muted tan
    # base07 = "#c7b299"; # Light Background - darker cream
    # base08 = "#5a7a7a"; # Variables - darker teal blue
    # base09 = "#785a2b"; # Integers, Boolean - darker gold
    # base0A = "#785a2b"; # Classes - darker gold (same as base09)
    # base0B = "#3a6a6a"; # Strings - darker teal green
    # base0C = "#5a7a7a"; # Support - darker teal blue (same as base08)
    # base0D = "#5a7a7a"; # Functions - darker teal blue (same as base08)
    # base0E = "#a04545"; # Keywords - darker red
    # base0F = "#7a5219"; # Deprecated - darker brown orange

    
    base00 = "232a2e";  # Default Background (bg_dim - darkest available)
    base01 = "2d353b";  # Lighter Background (bg0)
    base02 = "343f44";  # Selection Background (bg1)
    base03 = "859289";  # Comments, Invisibles, Line Highlighting (grey1 - brighter for contrast)
    base04 = "9da9a0";  # Dark Foreground (grey2 - brighter)
    base05 = "e8dcc6";  # Default Foreground (brightened fg)
    base06 = "f0e9d2";  # Light Foreground (even brighter)
    base07 = "4f585e";  # Light Background (bg4)
    base08 = "f85552";  # Variables, XML Tags, Markup Link Text (brightened red)
    base09 = "f57c00";  # Integers, Boolean, Constants (enhanced orange)
    base0A = "e6c547";  # Classes, Markup Bold, Search Text Background (brightened yellow)
    base0B = "8fb573";  # Strings, Inherited Class, Markup Code (enhanced green)
    base0C = "6ec398";  # Support, Regular Expressions, Escape Characters (enhanced aqua)
    base0D = "5cb3cc";  # Functions, Methods, Attribute IDs (brightened blue)
    base0E = "e27d60"; # Keywords, Storage, Selector (enhanced purple/pink)
    base0F = "bf616a";  # Deprecated, Opening/Closing Embedded Language Tags (bright red-brown)

  };

  # # fonts settings
  # stylix.fonts = {
  #   serif = {
  #     package = pkgs.alegreya;
  #     name = "Alegreya";
  #   };

  #   sansSerif = {
  #     package = pkgs.atkinson-hyperlegible;
  #     name = "Atkinson Hyperlegible";
  #   };

  #   #monospace = {
  #   #  package = pkgs.cascadia-code;
  #   #  name = "PragmataProLiga Nerd Font";
  #   #};

  #   emoji = {
  #     package = pkgs.noto-fonts-emoji;
  #     name = "Noto Color Emoji";
  #   };
  # };

  # # font sizes 
  # stylix.fonts.sizes.applications = 11;
  # stylix.fonts.sizes.desktop = 10;
  # stylix.fonts.sizes.popups = 9;
  # stylix.fonts.sizes.terminal = 12;

  # # cursor setting 
  # stylix.cursor.package = pkgs.bibata-cursors;
  # stylix.cursor.name = "Bibata-Modern-Ice";
  # stylix.cursor.size = 24;

  # #icon style
  # stylix.iconTheme.enable = true;
  # stylix.iconTheme.package = "papirus-icon-theme";
  # stylix.iconTheme.dark = "papirus-icon-theme";

  #opacity
  stylix.opacity.applications = 0.95;
  stylix.opacity.desktop = 0.95;
  stylix.opacity.terminal = 0.95;

}
