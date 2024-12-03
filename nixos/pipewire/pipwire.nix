{ config, lib, pkgs, ... }:

let 
  # Create a proper derivation for your impulse response files
  surroundImpulseFiles = pkgs.stdenv.mkDerivation {
    name = "surround-impulse-files";
    src = ./.; # Directory containing your .wav files
    installPhase = ''
      mkdir -p $out/share/surround
      cp atmos.wav $out/share/surround/
    '';
  };
in

{
  hardware.pulseaudio.enable = false;
  
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
    jack.enable = true;
    audio.enable = true;
    
    wireplumber = {
      enable = true;
      configPackages = [
        (pkgs.writeTextDir "share/wireplumber/main.lua.d/99-high-quality.lua" ''
          alsa_monitor.rules = {
            {
              matches = {{{ "node.name", "matches", "*_*put.*" }}};
              apply_properties = {
                ["audio.format"] = "F32LE",
                ["audio.rate"] = 96000,
                ["api.alsa.period-size"] = 1024,
                ["api.alsa.period-num"] = 4,
                ["api.alsa.headroom"] = 256,
                ["resample.quality"] = 10,
                ["resample.disable"] = false,
                ["channelmix.normalize"] = false,
                ["channelmix.mix-lfe"] = false,
                ["session.suspend-timeout-seconds"] = 0,
              },
            },
          }

          bluetooth_monitor.rules = {
            {
              matches = {{{ "node.name", "matches", "bluez_*" }}};
              apply_properties = {
                ["bluez5.autoswitch-profile"] = true,
                ["bluez5.codecs"] = "[ ldac aac aptx aptx_hd sbc_xq ]",
                ["bluez5.enable-sbc-xq"] = true,
                ["bluez5.enable-msbc"] = true,
                ["bluez5.enable-hw-volume"] = true,
                ["session.suspend-timeout-seconds"] = 0,
              },
            },
          }
        '')

(pkgs.writeTextDir "share/wireplumber/main.lua.d/51-smart-surround.lua" ''
          -- Utility function to detect audio format
          function detect_format(properties)
            local format = properties["audio.format"] or ""
            local channels = properties["audio.channels"] or 0
            local rate = properties["audio.rate"] or 0
            
            if channels >= 8 and string.find(format, "TrueHD") then
              return "atmos"
            else
              return "virtual"
            end
          end

          -- Define rules based on format
          virtual_surround = {
            matches = {{{ "node.name", "matches", "alsa_output.*" }}};
            apply_properties = {
              ["audio.position"] = "FL,FR,FC,LFE,SL,SR,RL,RR",  # 7.1 speaker layout
              ["audio.channels"] = 8,
              ["node.pause-on-idle"] = false,
              ["session.suspend-timeout-seconds"] = 0,
              ["filter.graph"] = {
                nodes = {
                  # Front channels with improved spatial positioning
                  {
                    type = "ladspa",
                    name = "virtual_surround_front",
                    plugin = "zita-convolver",
                    label = "zita_convolver",
                    config = {
                      filename = "${surroundImpulseFiles}/share/surround/atmos.wav",
                      channel = 0,
                      gain = 0.85,  # Slightly increased for better front presence
                      delay = 0,
                      partition = 16384,  # Increased for better low-frequency response
                      maxsize = 131072,   # Doubled for better reverb tail
                      offset = 0,         # Added offset control
                      length = 0,         # Auto-length
                      drywet = 0.8,       # Added dry/wet mix
                    },
                  },
                  # Rear channels with enhanced spatial decay
                  {
                    type = "ladspa",
                    name = "virtual_surround_rear",
                    plugin = "zita-convolver",
                    label = "zita_convolver",
                    config = {
                      filename = "${surroundImpulseFiles}/share/surround/atmos.wav",
                      channel = 1,
                      gain = 0.65,  # Adjusted for better distance perception
                      delay = 0.02,  # Slight delay for depth
                      partition = 16384,
                      maxsize = 131072,
                      offset = 0,
                      length = 0,
                      drywet = 0.75,
                    },
                  },
                  # Center and LFE with improved clarity
                  {
                    type = "ladspa",
                    name = "virtual_surround_center",
                    plugin = "zita-convolver",
                    label = "zita_convolver",
                    config = {
                      filename = "${surroundImpulseFiles}/share/surround/atmos.wav",
                      channel = 2,
                      gain = 0.75,  # Adjusted for dialog clarity
                      delay = 0,
                      partition = 16384,
                      maxsize = 131072,
                      offset = 0,
                      length = 0,
                      drywet = 0.9,  # Higher dry/wet for center channel
                    },
                  },
                  # New: Height channels for Atmos-like effect
                  {
                    type = "ladspa",
                    name = "virtual_surround_height",
                    plugin = "zita-convolver",
                    label = "zita_convolver",
                    config = {
                      filename = "${surroundImpulseFiles}/share/surround/atmos.wav",
                      channel = 3,
                      gain = 0.5,  # Subtle height effect
                      delay = 0.015,  # Slight delay for height perception
                      partition = 16384,
                      maxsize = 131072,
                      offset = 0,
                      length = 0,
                      drywet = 0.6,
                    },
                  },
                  # New: Additional processing for enhanced spaciousness
                  {
                    type = "ladspa",
                    name = "room_enhancement",
                    plugin = "matrix_spatialiser",
                    label = "matrixSpatialiser",
                    control = {
                      "Width" = 1.5,
                      "Depth" = 1.2,
                    },
                  },
                },
                links = {
                  # Front channels with height mixing
                  { "virtual_surround_front:Out-L", "room_enhancement:In-L" },
                  { "virtual_surround_front:Out-R", "room_enhancement:In-R" },
                  { "room_enhancement:Out-L", "output:playback_FL" },
                  { "room_enhancement:Out-R", "output:playback_FR" },
                  
                  # Rear channels with enhanced spatial mixing
                  { "virtual_surround_rear:Out-L", "output:playback_RL" },
                  { "virtual_surround_rear:Out-R", "output:playback_RR" },
                  
                  # Side channels with front/rear/height mix
                  { "virtual_surround_front:Out-L", "output:playback_SL" },
                  { "virtual_surround_rear:Out-L", "output:playback_SL" },
                  { "virtual_surround_height:Out-L", "output:playback_SL" },
                  { "virtual_surround_front:Out-R", "output:playback_SR" },
                  { "virtual_surround_rear:Out-R", "output:playback_SR" },
                  { "virtual_surround_height:Out-R", "output:playback_SR" },
                  
                  # Center and LFE with improved processing
                  { "virtual_surround_center:Out-L", "output:playback_FC" },
                  { "virtual_surround_center:Out-R", "output:playback_LFE" },
                  
                  # Height channel mixing for enhanced vertical space
                  { "virtual_surround_height:Out-L", "output:playback_FL" },
                  { "virtual_surround_height:Out-R", "output:playback_FR" },
                },
              },
            },
          }

          atmosRule = {
            matches = {{{ "node.name", "matches", "alsa_output.*" }}};
            apply_properties = {
              ["audio.position"] = "FL,FR,FC,LFE,SL,SR,RL,RR,TFL,TFR,TRL,TRR",  # Extended Atmos layout
              ["audio.channels"] = 12,  # Support for base 7.1 + 4 height channels
              ["node.pause-on-idle"] = false,
              ["session.suspend-timeout-seconds"] = 0,
              ["filter.graph"] = {
                nodes = {
                  # Main layer front processing
                  {
                    type = "ladspa",
                    name = "atmos_front",
                    plugin = "zita-convolver",
                    label = "zita_convolver",
                    config = {
                      filename = "${surroundImpulseFiles}/share/surround/atmos.wav",
                      channel = 0,
                      gain = 1.0,  # Full gain for main channels
                      delay = 0,
                      partition = 32768,  # Increased for better Atmos object handling
                      maxsize = 262144,   # Larger size for complex Atmos metadata
                      drywet = 1.0,       # Full processing for accurate positioning
                    },
                  },
                  # Height layer processing
                  {
                    type = "ladspa",
                    name = "atmos_height",
                    plugin = "zita-convolver",
                    label = "zita_convolver",
                    config = {
                      filename = "${surroundImpulseFiles}/share/surround/atmos.wav",
                      channel = 1,
                      gain = 0.8,  # Slightly reduced for natural height blend
                      delay = 0.01,  # Minimal delay for height perception
                      partition = 32768,
                      maxsize = 262144,
                      drywet = 0.9,
                    },
                  },
                  # LFE and effects processing
                  {
                    type = "ladspa",
                    name = "atmos_lfe",
                    plugin = "zita-convolver",
                    label = "zita_convolver",
                    config = {
                      filename = "${surroundImpulseFiles}/share/surround/atmos.wav",
                      channel = 2,
                      gain = 0.9,  # Controlled LFE for clean bass
                      delay = 0,
                      partition = 32768,
                      maxsize = 262144,
                      drywet = 1.0,
                    },
                  },
                  # Object-based audio renderer
                  {
                    type = "ladspa",
                    name = "object_renderer",
                    plugin = "matrix_spatialiser_plus",
                    label = "matrixSpatialiserPlus",
                    control = {
                      "Width" = 2.0,
                      "Depth" = 1.5,
                      "Height" = 1.2,
                      "Focus" = 0.8,
                    },
                  },
                },
                links = {
                  # Base layer connections
                  { "atmos_front:Out-L", "object_renderer:In-L" },
                  { "atmos_front:Out-R", "object_renderer:In-R" },
                  { "object_renderer:Out-L", "output:playback_FL" },
                  { "object_renderer:Out-R", "output:playback_FR" },
                  
                  # Height layer mappings
                  { "atmos_height:Out-L", "output:playback_TFL" },
                  { "atmos_height:Out-R", "output:playback_TFR" },
                  { "atmos_height:Out-L", "output:playback_TRL" },
                  { "atmos_height:Out-R", "output:playback_TRR" },
                  
                  # Surround layer with height blending
                  { "atmos_front:Out-L", "output:playback_SL" },
                  { "atmos_height:Out-L", "output:playback_SL" },
                  { "atmos_front:Out-R", "output:playback_SR" },
                  { "atmos_height:Out-R", "output:playback_SR" },
                  
                  # Rear channels with height influence
                  { "atmos_front:Out-L", "output:playback_RL" },
                  { "atmos_height:Out-L", "output:playback_RL" },
                  { "atmos_front:Out-R", "output:playback_RR" },
                  { "atmos_height:Out-R", "output:playback_RR" },
                  
                  # Center and LFE
                  { "atmos_front:Out-L", "output:playback_FC" },
                  { "atmos_lfe:Out-L", "output:playback_LFE" },
                },
              },
            },
          }

          -- Add format detection and rule selection
          function createSurroundRule(properties)
            local format = detect_format(properties)
            if format == "atmos" then
              return atmos_native
            else
              return virtual_surround
            end
          end

          -- Insert rules with priority
          table.insert(alsa_monitor.rules, createSurroundRule)
        '')
		
      ];
    };

    extraConfig.pipewire."92-high-quality" = {
      "context.properties" = {
        "default.clock.rate" = 96000;
        "default.clock.quantum" = 1024;
        "default.clock.min-quantum" = 1024;
        "default.clock.max-quantum" = 2048;
		"core.daemon" = true;
        "core.version" = 3;
        "mem.allow-mlock" = true;
        "support.dbus" = true;
      };
      "context.properties.rules" = [
        {
          matches = [{ "node.name" = "~.*"; }];
          actions = {
            update-props = {
              "clock.rate" = 96000;
              "clock.quantum" = 1024;
              "clock.min-quantum" = 1024;
              "clock.max-quantum" = 2048;
            };
          };
        }
      ];
      "context.modules" = [
        {
          name = "libpipewire-module-rt";
          args = {
            "nice.level" = -15;
            "rt.prio" = 88;
          };
        }
      ];
    };

    extraConfig.pipewire-pulse."92-high-quality" = {
      "pulse.properties" = {
        "pulse.default.format" = "F32LE";
        "pulse.default.rate" = "96000";
        "pulse.min.req" = "1024/96000";
        "pulse.default.req" = "1024/96000";
        "pulse.default.frag" = "1024/96000";
        "pulse.min.quantum" = "1024/96000";
        "pulse.quantum.limit" = "2048/96000";
		"pulse.idle.timeout" = 0;
        "pulse.min.latency" = "1024/96000";
      };
      "stream.properties" = {
        "resample.quality" = 10;
        "resample.disable" = false;
        "channelmix.normalize" = false;
        "channelmix.mix-lfe" = false;
      };
    };
  };

  security = {
    rtkit.enable = true;
    pam.loginLimits = [
      {
        domain = "@audio";
        item = "memlock";
        type = "-";
        value = "unlimited";
      }
      {
        domain = "@audio";
        item = "rtprio";
        type = "-";
        value = "99";
      }
    ];
  };

  environment.systemPackages = with pkgs; [
    alsa-utils
    easyeffects
    pavucontrol
	zita-convolver
	ladspa-sdk
	qpwgraph
  ];

}



