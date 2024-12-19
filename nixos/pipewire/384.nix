#### why just because I can, and it works, just too power consuming for my current system

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
    pulse.enable = true;
    jack.enable = true;
    audio.enable = true;
    
    wireplumber = {
      enable = true;
      configPackages = [
        (pkgs.writeTextDir "share/wireplumber/main.lua.d/99-ultra-high-quality.lua" ''
          alsa_monitor.rules = {
            {
              matches = {{{ "node.name", "matches", "*_*put.*" }}};
              apply_properties = {
                ["audio.format"] = "F32LE",
                ["audio.rate"] = 384000,
                ["api.alsa.period-size"] = 256,
                ["api.alsa.period-num"] = 2,
                ["api.alsa.headroom"] = 128,
                ["resample.quality"] = 15,
                ["resample.library"] = "libsoxr",
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
                ["bluez5.codecs"] = "[ ldac_quality aptx_ll aptx_hd_duplex ldac aac aptx aptx_hd sbc_xq ]",
                ["bluez5.a2dp.force-audio-info"] = "true",
                ["bluez5.a2dp.ldac.quality"] = "auto",
                ["bluez5.a2dp.aac.bitratemode"] = "0",
                ["bluez5.enable-sbc-xq"] = true,
                ["bluez5.enable-msbc"] = true,
                ["bluez5.enable-hw-volume"] = true,
                ["session.suspend-timeout-seconds"] = 0,
              },
            },
          }
        '')

        (pkgs.writeTextDir "share/wireplumber/main.lua.d/51-ultra-smart-surround.lua" ''
          virtual_surround = {
            matches = {{{ "node.name", "matches", "alsa_output.*" }}};
            apply_properties = {
              ["audio.position"] = "FL,FR,FC,LFE,SL,SR,RL,RR",
              ["audio.channels"] = 8,
              ["node.pause-on-idle"] = false,
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
                      channel = 0,
                      gain = 0.95,
                      delay = 0,
                      partition = 65536,
                      maxsize = 524288,
                      offset = 0,
                      length = 0,
                      drywet = 0.85,
                    },
                  },
                  {
                    type = "ladspa",
                    name = "dynamic_processor",
                    plugin = "dyson_compress_1403",
                    label = "dysonCompress",
                    control = {
                      "Threshold" = -20.0,
                      "Ratio" = 2.0,
                      "Attack" = 0.1,
                      "Release" = 100.0,
                    },
                  },
                  {
                    type = "ladspa",
                    name = "virtual_surround_rear",
                    plugin = "zita-convolver",
                    label = "zita_convolver",
                    config = {
                      filename = "${surroundImpulseFiles}/share/surround/atmos.wav",
                      channel = 1,
                      gain = 0.8,
                      delay = 0.015,
                      partition = 65536,
                      maxsize = 524288,
                      offset = 0,
                      length = 0,
                      drywet = 0.8,
                    },
                  },
                  {
                    type = "ladspa",
                    name = "virtual_surround_center",
                    plugin = "zita-convolver",
                    label = "zita_convolver",
                    config = {
                      filename = "${surroundImpulseFiles}/share/surround/atmos.wav",
                      channel = 2,
                      gain = 0.9,
                      delay = 0.005,
                      partition = 65536,
                      maxsize = 524288,
                      offset = 0,
                      length = 0,
                      drywet = 0.95,
                    },
                  },
                  {
                    type = "ladspa",
                    name = "room_enhancement",
                    plugin = "matrix_spatialiser",
                    label = "matrixSpatialiser",
                    control = {
                      "Width" = 1.8,
                      "Depth" = 1.4,
                      "Focus" = 0.7,
                      "Space" = 0.6,
                    },
                  },
                },
                links = {
                  { "virtual_surround_front:Out-L", "dynamic_processor:Input" },
                  { "dynamic_processor:Output", "room_enhancement:In-L" },
                  { "virtual_surround_front:Out-R", "room_enhancement:In-R" },
                  { "room_enhancement:Out-L", "output:playback_FL" },
                  { "room_enhancement:Out-R", "output:playback_FR" },
                  
                  { "virtual_surround_rear:Out-L", "output:playback_RL" },
                  { "virtual_surround_rear:Out-R", "output:playback_RR" },
                  
                  { "virtual_surround_front:Out-L", "output:playback_SL" },
                  { "virtual_surround_rear:Out-L", "output:playback_SL" },
                  { "virtual_surround_front:Out-R", "output:playback_SR" },
                  { "virtual_surround_rear:Out-R", "output:playback_SR" },
                  
                  { "virtual_surround_center:Out-L", "output:playback_FC" },
                  { "virtual_surround_center:Out-R", "output:playback_LFE" },
                ],
              },
            },
          }

          table.insert(alsa_monitor.rules, virtual_surround)
        '')
      ];
    };

    extraConfig.pipewire."92-ultra-high-quality" = {
      "context.properties" = {
        "default.clock.rate" = 384000;
        "default.clock.quantum" = 256;
        "default.clock.min-quantum" = 256;
        "default.clock.max-quantum" = 512;
        "core.daemon" = true;
        "core.version" = 3;
        "mem.allow-mlock" = true;
        "support.dbus" = true;
        "log.level" = 2;
      };
      "context.modules" = [
        {
          name = "libpipewire-module-rt";
          args = {
            "nice.level" = -20;
            "rt.prio" = 99;
            "rt.time.soft" = 200000;
            "rt.time.hard" = 200000;
          };
        }
        {
          name = "libpipewire-module-protocol-native";
          args = {
            "vm.overrides" = {
              "buffers.video.size" = 65536;
              "buffers.video.align" = 64;
              "buffers.data.size" = 65536;
              "buffers.data.align" = 64;
            };
          };
        }
      ];
    };

    extraConfig.pipewire-pulse."92-ultra-high-quality" = {
      "pulse.properties" = {
        "pulse.default.format" = "F32LE";
        "pulse.default.rate" = "384000";
        "pulse.min.req" = "256/384000";
        "pulse.default.req" = "256/384000";
        "pulse.default.frag" = "256/384000";
        "pulse.min.quantum" = "256/384000";
        "pulse.quantum.limit" = "512/384000";
        "pulse.idle.timeout" = 0;
        "pulse.min.latency" = "256/384000";
      };
      "stream.properties" = {
        "resample.quality" = 15;
        "resample.library" = "libsoxr";
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
      {
        domain = "@audio";
        item = "nice";
        type = "-";
        value = "-20";
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
    sox
    libsoxr
    rnnoise
    calf
    lsp-plugins
    noise-repellent
  ];
}
