{
  pkgs, inputs, config, lib, ...
}:
{
  programs.waybar = {
    enable = true;
    systemd = {
      enable = false;
      target = "graphical-session.target";
    };
	  
    settings = {
	    
	    mainBar = {
		    layer = "top";
		    position = "right";
		    margin = "0 0 0 0";
		    reload_style_on_change = true;
		    output = [
		      "eDP-1"
		    ];

		    modules-left = [ "niri/workspaces" ];
		    modules-center = [ ];
		    modules-right = [ "tray" "custom/cliphist" "custom/kdeconnect" "wireplumber" "network" "power-profiles-daemon" "battery" "backlight" "clock" "custom/power" ]; 
		    
		    "niri/workspaces" = {
          format = "{icon}";
		      on-click = "activate";
		      all-outputs = true;
          format-icons = {
			      "1" = "𑙑";
			      "2" = "𑙒";
			      "3" = "𑙓";
			      "4" = "𑙔";
			      "5" = "𑙕";
			      "6" = "𑙖";
			      "7" = "𑙗";
			      "8" = "𑙘";
			      "9" = "𑙙";
			      "10" = "𑙑𑙐";
          };
		    };
		    
		    tray = {
          icon-size = 16;
          spacing = 8;
        };

        # add "custom/swayidle-toggle" to modules 
        # "custom/swayidle-toggle" = {
		    #   format = "{}";
		    #   exec = "if pgrep -x swayidle > /dev/null; then echo '󰅶'; else echo '󰾪'; fi";
		    #   on-click = "pkill swayidle || swayidle -w timeout 300 'swaylock' timeout 600 'systemctl suspend' before-sleep 'swaylock' &";
		    #   interval = 2;
		    #   tooltip-format = "Toggle auto-suspend\nClick to enable/disable";
		    #   tooltip = true;
		    # };

        #   #custom-swayidle-toggle {
        #   color: #f2cdcd;
        #   padding: 4px 4px;
        #   margin: 4px 0;
        # }

		    wireplumber =  {
		      rotate = 270;
          format = "{icon}  {volume}%";
          format-muted = " ";
          on-click = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
          max-volume = 120;
          scroll-step = 1;
          format-icons = ["" "" " "];
        };

        network = {
          format = "{icon}";
          format-ethernet = "󰈀";
          format-wifi = "󰖩";
          format-disconnected = "󰖪";
          format-icons = ["󰤫" "󰤟" "󰤢" "󰤥" "󰤨"];
          tooltip-format-wifi = "{essid} ({signalStrength}%) - {ipaddr}";
          tooltip-format-ethernet = "{ifname} - {ipaddr}";
          on-click = "${pkgs.networkmanagerapplet}/bin/nm-connection-editor";
          interval = 5;
        };

		    power-profiles-daemon = {
          format = "{icon}";
          tooltip-format = "Power profile: {profile}\nDriver: {driver}";
          tooltip = true;
          format-icons = {
            default = "";
            performance = "";
            balanced = "󱈑";
            power-saver = "";
          };
        };

		    "battery" = {
		      rotate = 270;
		      states = {
			      good = 95;
			      warning = 20;
			      critical = 15;
		      };
		      format = "{icon}  {capacity}";
		      format-charging = " {capacity}%";
		      format-full = "<span color='#82A55F'><b>{icon}</b></span>";
		      format-icons = ["󰁻" "󰁼" "󰁾" "󰂀" "󰂂" "󰁹"];
		      tooltip-format = "{timeTo} {capacity} % | {power} W";
		    };

		    backlight = {
		      format = "{icon}";
		      format-icons = [ "" "" "" "" "" "" "" "" "" "" "" "" "" "" ""
		                     ];
		      tooltip = true;
		      tooltip-format = "Brightness: {percent}% ";
		      interval = 1;
		      #on-scroll-up = "brightnessctl s 1%+";
          #on-scroll-down = "brightnessctl s 1%";
          on-scroll-up = "${pkgs.brightnessctl}/bin/brightnessctl set 1%+";
          on-scroll-down = "${pkgs.brightnessctl}/bin/brightnessctl set 1%-";
		      smooth-scrolling-threshold = 1;
		    };

		    "clock" = {
		      format = "{:%H\n%M}";
		      tooltip-format = "<big>{calendar}</big>";
		      calendar = {
			      mode = "month";
			      mode-mon-col = 3;
			      weeks-pos = "right";
			      on-scroll = 1;
			      on-click-right = "mode";
			      format = {
			        today = "<span color='#a6e3a1'><b><u>{}</u></b></span>";
			      };
		      };
		    };

        "custom/cliphist" = {
		      format = "󰅌";
		      on-click = "cliphist list | fuzzel --dmenu | cliphist decode | wl-copy";
		      tooltip-format = "Clipboard History\nClick to open";
		      tooltip = true;
		    };

		    "custom/kdeconnect" = {
		      format = "󰄜";
		      exec = "kdeconnect-cli --list-available --name-only | wc -l";
		      exec-if = "command -v kdeconnect-cli";
		      interval = 30;
		      on-click = "kdeconnect-app";
		      tooltip-format = "{} device(s) connected";
		      tooltip = true;
		    };

		    "custom/power" = {
          format = "󰤆";
          on-click = ''
    bash -c '
      option=$(echo -e "⏻ Shutdown\n🔄 Reboot\n⏾ Suspend\n🔒 Lock\n🚪 Logout" | ${pkgs.fuzzel}/bin/fuzzel --dmenu --prompt="Power: " --width=25 --lines=5)
      case "$option" in
        "⏻ Shutdown") systemctl poweroff ;;
        "🔄 Reboot") systemctl reboot ;;
        "⏾ Suspend") systemctl suspend ;;
        "🔒 Lock") ${pkgs.swaylock}/bin/swaylock ;;
        "🚪 Logout") niri msg action quit ;;
      esac
    '
  '';
          tooltip = "Power Menu";
        };
		    
	    };
    };


	  style =
	    ''* {
    border: none;
    border-radius: 0;
    font-family: "RobotMono Nerd Font";
    font-size: 16px;
    min-height: 0;
    padding: 0;
    margin: 0;
      }

