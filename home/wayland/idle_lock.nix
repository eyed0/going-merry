{ config, pkgs, lib, ... }:

{
  services.swayidle = {
    enable = true;
    
    # Timeout in seconds
    timeouts = [
      # After 300 seconds (5 minutes) of inactivity:
      # Turn off displays
      {
        timeout = 300;
		command = ''
          if ! ${pkgs.playerctl}/bin/playerctl status | grep -q "Playing"; then
            ${pkgs.sway}/bin/swaymsg 'output * dpms off'
          fi
        '';
        resumeCommand = "${pkgs.sway}/bin/swaymsg 'output * dpms on'";
        # command = "${pkgs.sway}/bin/swaymsg 'output * dpms off'";
        # resumeCommand = "${pkgs.sway}/bin/swaymsg 'output * dpms on'";
      }
      
      # After 600 seconds (10 minutes) of inactivity:
      # Lock the screen
      {
        timeout = 600;
		command = ''
          if ! ${pkgs.playerctl}/bin/playerctl status | grep -q "Playing"; then
            ${pkgs.swaylock}/bin/swaylock -f -c 000000
          fi
        '';
         # command = "${pkgs.swaylock}/bin/swaylock -f -c 000000";
      }
      
      # After 900 seconds (15 minutes) of inactivity:
      # Suspend the system
      {
        timeout = 900;
		command = ''
          if ! ${pkgs.playerctl}/bin/playerctl status | grep -q "Playing"; then
            ${pkgs.systemd}/bin/systemctl suspend
          fi
        '';
        # command = "${pkgs.systemd}/bin/systemctl suspend";
      }
    ];
    
    events = [
      # Lock screen before sleep
      {
        event = "before-sleep";
        command = "${pkgs.swaylock}/bin/swaylock -f -c 000000";
      }
      
      # Turn off displays before sleep
      {
        event = "before-sleep";
        command = "${pkgs.sway}/bin/swaymsg 'output * dpms off'";
      }
	  
	  # TODO Lock screen after resume
      {
        event = "after-resume";
        command = "${pkgs.swaylock}/bin/swaylock -f -c 000000";
      }
      # Turn on displays after resume
      {
        event = "after-resume";
        command = "${pkgs.sway}/bin/swaymsg 'output * dpms on'";
      }
    ];
  };

  # Ensure required packages are installed
  home.packages = with pkgs; [
    swayidle
    swaylock-effects  # Required for screen locking
	playerctl
  ];
  
  programs.swaylock = {
    enable = true;
    package = pkgs.swaylock-effects;
    settings = {
      # Clock
      clock = true;
      timestr = "%H:%M:%S";
      datestr = "%Y-%m-%d";
      
      # Appearance
      font = "Atkinson Hyperlegible";
      font-size = 24;
      
      # Colors - Kanagawa inspired
      # Main background - fujiDark
      color = lib.mkForce "1F1F28";
      inside-color = lib.mkForce "1F1F28AA";
      
      # Ring - crystalBlue
      ring-color = lib.mkForce "7E9CD8";
      line-color = lib.mkForce "00000000";
      
      # Text - fujiWhite
      text-color = lib.mkForce "DCD7BA";
      layout-text-color = lib.mkForce "DCD7BA";
      
      # Clear - springGreen
      inside-clear-color = lib.mkForce "98BB6CCC";
      ring-clear-color = lib.mkForce "98BB6C";
      text-clear-color = lib.mkForce "DCD7BA";
      
      # Verify - crystalBlue
      inside-ver-color = lib.mkForce "7E9CD8CC";
      ring-ver-color = lib.mkForce "7E9CD8";
      text-ver-color = lib.mkForce "DCD7BA";
      
      # Wrong - autumnRed
      inside-wrong-color = lib.mkForce "C34043CC";
      ring-wrong-color = lib.mkForce "C34043";
      text-wrong-color = lib.mkForce "DCD7BA";
      
      # Effects
      key-hl-color = lib.mkForce "7FB4CA";      # lotusBlue2
      bs-hl-color = lib.mkForce "C34043";       # autumnRed
      caps-lock-key-hl-color = lib.mkForce "98BB6C";  # springGreen
      caps-lock-bs-hl-color = lib.mkForce "C34043";   # autumnRed
      
      # Functionality
      ignore-empty-password = true;
      indicator-caps-lock = true;
      show-failed-attempts = true;
      
      # Screen
      scaling = "fill";
      effect-blur = "7x5";
      effect-vignette = "0.5:0.5";
    };
  };
}
