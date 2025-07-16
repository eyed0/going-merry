{
  pkgs,
  inputs,
  config,
  ...
}: {
  stylix.enable = true;
  stylix.autoEnable = true;
  stylix.targets.qt.enable = false;
  #stylix.image = ./../../wall/yotsuba.jpeg;
  stylix.polarity = "dark";
  stylix.targets.nixos-icons.enable = true;
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

    # base00 = "0a0f08";  # Deep forest shadow
    # base01 = "141a12";  # Dark meadow
    # base02 = "1f2b1d";  # Shadowed grass
    # base03 = "2d3c2a";  # Tree bark
    # base04 = "495a46";  # Weathered stone
    # base05 = "a8b5a2";  # Soft meadow text
    # base06 = "c2d0bb";  # Light grass
    # base07 = "e1f0d9";  # Sunlit highlights
    # base08 = "8b5a5a";  # Castle brick
    # base09 = "b8794a";  # Warm earth
    # base0A = "d4c441";  # Golden meadow
    # base0B = "5a8b3d";  # Rich pasture green
    # base0C = "4a7c7c";  # Stream blue
    # base0D = "5a7ab8";  # Castle tower blue
    # base0E = "8b6bb8";  # Distant mountain purple
    # base0F = "8b7355";  # Weathered wood

    base00 = "0b0a08";  # Deep shadow - darkest corner
    base01 = "1a1612";  # Weathered wood shadow
    base02 = "2c241e";  # Stone foundation
    base03 = "3e342a";  # Aged timber
    base04 = "5a4d3f";  # Moss-covered stone
    base05 = "c4b49a";  # Cream cat fur / parchment
    base06 = "d9cbb3";  # Light cream
    base07 = "f0e6d4";  # Sunlit white fur
    base08 = "8b5a3c";  # Rust on old tools
    base09 = "b8794a";  # Warm wood grain
    base0A = "d4a851";  # Golden sunlight patches
    base0B = "6b8b3d";  # Deep garden green
    base0C = "4a7c59";  # Shadowed moss
    base0D = "5a7a8a";  # Weathered blue-gray
    base0E = "7a6b8b";  # Lavender in shadows
    base0F = "8b6f47";  # Bark and earth tones


    
  };

    # fonts settings
  stylix.fonts = {
    serif = {
      package = pkgs.alegreya;
      name = "Alegreya";
    };

    sansSerif = {
      package = pkgs.atkinson-hyperlegible;
      name = "Atkinson Hyperlegible";
    };

    #monospace = {
    #  package = pkgs.cascadia-code;
    #  name = "PragmataProLiga Nerd Font";
    #};

    emoji = {
      package = pkgs.noto-fonts-emoji;
      name = "Noto Color Emoji";
    };
  };

  # font sizes 
  stylix.fonts.sizes.applications = 11;
  stylix.fonts.sizes.desktop = 10;
  stylix.fonts.sizes.popups = 9;
  stylix.fonts.sizes.terminal = 12;

  # cursor setting 
  stylix.cursor.package = pkgs.bibata-cursors;
  stylix.cursor.name = "Bibata-Modern-Ice";
  stylix.cursor.size = 24;

  # #icon style
  # stylix.iconTheme.enable = true;
  # stylix.iconTheme.package = "papirus-icon-theme";
  # stylix.iconTheme.dark = "papirus-icon-theme";

  #stylix.homeManagerIntegration.followSystem = true;
  
}