#waybar {
    background: rgba(30, 30, 30, 0.9);
    color: #ffffff;
}

#workspaces {
    margin: 8px 0;
    padding: 0 4px;
}

#workspaces button {
    color: #888888;
    padding: 8px 4px;
    min-width: 20px;
    transition: all 0.3s ease-in-out;
}

#workspaces button.active {
    color: #ffffff;
    background: rgba(255, 255, 255, 0.1);
}

#workspaces button:hover {
    box-shadow: inherit;
    background: rgba(255, 255, 255, 0.2);
}

#tray {
    padding: 4px 4px;
    margin: 8px 0;
}

#wireplumber, #network, #battery, #backlight, #clock {
    padding: 4px 4px;
    margin: 4px 0;
    color: #ffffff;
}

#wireplumber {
    color: #89b4fa;
}

#network {
    color: #94e2d5;
}

#network.disconnected {
    color: #f38ba8;
}

#battery {
    color: #a6e3a1;
}

#battery.warning {
    color: #f9e2af;
}

#battery.critical {
    color: #f38ba8;
}

#battery.charging {
    color: #94e2d5;
}

#backlight {
    color: #f9e2af;
}

#clock {
    color: #cba6f7;
    margin-bottom: 8px;
}

#custom-power {
    color: #f38ba8;
    padding: 8px 4px;
    margin: 8px 0;
}

#custom-cliphist {
    color: #fab387;
    padding: 4px 4px;
    margin: 4px 0;
}

#custom-kdeconnect {
    color: #89dceb;
    padding: 4px 4px;
    margin: 4px 0;
}

#power-profiles-daemon {
    padding: 4px 4px;
    margin: 4px 0;
    color: #cba6f7;
}

/* Tooltip styling */
tooltip {
    background: rgba(30, 30, 30, 0.95);
    border: 1px solid rgba(255, 255, 255, 0.1);
    border-radius: 8px;
    font-size: 16px;
}

tooltip label {
    color: #ffffff;
    padding: 12px;
}

/* Specifically target calendar tooltips for larger size */
#clock tooltip {
    font-size: 18px;
}

#clock tooltip label {
    padding: 16px;
    font-family: "RobotoMono Nerd Font", monospace;
}

/* For rotated text */
#wireplumber, #battery {
    min-width: 20px;
}

#clock {
    font-weight: bold;
    min-width: 20px;
    padding: 0 4px;
}'';

  };
}
