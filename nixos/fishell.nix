{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:
{
  programs.fish = {
    enable = true;
    shellAliases = {
      nfup = "nix flake update";
      nfsw = "nixos-rebuild switch --flake .";
      hmsw = "home-manager switch --flake .";
      hmswb = "home-manager switch -b backup --flake .";
      gaa = "git add .";
      gs = "git status";
      ncgar = "nix-collect-garbage";
      gcm = "git commit -m";
      em = "emacsclient -c";
      btop = "btop --utf-force";
      ls = "lsd";
      l = "ls -l";
      la = "ls -a";
      lla = "ls -la";
      lt = "ls --tree";
    };
    shellInit = ''
      zoxide init fish | source
      function fish_greeting
        fastfetch
      end
    '';
    interactiveShellInit = ''
      set -gx EDITOR hx
      set -gx VOLUME_STEP 5
      set -gx BRIGHTNESS_STEP 5
      set fish_vi_force_cursor
      set fish_cursor_default block
      set fish_cursor_insert line blink
      set fish_cursor_visual underscore blink
      fish_vi_key_bindings
      bind yy fish_clipboard_copy
      bind Y fish_clipboard_copy
      bind -M visual y fish_clipboard_copy
      bind -M default p fish_clipboard_paste
      
      # Set fish prompt to "scales"
      set -g fish_prompt_pwd_dir_length 0
      set -g fish_color_cwd green
      fish_config prompt choose scales
      
      # Theme inspired by Everforest with darker background
      # Base colors
      set -g fish_color_normal d3c6aa
      set -g fish_color_command a7c080
      set -g fish_color_keyword d699b6
      set -g fish_color_quote e69875
      set -g fish_color_redirection 7fbbb3
      set -g fish_color_end e67e80
      set -g fish_color_error e67e80
      set -g fish_color_param d3c6aa
      set -g fish_color_comment 859289
      set -g fish_color_selection --background=3c474d
      set -g fish_color_search_match --background=3c474d
      set -g fish_color_operator 7fbbb3
      set -g fish_color_escape d699b6
      set -g fish_color_autosuggestion 6c7b77
      
      # Darker background settings
      set -g fish_color_host_remote d699b6
      set -g fish_color_host 7fbbb3
      set -g fish_color_cancel e67e80
      set -g fish_pager_color_prefix 7fbbb3
      set -g fish_pager_color_completion d3c6aa
      set -g fish_pager_color_description 6c7b77
      set -g fish_pager_color_progress 7fbbb3
      
      # Set darker background for prompt
      set -g fish_color_cwd_root e67e80
      set -g fish_color_user 7fbbb3
    '';
  };
  # Activate and set fish shell as default
  users.extraUsers.heehaw = {
    shell = "/run/current-system/sw/bin/fish";
  };
  environment = {
    shells = [
      "${pkgs.fish}/bin/fish"
      "${pkgs.bash}/bin/bash"
    ];
  };  
}
