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
        (pkgs.writeTextDir "share/wireplumber/main.lua.d/99-force-rate.lua" ''
          -- Override function to force sample rate
          function force_rate(properties)
            properties["audio.rate"] = 96000
            properties["audio.format"] = "F32LE"
            properties["clock.force-rate"] = 96000
            return properties
          end

          -- Apply to all existing objects
          function apply_properties(om)
            local objects = om:get_objects()
            for obj in objects:iterate() do
              local props = obj.properties
              if props then
                props = force_rate(props)
                obj:update_properties(props)
              end
            end
          end

          -- Override all audio nodes
          local node_om = ObjectManager {
            Interest {
              type = "node",
              Constraint { "media.class", "matches", "Audio/*" },
            }
          }

          node_om:connect("object-added", function(om, node)
            local props = node.properties
            props = force_rate(props)
            node:update_properties(props)
          end)

          -- Override all audio devices
          local device_om = ObjectManager {
            Interest {
              type = "device",
              Constraint { "media.class", "matches", "Audio/*" },
            }
          }

          device_om:connect("object-added", function(om, device)
            local props = device.properties
            props = force_rate(props)
            device:update_properties(props)
          end)

          -- Override default nodes
          local default_om = ObjectManager {
            Interest {
              type = "node",
              Constraint { "node.name", "matches", "auto_*" },
            }
          }

          default_om:connect("object-added", function(om, node)
            local props = node.properties
            props = force_rate(props)
            node:update_properties(props)
          end)

          -- Activate the managers
          node_om:activate()
          device_om:activate()
          default_om:activate()
        '')
      ];
    };

    # Use extraConfig for PipeWire configuration
    extraConfig = {
      pipewire = {
        "92-high-quality" = {
          "context.properties" = {
            "default.clock.rate" = 96000;
            "default.clock.allowed-rates" = [ 96000 ];
            "default.clock.quantum" = 1024;
            "default.clock.min-quantum" = 1024;
            "default.clock.max-quantum" = 4096;
          };
          "context.modules" = [
            {
              name = "libpipewire-module-filter-chain";
              args = {
                "node.description" = "Force Sample Rate";
                "media.name" = "Force Sample Rate";
                "filter.graph" = {
                  "nodes" = [];
                  "inputs" = ["audio.rate=96000"];
                  "outputs" = ["audio.rate=96000"];
                };
              };
            }
          ];
          "stream.properties" = {
            "resample.quality" = 10;
            "clock.force-rate" = 96000;
          };
        };
      };
      pipewire-pulse = {
        "92-high-quality" = {
          "context.properties" = {
            "default.clock.rate" = 96000;
            "default.clock.allowed-rates" = [ 96000 ];
          };
          "pulse.properties" = {
            "server.rate" = 96000;
            "default.clock.rate" = 96000;
            "pulse.default.format" = "F32LE";
            "pulse.default.rate" = 96000;
          };
          "stream.properties" = {
            "clock.force-rate" = 96000;
          };
        };
      };
    };
  };

  # Your existing environment and security settings here...
  environment.systemPackages = with pkgs; [
    alsa-utils
    pavucontrol
    zita-convolver
    ladspa-sdk
    qpwgraph
    ladspaPlugins
    ladspaH
    dragonfly-reverb
    libbs2b
    upower
  ];

  environment.variables = {
    LADSPA_PATH = lib.makeBinPath [
      "${pkgs.ladspaPlugins}/lib/ladspa"
      "${pkgs.dragonfly-reverb}/lib/ladspa"
      "${pkgs.lsp-plugins}/lib/ladspa"
      "${pkgs.zita-convolver}/lib/ladspa"
    ];
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
}
