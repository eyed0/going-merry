# 3 config 1st high qylity audio with 32bit float, 2nd high quality with flaot 32bit int, 3rd default
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
  # Existing PipeWire configuration
  hardware.pulseaudio.enable = false;
  
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
    jack.enable = true;
    # Add Bluetooth support
    audio.enable = true;
    
    # WirePlumber configuration for highest quality
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

		# Add convolver configuration for virtual surround
        (pkgs.writeTextDir "share/wireplumber/main.lua.d/51-virtual-surround.lua" ''
        surroundRule = {
          matches = {{{ "node.name", "matches", "alsa_output.*" }}};
          apply_properties = {
            ["audio.position"] = "FL,FR,FC,LFE,SL,SR,RL,RR",  -- 7.1 speaker layout
            ["audio.channels"] = 8,
            ["node.pause-on-idle"] = false,  -- Prevent processing interruption
            ["session.suspend-timeout-seconds"] = 0,
            ["filter.graph"] = {
              nodes = {
                {
                  type = "ladspa",
                  name = "virtual_surround_front",
                  plugin = "zita-convolver",
                  label = "zita_convolver",
                  config = {
                    filename = "${surroundImpulseFiles}/share/surround/atmos.wav",
                    channel = 0,  -- Front channels
                    gain = 0.8,   -- Slightly reduced to prevent clipping
                    delay = 0,
                    partition = 8192,  -- Larger partition size for better performance
                    maxsize = 65536,
                  },
                },
                {
                  type = "ladspa",
                  name = "virtual_surround_rear",
                  plugin = "zita-convolver",
                  label = "zita_convolver",
                  config = {
                    filename = "${surroundImpulseFiles}/share/surround/atmos.wav",
                    channel = 1,  -- Rear channels
                    gain = 0.6,   -- Reduced gain for rear channels
                    delay = 0,
                    partition = 8192,
                    maxsize = 65536,
                  },
                },
                {
                  type = "ladspa",
                  name = "virtual_surround_center",
                  plugin = "zita-convolver",
                  label = "zita_convolver",
                  config = {
                    filename = "${surroundImpulseFiles}/share/surround/atmos.wav",
                    channel = 2,  -- Center channel
                    gain = 0.7,
                    delay = 0,
                    partition = 8192,
                    maxsize = 65536,
                  },
                },
              },
              links = {
                -- Front channels
                { "virtual_surround_front:Out-L", "output:playback_FL" },
                { "virtual_surround_front:Out-R", "output:playback_FR" },
                -- Rear channels
                { "virtual_surround_rear:Out-L", "output:playback_RL" },
                { "virtual_surround_rear:Out-R", "output:playback_RR" },
                -- Side channels (mixed from front and rear)
                { "virtual_surround_front:Out-L", "output:playback_SL" },
                { "virtual_surround_rear:Out-L", "output:playback_SL" },
                { "virtual_surround_front:Out-R", "output:playback_SR" },
                { "virtual_surround_rear:Out-R", "output:playback_SR" },
                -- Center and LFE
                { "virtual_surround_center:Out-L", "output:playback_FC" },
                { "virtual_surround_center:Out-R", "output:playback_LFE" },
              },
            },
          },
        }
        
        table.insert(alsa_monitor.rules, surroundRule)
      '')
		
      ];
    };

    # Your existing PipeWire core settings
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

    # Your existing PulseAudio compatibility settings
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

  # Your existing security settings
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

  # Add Bluetooth-related packages to your system packages
  environment.systemPackages = with pkgs; [
    alsa-utils
    easyeffects
    helvum
    pavucontrol
	zita-convolver
	ladspa-sdk
	qpwgraph
  ];

}## 32bit int
# { config, lib, pkgs, ... }:

# {
#   # Disable PulseAudio
#   hardware.pulseaudio.enable = false;

#   services.pipewire = {
#     enable = true;
#     alsa.enable = true;
#     pulse.enable = true;
#     jack.enable = true;  # Enable JACK support for professional audio apps

