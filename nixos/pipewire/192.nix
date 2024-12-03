{ config, lib, pkgs, ... }:

let 
  surroundImpulseFiles = pkgs.stdenv.mkDerivation {
    name = "surround-impulse-files";
    src = ./.; 
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
    alsa.support32Bit = true;
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
                ["audio.rate"] = 192000,  # Set to 192kHz
                ["api.alsa.period-size"] = 512,  # Adjusted for 192kHz
                ["api.alsa.period-num"] = 4,
                ["api.alsa.headroom"] = 512,  # Adjusted for 192kHz
                ["resample.quality"] = 15,
                ["resample.disable"] = false,
                ["channelmix.normalize"] = false,
                ["channelmix.mix-lfe"] = false,
                ["session.suspend-timeout-seconds"] = 0,
                ["api.alsa.use-acp"] = true,
                ["node.pause-on-idle"] = false,
                ["node.latency"] = "256/192000",  # Adjusted latency for 192kHz
                ["api.alsa.disable-batch"] = false,
                ["api.alsa.multi-rate"] = true,
              },
            },
          }


          bluetooth_monitor.rules = {
            {
              matches = {{{ "node.name", "matches", "bluez_*" }}};
              apply_properties = {
                ["bluez5.autoswitch-profile"] = true,
                ["bluez5.codecs"] = "[ ldac aac aptx aptx_hd aptx_ll aptx_adaptive sbc_xq ]",
                ["bluez5.enable-sbc-xq"] = true,
                ["bluez5.enable-msbc"] = true,
                ["bluez5.enable-hw-volume"] = true,
                ["bluez5.a2dp.force-audio-info"] = true,
                ["session.suspend-timeout-seconds"] = 0,
                ["bluez5.hw-volume"] = true,
                ["bluez5.a2dp.ldac.quality"] = "high",  # Added: Force LDAC high quality
                ["bluez5.a2dp.aac.bitratemode"] = "0",  # Added: AAC Variable bitrate
                ["bluez5.a2dp.aptx.hd"] = true,  # Added: Force aptX HD when available
              },
            },
          }

          default_links = {
            ["enable.audio.link-factory"] = true,
            ["enable.audio.pw-link"] = true,
            ["enable.audio.pw-stream"] = true,
          }
        '')

        (pkgs.writeTextDir "share/wireplumber/main.lua.d/51-virtual-surround.lua" ''
          surroundRule = {
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

          table.insert(alsa_monitor.rules, surroundRule)
        '')
      ];
    };

    extraConfig.pipewire."92-high-quality" = {
      "context.properties" = {
        "default.clock.rate" = 192000;  # Set to 192kHz
        "default.clock.quantum" = 512;  # Adjusted for 192kHz
        "default.clock.min-quantum" = 512;
        "default.clock.max-quantum" = 4096;
        "core.daemon" = true;
        "core.version" = 3;
        "mem.allow-mlock" = true;
        "support.dbus" = true;
        "log.level" = 2;
        "default.clock.min-quantum-denormal" = 512;  # Adjusted for 192kHz
        "default.clock.force-rate" = 192000;  # Force 192kHz
        "default.clock.force-quantum" = 512;  # Force adjusted quantum size
      };
      
      "context.spa-libs" = {
        "audio.convert.*" = "audioconvert/libspa-audioconvert";
        "support.*" = "support/libspa-support";
      };

      "context.objects" = [
        {
          factory = "spa-node-factory";
          args = {
            "factory.name" = "support.node.driver";
            "node.name" = "Dummy-Driver";
            "priority.driver" = 8000;
            "node.group" = "pipewire.dummy";
            "node.always-process" = true;
          };
        }
      ];

      "context.modules" = [
        {
          name = "libpipewire-module-rt";
          args = {
            "nice.level" = -20;
            "rt.prio" = 99;
            "rt.time.soft" = 200000;  # Adjusted for 192kHz
            "rt.time.hard" = 200000;
            "rlimit.rttime" = -1;
          };
        }
      ];
    };

    extraConfig.pipewire-pulse."92-high-quality" = {
      "pulse.properties" = {
        "pulse.default.format" = "F32LE";
        "pulse.default.rate" = "192000";  # Set to 192kHz
        "pulse.min.req" = "512/192000";
        "pulse.default.req" = "512/192000";
        "pulse.default.frag" = "512/192000";
        "pulse.min.quantum" = "512/192000";
        "pulse.quantum.limit" = "4096/192000";
        "pulse.idle.timeout" = 0;
        "pulse.min.latency" = "256/192000";
        "pulse.max.latency" = "1024/192000";
      };
      "stream.properties" = {
        "resample.quality" = 15;
        "resample.disable" = false;
        "channelmix.normalize" = false;
        "channelmix.mix-lfe" = false;
        "compress.dither" = false;
        "resample.passthrough.threshold" = 8;
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
      {
        domain = "@audio";
        item = "nice";
        type = "-";
        value = "-20";
      }
      {
        domain = "@audio";
        item = "cpu";
        type = "-";
        value = "unlimited";
      }
    ];
  };

  powerManagement = {
    cpuFreqGovernor = "performance";
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
