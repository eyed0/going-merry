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
	  l= "ls -l";
      la= "ls -a";
      lla= "ls -la";
      lt= "ls --tree";
	};
	shellInit = ''
	  zoxide init fish | source
      starship init fish | source
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
