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
		modules-right = [ "tray" "wireplumber" "network" "power-profiles-daemon" "battery" "backlight" "clock" "custom/power" ];

		
		
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
			"10" = "𑙐";
          };
		};
		
		tray = {
          icon-size = 16;
          spacing = 8;
        };

		wireplumber =  {
		  rotate = 270;
          format = "{icon}  {volume}%";
          format-muted = " ";
          on-click = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
          max-volume = 120;
          scroll-step = 1;
          format-icons = ["" "" " "];
        };

		"network" = {
          format = "";
          format-ethernet = "󰈀";
          format-wifi = "󰖩";
          format-disconnected = "󰖪";
          tooltip-format = "{ifname} via {gwaddr}";
          tooltip-format-wifi = "connected to {essid}";
          tooltip-format-ethernet = "{ifname}";
          tooltip-format-disconnected = "Disconnected";
		  on-click = "nm-connection-editor";
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
		  on-scroll-up = "brightnessctl s 1%+";
          on-scroll-down = "brightnessctl s 1%";
		  # on-scroll-up = "${pkgs.brightnessctl}/bin/brightnessctl set 1%+ &> /dev/null";  
          # on-scroll-down = "${pkgs.brightnessctl}/bin/brightnessctl set 1%- &> /dev/null";
		  smooth-scrolling-threshold = 1;
		};

		"clock" = {
		  format = "{:%H\n%M}";
		  tooltip-format = "<tt><small>{calendar}</small></tt>";
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

		"custom/power" = {
		  format = "󰤆";
		  on-click = "wlogout";
		  tooltip = false;
		};
		
	  };
    };


	style =
	  ''* {
    border: none;
    border-radius: 0;
    font-family: "RobotMono Nerd Font";
    font-size: 14px;
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
}

tooltip label {
    color: #ffffff;
    padding: 8px;
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
