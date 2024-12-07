{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:
let
  inherit (inputs.niri.lib.kdl) node plain leaf flag;
in 
  {

	nixpkgs.overlays = [ inputs.niri.overlays.niri ];
	programs.niri.enable = true;
	programs.niri.package = pkgs.niri-unstable;
	programs.niri.config = [
      (plain "input" [
		(plain "keyboard" [
          (plain "xkb" [
			# For more information, see xkeyboard-config(7).
			(leaf "layout" "us")
			# in,in(marathi)
			(leaf "options" "ctrl:nocaps,keypad:pointerkeys")
			# numpad:pc for numlock
			# Layout of numeric keypad - keypad:legacy
          ])

          (leaf "repeat-delay" 500)
          (leaf "repeat-rate" 25)

          # - "global" - layout change is global for all windows.
          # - "window" - layout is tracked for each window individually.
          # (leaf "track-layout" "global")
		])

		(plain "touchpad" [
          (flag "tap")
          # (flag "dwt")
          # (flag "dwtp")
          # (flag "natural-scroll")
          # (leaf "accel-speed" 0.2)
          # (leaf "accel-profile" "flat")
          (leaf "tap-button-map" "left-middle-right")
		  (leaf "click-method" "clickfinger")
		  (leaf "scroll-method" "two-finger")
		])

		(plain "mouse" [
          # (flag "natural-scroll")
          # (leaf "accel-speed" 0.2)
          # (leaf "accel-profile" "flat")
		])

		(plain "trackpoint" [
          # (flag "natural-scroll")
          # (leaf "accel-speed" 0.2)
          # (leaf "accel-profile" "flat")
		])

		(plain "tablet" [
          # Set the name of the output (see below) which the tablet will map to.
          # If this is unset or the output doesn't exist, the tablet maps to one of the
          # existing outputs.
          # (leaf "map-to-output" "eDP-1")
		])

		(plain "touch" [
          # Set the name of the output (see below) which touch input will map to.
          # If this is unset or the output doesn't exist, touch input maps to one of the
          # existing outputs.
          # (leaf "map-to-output" "eDP-1")
		])

		# By default, niri will take over the power button to make it sleep
		# instead of power off.
		# Uncomment this if you would like to configure the power button elsewhere
		# (i.e. logind.conf).
		# (flag "disable-power-key-handling")
      ])

      # by running `niri msg outputs` while inside a niri instance.
      (node "output" "eDP-1" [
		
		# Scale is a floating-point number, but at the moment only integer values work.
		(leaf "scale" 1.0)

		# normal, 90, 180, 270, flipped, flipped-90, flipped-180 and flipped-270.
		(leaf "transform" "normal")

		(leaf "mode" "1920x1080@60.030")

		#setting for multiple screeens
		(leaf "position" { x=1920; y=0; })
      ])

      (plain "layout" [
		
		(plain "border" [
		  #(flag "off")
		  (leaf "width" 2)
          
          (leaf "active-gradient" { from="#89FC04"; to="#AFFC41"; angle=45; })
		  #(leaf "active-gradient" { from="#93A5CF"; to="#E4EfE9"; angle=45; })
		  (leaf "inactive-gradient" { from="#505050"; to="#808080"; angle=45; relative-to="workspace-view"; })
		])

		(plain "focus-ring" [
          (flag "off")
		])

		(plain "preset-column-widths" [
          (leaf "proportion" (1.0 / 3.0))
          (leaf "proportion" (1.0 / 2.0))
          (leaf "proportion" (3.0 / 4.0))

          # Fixed sets the width in logical pixels exactly.
          # (leaf "fixed" 1920)
		])

		(plain "default-column-width" [
          (leaf "proportion" 0.95)
		])

		(leaf "gaps" 2)

		(plain "struts" [
          (leaf "left" 2)
          (leaf "right" 32)
          (leaf "top" 2)
          (leaf "bottom" 2)
		])

		# (plain "insert-hint" [
		#   (leaf "color" "#DD2476")
		# ])

		(leaf "center-focused-column" "on-overflow") # other options "never" "alway"
      ])

	  # TODO
      # Add lines like this to spawn processes at startup.
      # Note that running niri as a session supports xdg-desktop-autostart,
      # which may be more convenient to use.
      (leaf "spawn-at-startup" [ "foot" "-e" "fish" ])
	  #(leaf "spawn-at-startup" [ "waybar" ])
	  (leaf "spawn-at-startup" [ "eww" "open" "bar" ])
	  #(leaf "spawn-at-startup" [ "swayidle" ])
	  (leaf "spawn-at-startup" [ "syncthingtry"])
	  (leaf "spawn-at-startup" [ "emacsclient" "-c" ])
      #(leaf "spawn-at-startup" [ "kdeconnect"])

      # You can override environment variables for processes spawned by niri.
      (plain "environment" [
		# Set a variable like this:
		# (leaf "QT_QPA_PLATFORM" "wayland")

		# Remove a variable by using null as the value:
		# (leaf "DISPLAY" null)
      ])

      (plain "cursor" [
		# already set with help of stylix
      ])

	  (flag "prefer-no-csd")

	  (leaf "screenshot-path" "~/Pictures/Screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png")

      (plain "hotkey-overlay" [
		(flag "skip-at-startup")
      ])

      # Animation settings.
      (plain "animations" [
		
		(leaf "slowdown" 1.0)

		(plain "workspace-switch" [
          (leaf "spring" { damping-ratio=1.0; stiffness=1000; epsilon=0.0001; })
		])

		(plain "horizontal-view-movement" [
          (leaf "spring" { damping-ratio=1.0; stiffness=800; epsilon=0.0001; })
		])

		(plain "window-open" [
          (leaf "duration-ms" 150)
          (leaf "curve" "ease-out-expo")
		])

		(plain "window-close" [
          (leaf "duration-ms" 150)
          (leaf "curve" "ease-out-quad")
		])
		
		(plain "window-movement" [
          (leaf "spring" {damping-ratio=1.0; stiffness=800; epsilon=0.0001; })
		])
			
		(plain "window-resize" [
          (leaf "spring" {damping-ratio=1.0; stiffness=800; epsilon=0.0001; })
		])

		(plain "config-notification-open-close" [
          # (flag "off")
          (leaf "spring" { damping-ratio=0.6; stiffness=1000; epsilon=0.001; })
		])

		(plain "screenshot-ui-open" [
          (leaf "duration-ms" 150)
          (leaf "curve" "ease-out-quad")
		])
      ])

	  (plain "window-rule" [
		(leaf "geometry-corner-radius" 3)
		(leaf "clip-to-geometry" true)
		#(leaf "opacity" 0.90)
      ])

########### key bindings
      (plain "binds" [
		(plain "Mod+Shift+Slash" [(flag "show-hotkey-overlay")])

		# Suggested binds for running programs: terminal, app launcher, screen locker.
		(plain "Mod+T" [(leaf "spawn" ["foot"])])
		(plain "Mod+D" [(leaf "spawn" ["fuzzel"])])
		(plain "Mod+Space" [(leaf "spawn" "fuzzel")])
		(plain "Super+Alt+L" [(leaf "spawn" ["swaylock"])])

		# You can also use a shell:
		# (plain "Mod+T" [(leaf "spawn" [ "bash" "-c" "notify-send hello && exec alacritty" ])])
		(plain "Mod+v" [(leaf "spawn" ["clapboard pick"])])

		# Example volume keys mappings for PipeWire & WirePlumber.
		(plain "XF86AudioRaiseVolume" [(leaf "spawn" ["wpctl" "set-volume" "-l" "1.5" "@DEFAULT_AUDIO_SINK@" "5%+"])])
		(plain "XF86AudioLowerVolume" [(leaf "spawn" ["wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "5%-"])])
		# (plain "XF86MonBrightnessUp" [(leaf "spawn" ["brightnessctl" "-d" "amdgpu_bl2" "s" "+5%"])])
		# (plain "XF86MonBrightnessDown" [(leaf "spwan" ["brightnessctl" "-d" "amdgpu_bl2" "s" "5%-"])])

		(plain "Mod+Q" [(flag "close-window")])

		(plain "Mod+Left"   [(flag "focus-column-left")])
		#(plain "Mod+Down"   [(flag "focus-window-down")]) # not recomended if you use multiple screen
		#(plain "Mod+Up"     [(flag "focus-window-up")])   # same as above
		(plain "Mod+Right"  [(flag "focus-column-right")])
		(plain "Mod+H"      [(flag "focus-column-left")])
		(plain "Mod+J"      [(flag "focus-window-down")])
		(plain "Mod+K"      [(flag "focus-window-up")])
		(plain "Mod+L"      [(flag "focus-column-right")])

		(plain "Mod+Ctrl+Left"  [(flag "move-column-left")])
		(plain "Mod+Ctrl+Down"  [(flag "move-window-down")])
		(plain "Mod+Ctrl+Up"    [(flag "move-window-up")])
		(plain "Mod+Ctrl+Right" [(flag "move-column-right")])
		(plain "Mod+Ctrl+H"     [(flag "move-column-left")])
		(plain "Mod+Ctrl+J"     [(flag "move-window-down")])
		(plain "Mod+Ctrl+K"     [(flag "move-window-up")])
		(plain "Mod+Ctrl+L"     [(flag "move-column-right")])

		# Alternative commands that move across workspaces when reaching
		# the first or last window in a column.
		# (plain "Mod+J"      [(flag "focus-window-or-workspace-down")])
		# (plain "Mod+K"      [(flag "focus-window-or-workspace-up")])
		# (plain "Mod+Ctrl+J" [(flag "move-window-down-or-to-workspace-down")])
		# (plain "Mod+Ctrl+K" [(flag "move-window-up-or-to-workspace-up")])

		(plain "Mod+Home"       [(flag "focus-column-first")])
		(plain "Mod+End"        [(flag "focus-column-last")])
		(plain "Mod+Ctrl+Home"  [(flag "move-column-to-first")])
		(plain "Mod+Ctrl+End"   [(flag "move-column-to-last")])

		(plain "Mod+Shift+Left"   [(flag "focus-monitor-left")])
		(plain "Mod+Shift+Down"   [(flag "focus-monitor-down")])
		(plain "Mod+Shift+Up"     [(flag "focus-monitor-up")])
		(plain "Mod+Shift+Right"  [(flag "focus-monitor-right")])
		(plain "Mod+Shift+H"      [(flag "focus-monitor-left")])
		(plain "Mod+Shift+J"      [(flag "focus-monitor-down")])
		(plain "Mod+Shift+K"      [(flag "focus-monitor-up")])
		(plain "Mod+Shift+L"      [(flag "focus-monitor-right")])

		(plain "Mod+Shift+Ctrl+Left"  [(flag "move-column-to-monitor-left")])
		(plain "Mod+Shift+Ctrl+Down"  [(flag "move-column-to-monitor-down")])
		(plain "Mod+Shift+Ctrl+Up"    [(flag "move-column-to-monitor-up")])
		(plain "Mod+Shift+Ctrl+Right" [(flag "move-column-to-monitor-right")])
		(plain "Mod+Shift+Ctrl+H"     [(flag "move-column-to-monitor-left")])
		(plain "Mod+Shift+Ctrl+J"     [(flag "move-column-to-monitor-down")])
		(plain "Mod+Shift+Ctrl+K"     [(flag "move-column-to-monitor-up")])
		(plain "Mod+Shift+Ctrl+L"     [(flag "move-column-to-monitor-right")])

		# Alternatively, there are commands to move just a single window:
		# (plain "Mod+Shift+Ctrl+Left" [(flag "move-window-to-monitor-left")])
		# ...

		# And you can also move a whole workspace to another monitor:
		# (plain "Mod+Shift+Ctrl+Left" [(flag "move-workspace-to-monitor-left")])
		# ...

		(plain "Mod+Down"           [(flag "focus-workspace-down")]) # "mod+Page_down" is orignal key, changed for ease
		(plain "Mod+Up"             [(flag "focus-workspace-up")])   # sames as above, not recomended for multiple screens
		(plain "Mod+U"              [(flag "focus-workspace-down")])
		(plain "Mod+I"              [(flag "focus-workspace-up")])
		(plain "Mod+Ctrl+Page_Down" [(flag "move-column-to-workspace-down")])
		(plain "Mod+Ctrl+Page_Up"   [(flag "move-column-to-workspace-up")])
		(plain "Mod+Ctrl+U"         [(flag "move-column-to-workspace-down")])
		(plain "Mod+Ctrl+I"         [(flag "move-column-to-workspace-up")])

		# Alternatively, there are commands to move just a single window:
		# (plain "Mod+Ctrl+Page_Down" [(flag "move-window-to-workspace-down")])
		# ...

		(plain "Mod+Shift+Page_Down"  [(flag "move-workspace-down")])
		(plain "Mod+Shift+Page_Up"    [(flag "move-workspace-up")])
		(plain "Mod+Shift+U"          [(flag "move-workspace-down")])
		(plain "Mod+Shift+I"          [(flag "move-workspace-up")])

		(plain "Mod+1" [(leaf "focus-workspace" 1)])
		(plain "Mod+2" [(leaf "focus-workspace" 2)])
		(plain "Mod+3" [(leaf "focus-workspace" 3)])
		(plain "Mod+4" [(leaf "focus-workspace" 4)])
		(plain "Mod+5" [(leaf "focus-workspace" 5)])
		(plain "Mod+6" [(leaf "focus-workspace" 6)])
		(plain "Mod+7" [(leaf "focus-workspace" 7)])
		(plain "Mod+8" [(leaf "focus-workspace" 8)])
		(plain "Mod+9" [(leaf "focus-workspace" 9)])
		(plain "Mod+Ctrl+1" [(leaf "move-column-to-workspace" 1)])
		(plain "Mod+Ctrl+2" [(leaf "move-column-to-workspace" 2)])
		(plain "Mod+Ctrl+3" [(leaf "move-column-to-workspace" 3)])
		(plain "Mod+Ctrl+4" [(leaf "move-column-to-workspace" 4)])
		(plain "Mod+Ctrl+5" [(leaf "move-column-to-workspace" 5)])
		(plain "Mod+Ctrl+6" [(leaf "move-column-to-workspace" 6)])
		(plain "Mod+Ctrl+7" [(leaf "move-column-to-workspace" 7)])
		(plain "Mod+Ctrl+8" [(leaf "move-column-to-workspace" 8)])
		(plain "Mod+Ctrl+9" [(leaf "move-column-to-workspace" 9)])

		# Alternatively, there are commands to move just a single window:
		# (plain "Mod+Ctrl+1" [(leaf "move-window-to-workspace" 1)])

		(plain "Mod+Comma"  [(flag "consume-window-into-column")])
		(plain "Mod+Period" [(flag "expel-window-from-column")])

		# There are also commands that consume or expel a single window to the side.
		# (plain "Mod+BracketLeft"  [(flag "consume-or-expel-window-left")])
		# (plain "Mod+BracketRight" [(flag "consume-or-expel-window-right")])

		(plain "Mod+R" [(flag "switch-preset-column-width")])
		(plain "Mod+F" [(flag "maximize-column")])
		(plain "Mod+Shift+F" [(flag "fullscreen-window")])
		(plain "Mod+C" [(flag "center-column")])

		(plain "Mod+Minus" [(leaf "set-column-width" "-5%")])
		(plain "Mod+Equal" [(leaf "set-column-width" "+5%")])

		# Finer height adjustments when in column with other windows.
		(plain "Mod+Shift+Minus" [(leaf "set-window-height" "-10%")])
		(plain "Mod+Shift+Equal" [(leaf "set-window-height" "+10%")])

		# Actions to switch layouts.
		# Note: if you uncomment these, make sure you do NOT have
		# a matching layout switch hotkey configured in xkb options above.
		# Having both at once on the same hotkey will break the switching,
		# since it will switch twice upon pressing the hotkey (once by xkb, once by niri).
		# (plain "Mod+Space"       [(leaf "switch-layout" "next")])
		# (plain "Mod+Shift+Space" [(leaf "switch-layout" "prev")])

		(plain "Print" [(flag "screenshot")])
		(plain "Ctrl+Print" [(flag "screenshot-screen")])
		(plain "Alt+Print" [(flag "screenshot-window")])

		(plain "Mod+Shift+E" [(flag "quit")])
        (plain "Mod+Shift+P" [(flag "power-off-monitors")])

		# This debug bind will tint all surfaces green, unless they are being
		# directly scanned out. It's therefore useful to check if direct scanout
		# is working.
		# (plain "Mod+Shift+Ctrl+T" [(flag "toggle-debug-tint")])
      ])

      (plain "debug" [
      ])
	  
	];
  }
