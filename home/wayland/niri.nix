{ config, pkgs, inputs, lib, ... }:
let
  makeCommand = command: {
    command = [command];
    };
in

{
  nixpkgs.overlays = [ inputs.niri.overlays.niri ];
  programs.niri = {
    enable = true;
    package = pkgs.niri-unstable;
    settings = {
      input = {

        keyboard = {
          numlock = true;
          xkb = {
            # For more information, see xkeyboard-config(7).
            layout = "us";
            # in,in(marathi)
            
            options = "ctrl:nocaps,keypad:pointerkeys";
          };
          repeat-delay = 500;
          repeat-rate = 25;
          # track-layout = "global";
          # - "global" - layout change is global for all windows.
          # - "window" - layout is tracked for each window individually.
        };
        
        touchpad = {
          tap = true;
          # dwt = true;
          # dwtp = true;
          natural-scroll = false;
          # accel-speed = 0.2;
          # accel-profile = "flat";
          tap-button-map = "left-right-middle";
          click-method = "clickfinger";
          scroll-method = "two-finger";
          drag = true;
          drag-lock = true;
        };
        
        mouse = {
          # natural-scroll = true;
          # accel-speed = 0.2;
          # accel-profile = "flat";
        };
        
        trackpoint = {
          # natural-scroll = true;
          # accel-speed = 0.2;
          # accel-profile = "flat";
        };
        
        tablet = {
          # map-to-output = "eDP-1";
        };
        
        touch = {
          # map-to-output = "eDP-1";
        };
        
        # By default, niri will take over the power button to make it sleep
        # instead of power off.
        # Uncomment this if you would like to configure the power button elsewhere
        # (i.e. logind.conf).
        # disable-power-key-handling = true;
      };
      
      outputs."eDP-1" = {
        # Scale is a floating-point number, but at the moment only integer values work.
        scale = 1.0;
        # normal, 90, 180, 270, flipped, flipped-90, flipped-180 and flipped-270.
        #transform = "normal";
        mode = {
          width = 1920;
          height = 1080;
          refresh = 60.030;
        };

        #setting for multiple screeens
        position = { x = 1920; y = 0; };
      };

      overview = {
        zoom = 0.40;
        workspace-shadow.enable = false;
        backdrop-color = "transparent";
      };
      
      layout = {
        focus-ring.enable = false;
        border = {
          enable = true;
          width = 2;
          active = {
            color = "#E67E80";
          };
          # active-gradient = { from = "#93A5CF"; to = "#E4EfE9"; angle = 45; };
          inactive = {
            color = "#7FBBB3";
          };
        };

        preset-column-widths = [
          { proportion = 1.0 / 3.0; }
          { proportion = 1.0 / 2.0; }
          { proportion = 3.0 / 4.0; }
          { proportion = 1.0; }
          # Fixed sets the width in logical pixels exactly.
          # { fixed = 1920; }
        ];
        
        default-column-width = {
          proportion = 1.0;
        };
        
        gaps = 2;
        
        struts = {
          left = 20;
          right = 20;
          top = 1;
          bottom = 1;
        };
        
        # insert-hint = {
        #   color = "#DD2476";
        # };
        
        center-focused-column = "always"; # other options "never" "always" "on-overflow"
        default-column-display = "tabbed";


        tab-indicator = {
          hide-when-single-tab = true;
          place-within-column = true;
          gap = -5;
          width = 3;
          #length total-proportion=1.0;
          position = "right";
          gaps-between-tabs = 2;
          corner-radius = 3;
          #active-color = "red";
          #inactive-color = "gray";
          # active-gradient from="#80c8ff" to="#bbddff" angle=45
          # inactive-gradient from="#505050" to="#808080" angle=45 relative-to="workspace-view"
        };
      };
      
      # TODO
      # Add lines like this to spawn processes at startup.
      # Note that running niri as a session supports xdg-desktop-autostart,
      # which may be more convenient to use.
      
      spawn-at-startup = [
        (makeCommand "waybar")
        (makeCommand "kdeconnect")
        {command = ["foot" "-e" "fish"];}
        #{command = ["eww" "open" "bar"];}
        {command = ["emacsclient" "-c"];}
        {command = ["wl-paste" "--watch" "cliphist" "store"];}
        {command = ["wl-paste" "--type text" "--watch" "cliphist" "store"];}
      ];

      xwayland-satellite.enable = true;
      #xwayland-satellite.path = "${lib.getExe pkgs.xwayland-satellite-unstable}";
      
      # You can override environment variables for processes spawnend by niri.
      environment = {
        DISPLAY = ":0";
        # Set a variable like this:
        # QT_QPA_PLATFORM = "wayland";
        
        # Remove a variable by using null as the value:
        # DISPLAY = null;
      };
      
      # cursor = {
      #   # already set with help of stylix
      # };
      
      prefer-no-csd = true;
      
      screenshot-path = "~/Pictures/Screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png";
      
      hotkey-overlay = {
        skip-at-startup = true;
      };
      
      # Animation settings.
      animations = {
        enable = true;
        slowdown = 1.0;
        
        workspace-switch.kind = {
          spring = { damping-ratio = 1.0; stiffness = 1000; epsilon = 0.0001; };
        };
        
        horizontal-view-movement.kind = {
          spring = { damping-ratio = 1.0; stiffness = 800; epsilon = 0.0001; };
        };
        
        window-open.kind = {
          easing = {
            curve = "ease-out-expo";
            duration-ms = 150;
          };
        };
        
        window-close.kind = {
          easing = {
            curve = "ease-out-quad";
            duration-ms = 150;
          };
        };
        
        window-movement.kind = {
          spring = {
            damping-ratio = 1.000000;
            epsilon = 0.000100;
            stiffness = 800;
          };
        };
        
        window-resize.kind = {
          spring = {
            damping-ratio = 1.000000;
            epsilon = 0.000100;
            stiffness = 800;
          };
        };
        
        config-notification-open-close.kind = {
          spring = {
            damping-ratio = 0.600000;
            epsilon = 0.001000;
            stiffness = 1000;
          };
        };
        
        screenshot-ui-open.kind = {
          easing = {
            curve = "ease-out-quad";
            duration-ms = 200;
          };
        }; 
      };

      window-rules = [
        {
          geometry-corner-radius = let r = 3.0;
                                   in {
                                     top-left = r;
                                     top-right = r;
                                     bottom-left = r;
                                     bottom-right = r;
                                   };
          clip-to-geometry = true;
        }
      ];

      ########### key bindings
      binds = with config.lib.niri.actions; {
        # Hotkey overlay
        "Mod+Shift+Slash".action = show-hotkey-overlay;
        
        # Program launchers
        "Mod+T".action = { spawn = ["foot"]; };
        "Mod+D".action = { spawn = ["fuzzel"]; };
        "Mod+Space".action = { spawn = "fuzzel"; };
        "Super+Alt+L".action = { spawn = ["swaylock"]; };
        
        # Volume controls
        "XF86AudioRaiseVolume".action = { spawn = ["wpctl" "set-volume" "-l" "1.5" "@DEFAULT_AUDIO_SINK@" "5%+"]; };
        "XF86AudioLowerVolume".action = { spawn = ["wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "5%-"]; };
        "XF86MonBrightnessUp".action = { spawn = ["brightnessctl" "-d" "amdgpu_bl2" "s" "+5%"]; };
        "XF86MonBrightnessDown".action = { spawn = ["brightnessctl" "-d" "amdgpu_bl2" "s" "5%-"]; };
        
        # Window management
        "Mod+Q".action = close-window;
        "Mod+W".action = toggle-column-tabbed-display;
        
        # Focus movement
        "Mod+Left".action = focus-column-left;
        # "Mod+Down".action = focus-window-down; # not recommended if you use multiple screens
        # "Mod+Up".action = focus-window-up; # same as above
        "Mod+Right".action = focus-column-right;
        "Mod+H".action = focus-column-left;
        "Mod+J".action = focus-window-down;
        "Mod+K".action = focus-window-up;
        "Mod+L".action = focus-column-right;
        
        # Window movement
        "Mod+Ctrl+Left".action = move-column-left;
        "Mod+Ctrl+Down".action = move-window-down;
        "Mod+Ctrl+Up".action = move-window-up;
        "Mod+Ctrl+Right".action = move-column-right;
        "Mod+Ctrl+H".action = move-column-left;
        "Mod+Ctrl+J".action = move-window-down;
        "Mod+Ctrl+K".action = move-window-up;
        "Mod+Ctrl+L".action = move-column-right;
        
        # Column navigation
        "Mod+Home".action = focus-column-first;
        "Mod+End".action = focus-column-last;
        "Mod+Ctrl+Home".action = move-column-to-first;
        "Mod+Ctrl+End".action = move-column-to-last;
        
        # Monitor focus
        "Mod+Shift+Left".action = focus-monitor-left;
        "Mod+Shift+Down".action = focus-monitor-down;
        "Mod+Shift+Up".action = focus-monitor-up;
        "Mod+Shift+Right".action = focus-monitor-right;
        "Mod+Shift+H".action = focus-monitor-left;
        "Mod+Shift+J".action = focus-monitor-down;
        "Mod+Shift+K".action = focus-monitor-up;
        "Mod+Shift+L".action = focus-monitor-right;
        
        # Move to monitor
        "Mod+Shift+Ctrl+Left".action = move-column-to-monitor-left;
        "Mod+Shift+Ctrl+Down".action = move-column-to-monitor-down;
        "Mod+Shift+Ctrl+Up".action = move-column-to-monitor-up;
        "Mod+Shift+Ctrl+Right".action = move-column-to-monitor-right;
        "Mod+Shift+Ctrl+H".action = move-column-to-monitor-left;
        "Mod+Shift+Ctrl+J".action = move-column-to-monitor-down;
        "Mod+Shift+Ctrl+K".action = move-column-to-monitor-up;
        "Mod+Shift+Ctrl+L".action = move-column-to-monitor-right;
        
        # Workspace navigation
        "Mod+Down".action = focus-workspace-down;
        "Mod+Up".action = focus-workspace-up;
        "Mod+U".action = focus-workspace-down;
        "Mod+I".action = focus-workspace-up;
        "Mod+Ctrl+Page_Down".action = move-column-to-workspace-down;
        "Mod+Ctrl+Page_Up".action = move-column-to-workspace-up;
        "Mod+Ctrl+U".action = move-column-to-workspace-down;
        "Mod+Ctrl+I".action = move-column-to-workspace-up;
        
        # Workspace movement
        "Mod+Shift+Page_Down".action = move-workspace-down;
        "Mod+Shift+Page_Up".action = move-workspace-up;
        "Mod+Shift+U".action = move-workspace-down;
        "Mod+Shift+I".action = move-workspace-up;
        
        # Workspace direct access
        "Mod+1".action = { focus-workspace = 1; };
        "Mod+2".action = { focus-workspace = 2; };
        "Mod+3".action = { focus-workspace = 3; };
        "Mod+4".action = { focus-workspace = 4; };
        "Mod+5".action = { focus-workspace = 5; };
        "Mod+6".action = { focus-workspace = 6; };
        "Mod+7".action = { focus-workspace = 7; };
        "Mod+8".action = { focus-workspace = 8; };
        "Mod+9".action = { focus-workspace = 9; };
        "Mod+Ctrl+1".action = { move-column-to-workspace = 1; };
        "Mod+Ctrl+2".action = { move-column-to-workspace = 2; };
        "Mod+Ctrl+3".action = { move-column-to-workspace = 3; };
        "Mod+Ctrl+4".action = { move-column-to-workspace = 4; };
        "Mod+Ctrl+5".action = { move-column-to-workspace = 5; };
        "Mod+Ctrl+6".action = { move-column-to-workspace = 6; };
        "Mod+Ctrl+7".action = { move-column-to-workspace = 7; };
        "Mod+Ctrl+8".action = { move-column-to-workspace = 8; };
        "Mod+Ctrl+9".action = { move-column-to-workspace = 9; };
        
        # Column operations
        "Mod+Comma".action = consume-window-into-column;
        "Mod+Period".action = expel-window-from-column;
        
        # Column sizing
        "Mod+R".action = switch-preset-column-width;
        "Mod+F".action = maximize-column;
        "Mod+Shift+F".action = fullscreen-window;
        "Mod+C".action = center-column;
        
        "Mod+Minus".action = { set-column-width = "-5%"; };
        "Mod+Equal".action = { set-column-width = "+5%"; };
        
        # Window height adjustments
        "Mod+Shift+Minus".action = { set-window-height = "-10%"; };
        "Mod+Shift+Equal".action = { set-window-height = "+10%"; };
        
        # Screenshot
        "Print".action = screenshot;
        #"Ctrl+Print".action = screenshot-screen;
        "Alt+Print".action = screenshot-window;
        
        # System controls
        "Mod+Shift+E".action = quit;
        "Mod+Shift+P".action = power-off-monitors;
      };

      debug = {};
    };
  };
}
