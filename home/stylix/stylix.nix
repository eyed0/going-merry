{
  pkgs,
  inputs,
  config,
  ...
}: {
  stylix.enable = true;
  stylix.image = ./../../wall/yotsuba.jpeg;
  stylix.polarity = "dark";
  #stylix.targets.nixos-icons.enable = true;
  #stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/vesper.yaml";
  stylix.base16Scheme = {
    base00 = "000000";
    base01 = "1E2326"; 
    base02 = "272E33";
    base03 = "414B50";
    base04 = "859289";
    base05 = "D3C6AA";
    base06 = "E4E1CD";
    base07 = "FDF6E3";
    base08 = "FF8F88";
    base09 = "F5AD7B";
    base0A = "FCCE7B";
    base0B = "A7C08C";
    base0C = "89BAB4";
    base0D = "7FBBB3";
    base0E = "D699B6";
    base0F = "E67E80";
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

  #opacity
  stylix.opacity.applications = 0.95;
  stylix.opacity.desktop = 0.95;
  stylix.opacity.terminal = 0.95;

  stylix = {
    targets = {
      fuzzel.enable = true;
      swaylock.useImage = true;
      mako.enable = true;
      foot.enable = true;
      #fish.enable = true;
      btop.enable = true;
      lazygit.enable = true;
      #kde.enable = true;
      xfce.enable = true;
      mpv.enable = true;
      firefox.enable = true;
      fzf.enable = true;
      yazi.enable = true;
      zathura.enable = true;
      bat.enable = true;
      qt.enable = true;
      gtk.enable = true;
      gtk.extraCss = with config.lib.stylix.colors; ''
        @define-color accent_color #${base0D};
        @define-color accent_bg_color #${base0D};
      '';
    };
  };
}