#     # WirePlumber configuration for highest quality
#     wireplumber = {
#       enable = true;
#       configPackages = [
#         (pkgs.writeTextDir "share/wireplumber/main.lua.d/99-high-quality.lua" ''
#           alsa_monitor.rules = {
#             {
#               matches = {{{ "node.name", "matches", "*_*put.*" }}};
#               apply_properties = {
#                 -- High-quality audio format (32-bit integer)
#                 ["audio.format"] = "S32LE",
#                 -- High sample rate
#                 ["audio.rate"] = 96000,
#                 -- Larger buffer for better quality
#                 ["api.alsa.period-size"] = 1024,
#                 ["api.alsa.period-num"] = 4,
#                 -- Higher headroom for cleaner sound
#                 ["api.alsa.headroom"] = 256,
#                 -- Highest quality resampling
#                 ["resample.quality"] = 10,
#                 ["resample.disable"] = false,
#                 -- Use higher quality filter
#                 ["channelmix.normalize"] = false,
#                 ["channelmix.mix-lfe"] = false,
#                 -- No power saving for best quality
#                 ["session.suspend-timeout-seconds"] = 0,
#               },
#             },
#           }
#         '')
#       ];
#     };

#     # PipeWire core settings for high quality
#     extraConfig.pipewire."92-high-quality" = {
#       "context.properties" = {
#         "default.clock.rate" = 96000;
#         "default.clock.quantum" = 1024;
#         "default.clock.min-quantum" = 1024;
#         "default.clock.max-quantum" = 2048;
#       };
#       "context.modules" = [
#         {
#           name = "libpipewire-module-rt";
#           args = {
#             "nice.level" = -15;
#             "rt.prio" = 88;
#           };
#         }
#       ];
#     };

#     # PulseAudio compatibility settings for high quality
#     extraConfig.pipewire-pulse."92-high-quality" = {
#       "pulse.properties" = {
#         "pulse.default.format" = "S32LE";
#         "pulse.default.rate" = "96000";
#         "pulse.min.req" = "1024/96000";
#         "pulse.default.req" = "1024/96000";
#         "pulse.default.frag" = "1024/96000";
#         "pulse.min.quantum" = "1024/96000";
#         "pulse.quantum.limit" = "2048/96000";
#       };
#       "stream.properties" = {
#         "resample.quality" = 10;
#         "resample.disable" = false,
#         "channelmix.normalize" = false,
#         "channelmix.mix-lfe" = false,
#       };
#     };
#   };

#   # System-wide audio optimizations
#   security = {
#     rtkit.enable = true;
#     pam.loginLimits = [
#       {
#         domain = "@audio";
#         item = "memlock";
#         type = "-";
#         value = "unlimited";
#       }
#       {
#         domain = "@audio";
#         item = "rtprio";
#         type = "-";
#         value = "99";
#       }
#     ];
#   };

#   # Essential high-quality audio packages
#   environment.systemPackages = with pkgs; [
#     alsa-utils
#     easyeffects    # For additional audio processing
#     pulsemixer
#     helvum         # PipeWire patchbay
#     pavucontrol    # PulseAudio volume control
#   ];

#   # Optional but recommended: CPU frequency scaling for consistent audio performance
#   powerManagement = {
#     cpuFreqGovernor = "performance";
#     powertop.enable = false;
#   };
# }



  # # Enable sound with pipewire.
  # hardware.pulseaudio.enable = false;
  # security.rtkit.enable = true;
  # services.pipewire = {
  #   enable = true;
  # 	systemWide = true;
  #   alsa.enable = true;
  #   alsa.support32Bit = true;
  #   pulse.enable = true;
  #   # If you want to use JACK applications, uncomment this
  #   #jack.enable = true;

  #   # use the example session manager (no others are packaged yet so this is enabled by default,
  #   # no need to redefine it in your config for now)
  #   #media-session.enable = true;
  # };

