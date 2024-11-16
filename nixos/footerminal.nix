{
  pkgs, inputs, config, ...
}: 
{
  # terminal 
  programs.foot =
    {
      enable = true;
      enableFishIntegration = true;
      enableBashIntegration = true;
      settings = {
        main = {
          font = "PragmataProLiga Nerd Font:size=14";
          initial-window-size-pixels = "1920x1080";
          initial-window-mode = "maximized";
		  box-drawings-uses-font-glyphs = "yes";
        };
        bell = {
          notify = "yes";
        };
		tweak = {
          font-monospace-warn = "no";
          sixel = "yes";
		};
        scrollback = {
          multiplier = "5.0";
        };
      };
    };
}
