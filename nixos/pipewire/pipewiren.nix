{ config, lib, pkgs, ... }:

let
  sofaFile = ./EAC_96kHz.sofa; # Centralized SOFA file path management
in

{
  # Disable PulseAudio
  services.pulseaudio.enable = false;
  
  # PipeWire Configuration
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
    audio.enable = true;

    # Virtual 7.1.4 Surround Sound Filter Chain
    extraConfig.pipewire."71-virtual-surround" = {
      context.modules = [
        {
          name = "libpipewire-module-filter-chain";
          flags = [ "nofail" ];
          args = {
            node.description = "Virtual 7.1.4 Surround";
            media.name = "Virtual 7.1.4 Surround";
            filter.graph = {
              nodes = [
                # Front Left
                {
                  type = "sofa";
                  label = "spatializer";
                  name = "spFL";
                  config = {
                    filename = "${sofaFile}";
                  };
                  control = {
                    "Azimuth" = 30.0;
                    "Elevation" = 0.0;
                    "Radius" = 75.0;
                  };
                }
                # Front Right
                {
                  type = "sofa";
                  label = "spatializer";
                  name = "spFR";
                  config = {
                    filename = "${sofaFile}";
                  };
                  control = {
                    "Azimuth" = 330.0;
                    "Elevation" = 0.0;
                    "Radius" = 75.0;
                  };
                }
                # Front Center
                {
                  type = "sofa";
                  label = "spatializer";
                  name = "spFC";
                  config = {
                    filename = "${sofaFile}";
                  };
                  control = {
                    "Azimuth" = 0.0;
                    "Elevation" = 0.0;
                    "Radius" = 75.0;
                  };
                }
                # Rear Left
                {
                  type = "sofa";
                  label = "spatializer";
                  name = "spRL";
                  config = {
                    filename = "${sofaFile}";
                  };
                  control = {
                    "Azimuth" = 150.0;
                    "Elevation" = 0.0;
                    "Radius" = 75.0;
                  };
                }
                # Rear Right
                {
                  type = "sofa";
                  label = "spatializer";
                  name = "spRR";
                  config = {
                    filename = "${sofaFile}";
                  };
                  control = {
                    "Azimuth" = 210.0;
                    "Elevation" = 0.0;
                    "Radius" = 75.0;
                  };
                }
                # Side Left
                {
                  type = "sofa";
                  label = "spatializer";
                  name = "spSL";
                  config = {
                    filename = "${sofaFile}";
                  };
                  control = {
                    "Azimuth" = 90.0;
                    "Elevation" = 0.0;
                    "Radius" = 75.0;
                  };
                }
                # Side Right
                {
                  type = "sofa";
                  label = "spatializer";
                  name = "spSR";
                  config = {
                    filename = "${sofaFile}";
                  };
                  control = {
                    "Azimuth" = 270.0;
                    "Elevation" = 0.0;
                    "Radius" = 75.0;
                  };
                }
                # LFE (Low Frequency Effects)
                {
                  type = "sofa";
                  label = "spatializer";
                  name = "spLFE";
                  config = {
                    filename = "${sofaFile}";
                  };
                  control = {
                    "Azimuth" = 180.0;
                    "Elevation" = 0.0;
                    "Radius" = 75.0;
                  };
                }
                # Top Front Left
                {
                  type = "sofa";
                  label = "spatializer";
                  name = "spTFL";
                  config = {
                    filename = "${sofaFile}";
                  };
                  control = {
                    "Azimuth" = 30.0;
                    "Elevation" = 75.0;
                    "Radius" = 75.0;
                  };
                }
                # Top Front Right
                {
                  type = "sofa";
                  label = "spatializer";
                  name = "spTFR";
                  config = {
                    filename = "${sofaFile}";
                  };
                  control = {
                    "Azimuth" = 330.0;
                    "Elevation" = 75.0;
                    "Radius" = 75.0;
                  };
                }
                # Top Rear Left
                {
                  type = "sofa";
                  label = "spatializer";
                  name = "spTRL";
                  config = {
                    filename = "${sofaFile}";
                  };
                  control = {
                    "Azimuth" = 150.0;
                    "Elevation" = 75.0;
                    "Radius" = 75.0;
                  };
                }
                # Top Rear Right
                {
                  type = "sofa";
                  label = "spatializer";
                  name = "spTRR";
                  config = {
                    filename = "${sofaFile}";
                  };
                  control = {
                    "Azimuth" = 210.0;
                    "Elevation" = 75.0;
                    "Radius" = 75.0;
                  };
                }
                # Mixers
                { type = "builtin"; label = "mixer"; name = "mixTL"; }
                { type = "builtin"; label = "mixer"; name = "mixTR"; }
                { type = "builtin"; label = "mixer"; name = "mixBL"; }
                { type = "builtin"; label = "mixer"; name = "mixBR"; }
                { type = "builtin"; label = "mixer"; name = "mixL"; }
                { type = "builtin"; label = "mixer"; name = "mixR"; }
              ];
              links = [
                # Base layer (horizontal) connections
                { output = "spFL:Out L"; input = "mixBL:In 1"; }
                { output = "spFL:Out R"; input = "mixBR:In 1"; }
                { output = "spFR:Out L"; input = "mixBL:In 2"; }
                { output = "spFR:Out R"; input = "mixBR:In 2"; }
                { output = "spFC:Out L"; input = "mixBL:In 3"; }
                { output = "spFC:Out R"; input = "mixBR:In 3"; }
                { output = "spRL:Out L"; input = "mixBL:In 4"; }
                { output = "spRL:Out R"; input = "mixBR:In 4"; }
                { output = "spRR:Out L"; input = "mixBL:In 5"; }
                { output = "spRR:Out R"; input = "mixBR:In 5"; }
                { output = "spSL:Out L"; input = "mixBL:In 6"; }
                { output = "spSL:Out R"; input = "mixBR:In 6"; }
                { output = "spSR:Out L"; input = "mixBL:In 7"; }
                { output = "spSR:Out R"; input = "mixBR:In 7"; }
                { output = "spLFE:Out L"; input = "mixBL:In 8"; }
                { output = "spLFE:Out R"; input = "mixBR:In 8"; }
                
                # Top layer connections
                { output = "spTFL:Out L"; input = "mixTL:In 1"; }
                { output = "spTFL:Out R"; input = "mixTR:In 1"; }
                { output = "spTFR:Out L"; input = "mixTL:In 2"; }
                { output = "spTFR:Out R"; input = "mixTR:In 2"; }
                { output = "spTRL:Out L"; input = "mixTL:In 3"; }
                { output = "spTRL:Out R"; input = "mixTR:In 3"; }
                { output = "spTRR:Out L"; input = "mixTL:In 4"; }
                { output = "spTRR:Out R"; input = "mixTR:In 4"; }
                
                # Final mix connections
                { output = "mixBL:Out"; input = "mixL:In 1"; }
                { output = "mixTL:Out"; input = "mixL:In 2"; }
                { output = "mixBR:Out"; input = "mixR:In 1"; }
                { output = "mixTR:Out"; input = "mixR:In 2"; }
              ];
              inputs = [
                "spFL:In" "spFR:In" "spFC:In" "spLFE:In" 
                "spRL:In" "spRR:In" "spSL:In" "spSR:In" 
                "spTFL:In" "spTFR:In" "spTRL:In" "spTRR:In"
              ];
              outputs = [ "mixL:Out" "mixR:Out" ];
            };
            capture.props = {
              node.name = "effect_input.spatializer";
              media.class = "Audio/Sink";
              audio.rate = 96000;
              audio.channels = 12;
              audio.position = [ "FL" "FR" "FC" "LFE" "RL" "RR" "SL" "SR" "TFL" "TFR" "TRL" "TRR" ];
            };
            playback.props = {
              node.name = "effect_output.spatializer";
              node.passive = true;
              audio.rate = 96000;
              audio.channels = 2;
              audio.position = [ "FL" "FR" ];
            };
          };
        }
      ];
    };
  };

  # Security and Real-time Settings
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

  # Noise Torch for additional noise cancellation
  programs.noisetorch.enable = true;

  # Audio packages
  environment.systemPackages = with pkgs; [
    pavucontrol      # PulseAudio Volume Control
    qpwgraph         # PipeWire Graph GUI
    ladspa-sdk       # LADSPA SDK
    zita-convolver   # Convolution engine
  ];
}
