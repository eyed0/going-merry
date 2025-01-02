{ config, pkgs, lib, ... }:

{
  programs.fuzzel.enable = true;
  programs.fuzzel.settings =
	{
	  main = {
		terminal = "${pkgs.foot}/bin/foot";
		layer = "overlay";
		prompt = "'󱄅 '";
	  };
	};

    # Create a script for fuzzel integration
  home.file.".local/bin/clipman-fuzzel" = {
    executable = true;
    text = ''
      #!/bin/sh
      clipman pick -t fuzzel
    '';
  };
}
