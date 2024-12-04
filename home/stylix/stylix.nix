{
  pkgs,
  inputs,
  config,
  ...
}: {
  stylix.enable = true;
  stylix.image = ./../../wall/darknix.jpg;
  stylix.polarity = "dark";
  #stylix.targets.nixos-icons.enable = true;
  #stylix.targets.gtk.enable = true;
  #stylix.targets.fish.enable = true;
  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/vesper.yaml";

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

    monospace = {
      package = pkgs.cascadia-code;
      name = "PragmataProLiga Nerd Font";
    };

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

  # # applications 
  # stylix.targets.btop.enable = true;
  # stylix.targets.firefox.enable = true;
  # stylix.targets.kde.enable = true;
  # stylix.targets.foot.enable = true;
  # stylix.targets.yazi.enable = true;

  stylix = {
	targets = {
	  fuzzel.enable = true;
	  #swaylock.enable = true;
	  swaylock.useImage = true;
	  mako.enable = true;
      foot.enable = true;
	  btop.enable = true;
      lazygit.enable = true;
      kde.enable = true;
      firefox.enable = true;
      fzf.enable = true;
      yazi.enable = true;
      # waybar.enable = true;
	  # waybar.enableCenterBackColors =true;
	  # waybar.enableLeftBackColors = true;
	  # waybar.enableRightBackColors = true;
      gtk.enable = true;
      gtk.extraCss = with config.lib.stylix.colors; ''
        @define-color accent_color #${base0D};
        @define-color accent_bg_color #${base0D};
      '';
    };
  };
}
