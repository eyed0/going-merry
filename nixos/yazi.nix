{ config, pkgs, ... }:

{
  programs.yazi = {
    enable = true;
    
    # # Kanagawa Wave inspired theme
    # settings.theme = {
    #   manager = {
    #     # Kanagawa Wave colors
    #     cwd = { fg = "#DCD7BA" }; # wave foreground
    #     hovered = { fg = "#2D4F67" bg = "#C8C093" }; # selection colors
    #     preview_hovered = { underline = true };
        
    #     find_keyword = { fg = "#FF9E3B" }; # surimiOrange
    #     find_position = { fg = "#7E9CD8" }; # crystalBlue
        
    #     # Border colors
    #     border_symbol = "│";
    #     border_style = { fg = "#54546D" }; # sumiInk4
        
    #     # File colors
    #     directory = { fg = "#7E9CD8" }; # crystalBlue
    #     executable = { fg = "#98BB6C" }; # springGreen
    #     regular = { fg = "#DCD7BA" }; # wave foreground
    #     link = { fg = "#7FB4CA" }; # lightBlue
    #     broken = { fg = "#E46876" }; # peachRed
        
    #     # Icon colors
    #     image = { fg = "#E6C384" }; # carpYellow
    #     video = { fg = "#FF9E3B" }; # surimiOrange
    #     music = { fg = "#938AA9" }; # fujiGray
    #     archive = { fg = "#7E9CD8" }; # crystalBlue
    #   };
      
    #   status = {
    #     separator_open = "";
    #     separator_close = "";
    #     separator_style = { fg = "#54546D" }; # sumiInk4
    #     normal = { fg = "#DCD7BA" bg = "#223249" }; # wave foreground, sumiInk2
    #   };
      
    #   input = {
    #     border = { fg = "#54546D" }; # sumiInk4
    #     value = { fg = "#DCD7BA" }; # wave foreground
    #     selected = { reversed = true };
    #   };
      
    #   select = {
    #     border = { fg = "#54546D" }; # sumiInk4
    #     active = { fg = "#98BB6C" }; # springGreen
    #   };
      
    #   tasks = {
    #     border = { fg = "#54546D" }; # sumiInk4
    #     hovered = { underline = true };
    #   };
    # };
    
    # General settings
    settings.yazi = {
      manager = {
		ratio = [1 3 4];
        show_hidden = false;
        show_symlink = true;
        sort_by = "alphabetical";
        sort_reverse = false;
        sort_dir_first = true;
		linemode = "mtime";
      };
	  preview = {
		wrap = "yes";
		image_filter = "catmull-rom";
		image_quality = 75;
		sixel_fraction = 18;
	  };
	  input = {
		cursor_blink = false;
	  };
    };
  };
}
