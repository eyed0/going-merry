#### why just bevause I can, Snd it works, just power consuming for my current system

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
                ["audio.rate"] = 384000,  # Increased to 384kHz
                ["api.alsa.period-size"] = 1024,  # Increased for stability at high sample rate
                ["api.alsa.period-num"] = 4,  # Increased buffer periods
                ["api.alsa.headroom"] = 1024,  # Increased for higher sample rate
                ["resample.quality"] = 15,
                ["resample.disable"] = false,
                ["channelmix.normalize"] = false,
                ["channelmix.mix-lfe"] = false,
                ["session.suspend-timeout-seconds"] = 0,
                ["api.alsa.use-acp"] = true,
                ["node.pause-on-idle"] = false,
                ["node.latency"] = "512/384000",  # Adjusted latency for higher sample rate
                ["api.alsa.disable-batch"] = false,  # Enable batch processing for efficiency
                ["api.alsa.multi-rate"] = true,  # Enable multi-rate processing
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
    ["audio.position"] = "FL,FR,FC,LFE,SL,SR,RL,RR",  -- 7.1 speaker layout
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
            channel = 0,  -- Front channels
            gain = 0.8,
            delay = 0,
            partition = 16384,  -- Increased partition size for 384kHz
            maxsize = 131072,  -- Increased maxsize for higher sample rate
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
            gain = 0.6,
            delay = 0,
            partition = 16384,
            maxsize = 131072,
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
            partition = 16384,
            maxsize = 131072,
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

      extraConfig.pipewire."92-high-quality" = {
      "context.properties" = {
        "default.clock.rate" = 384000;
        "default.clock.quantum" = 1024;
        "default.clock.min-quantum" = 1024;
        "default.clock.max-quantum" = 8192;
        "core.daemon" = true;
        "core.version" = 3;
        "mem.allow-mlock" = true;
        "support.dbus" = true;
        "log.level" = 2;
        "default.clock.min-quantum-denormal" = 1024;
        "default.clock.force-rate" = 384000;
        "default.clock.force-quantum" = 1024;
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
              "rt.time.soft" = 500000;  # Increased for higher sample rate
              "rt.time.hard" = 500000;
              "rlimit.rttime" = -1;  # Unlimited real-time scheduling
			};
          }
		];
      };

	  extraConfig.pipewire-pulse."92-high-quality" = {
		"pulse.properties" = {
		  "pulse.default.format" = "F32LE";
		  "pulse.default.rate" = "384000";  # Increased to 384kHz
		  "pulse.min.req" = "1024/384000";
		  "pulse.default.req" = "1024/384000";
		  "pulse.default.frag" = "1024/384000";
		  "pulse.min.quantum" = "1024/384000";
		  "pulse.quantum.limit" = "8192/384000";
		  "pulse.idle.timeout" = 0;
		  "pulse.min.latency" = "512/384000";
		  "pulse.max.latency" = "2048/384000";  # Added maximum latency limit
		};
		"stream.properties" = {
		  "resample.quality" = 15;
		  "resample.disable" = false;
		  "channelmix.normalize" = false;
		  "channelmix.mix-lfe" = false;
		  "compress.dither" = false;
		  "resample.passthrough.threshold" = 8;  # Higher threshold for sample rate conversion
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
          item = "cpu";  # Added CPU time limit exemption
          type = "-";
          value = "unlimited";
		}
      ];
	};

		# Added CPU optimization for audio processing
	powerManagement = {
      cpuFreqGovernor = "performance";
	};


	environment.systemPackages = with pkgs; [
      alsa-utils
      easyeffects
      helvum
      pavucontrol
      zita-convolver
      ladspa-sdk
      qpwgraph
	];
  }
