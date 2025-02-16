{ config, lib, pkgs, ... }:

{
  # Disable PulseAudio
  hardware.pulseaudio.enable = false;

  # Enable sound with pipewire
  sound.enable = true;

  # RTKit is optional but recommended
  security.rtkit.enable = true;
  
  # Core PipeWire configuration
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;

    # High-quality audio settings
    config.pipewire = {
      "context.properties" = {
        "default.clock.rate" = 96000;
        "default.clock.quantum" = 1024;
        "default.clock.min-quantum" = 1024;
        "default.clock.max-quantum" = 2048;
        "core.daemon" = true;
        "core.name" = "pipewire-0";
      };
      "context.modules" = [
        {
          name = "libpipewire-module-rt";
          args = {
            "nice.level" = -11;
            "rt.prio" = 88;
            "rt.time.soft" = -1;
            "rt.time.hard" = -1;
          };
          flags = [ "ifexists" "nofail" ];
        }
        {
          name = "libpipewire-module-filter-chain";
          args = {
            "node.description" = "Virtual Surround Sink";
            "media.name" = "Virtual Surround Sink";
            "filter.graph" = {
              nodes = [
                {
                  type = "builtin";
                  label = "convolver";
                  name = "conv_surround";
                  config = {
                    filename = "${config.environment.etc."pipewire/atmos.wav".source}";
                    channel = 0;
                  };
                }
              ];
            };
            "capture.props" = {
              "media.class" = "Audio/Sink";
              "audio.channels" = 8;
              "audio.position" = [ "FL" "FR" "FC" "LFE" "RL" "RR" "SL" "SR" ];
            };
            "playback.props" = {
              "audio.channels" = 2;
              "audio.position" = [ "FL" "FR" ];
            };
          };
        }
      ];
    };
  };

  # Required system packages
  environment.systemPackages = with pkgs; [
    # Core audio tools
    pipewire
    wireplumber
    pavucontrol
    
    # Audio processing plugins
    ladspa-sdk
    zita-convolver
  ];

  # Deploy atmos.wav to system configuration
  environment.etc."pipewire/atmos.wav" = {
    source = ./atmos.wav;  # Path to your atmos.wav file
    mode = "0644";
  };

  # Audio group and real-time priority settings
  security.pam.loginLimits = [
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
}