# ########## Optimized TrueHD Atmos 7.1 Configuration ###########
# (pkgs.writeTextDir "share/wireplumber/main.lua.d/51-atmos-surround.lua" ''
#           atmosRule = {
#             matches = {{{ "node.name", "matches", "alsa_output.*" }}};
#             apply_properties = {
#               ["audio.position"] = "FL,FR,FC,LFE,SL,SR,RL,RR,TFL,TFR,TRL,TRR",  # Extended Atmos layout
#               ["audio.channels"] = 12,  # Support for base 7.1 + 4 height channels
#               ["node.pause-on-idle"] = false,
#               ["session.suspend-timeout-seconds"] = 0,
#               ["filter.graph"] = {
#                 nodes = {
#                   # Main layer front processing
#                   {
#                     type = "ladspa",
#                     name = "atmos_front",
#                     plugin = "zita-convolver",
#                     label = "zita_convolver",
#                     config = {
#                       filename = "${surroundImpulseFiles}/share/surround/atmos.wav",
#                       channel = 0,
#                       gain = 1.0,  # Full gain for main channels
#                       delay = 0,
#                       partition = 32768,  # Increased for better Atmos object handling
#                       maxsize = 262144,   # Larger size for complex Atmos metadata
#                       drywet = 1.0,       # Full processing for accurate positioning
#                     },
#                   },
#                   # Height layer processing
#                   {
#                     type = "ladspa",
#                     name = "atmos_height",
#                     plugin = "zita-convolver",
#                     label = "zita_convolver",
#                     config = {
#                       filename = "${surroundImpulseFiles}/share/surround/atmos.wav",
#                       channel = 1,
#                       gain = 0.8,  # Slightly reduced for natural height blend
#                       delay = 0.01,  # Minimal delay for height perception
#                       partition = 32768,
#                       maxsize = 262144,
#                       drywet = 0.9,
#                     },
#                   },
#                   # LFE and effects processing
#                   {
#                     type = "ladspa",
#                     name = "atmos_lfe",
#                     plugin = "zita-convolver",
#                     label = "zita_convolver",
#                     config = {
#                       filename = "${surroundImpulseFiles}/share/surround/atmos.wav",
#                       channel = 2,
#                       gain = 0.9,  # Controlled LFE for clean bass
#                       delay = 0,
#                       partition = 32768,
#                       maxsize = 262144,
#                       drywet = 1.0,
#                     },
#                   },
#                   # Object-based audio renderer
#                   {
#                     type = "ladspa",
#                     name = "object_renderer",
#                     plugin = "matrix_spatialiser_plus",
#                     label = "matrixSpatialiserPlus",
#                     control = {
#                       "Width" = 2.0,
#                       "Depth" = 1.5,
#                       "Height" = 1.2,
#                       "Focus" = 0.8,
#                     },
#                   },
#                 },
#                 links = {
#                   # Base layer connections
#                   { "atmos_front:Out-L", "object_renderer:In-L" },
#                   { "atmos_front:Out-R", "object_renderer:In-R" },
#                   { "object_renderer:Out-L", "output:playback_FL" },
#                   { "object_renderer:Out-R", "output:playback_FR" },
                  
#                   # Height layer mappings
#                   { "atmos_height:Out-L", "output:playback_TFL" },
#                   { "atmos_height:Out-R", "output:playback_TFR" },
#                   { "atmos_height:Out-L", "output:playback_TRL" },
#                   { "atmos_height:Out-R", "output:playback_TRR" },
                  
#                   # Surround layer with height blending
#                   { "atmos_front:Out-L", "output:playback_SL" },
#                   { "atmos_height:Out-L", "output:playback_SL" },
#                   { "atmos_front:Out-R", "output:playback_SR" },
#                   { "atmos_height:Out-R", "output:playback_SR" },
                  
#                   # Rear channels with height influence
#                   { "atmos_front:Out-L", "output:playback_RL" },
#                   { "atmos_height:Out-L", "output:playback_RL" },
#                   { "atmos_front:Out-R", "output:playback_RR" },
#                   { "atmos_height:Out-R", "output:playback_RR" },
                  
#                   # Center and LFE
#                   { "atmos_front:Out-L", "output:playback_FC" },
#                   { "atmos_lfe:Out-L", "output:playback_LFE" },
#                 },
#               },
#             },
#           }

#           table.insert(alsa_monitor.rules, atmosRule)
#         '')
