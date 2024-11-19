# Too power consumming for laptop

{
  pkgs, ...
}:

{
  programs.mpv = {
    enable = true;
          
    config = {
      # General
      "profile" = "gpu-hq"; # other options default, low-latency, gpu-hq, gpu
      "gpu-api" = "auto";  # other options vulkan, opengl
      "hwdec" = "vaapi";  # other options vulkan, rpi, vaapi, auto
      "reset-on-next-file" = "pause";

      # Enhanced Video Quality Settings
      "scale" = "ewa_lanczosharp";  # High-quality scaling
      "cscale" = "ewa_lanczosharp";
      "dscale" = "ewa_lanczosharp";
      "correct-downscaling" = true;
      "linear-downscaling" = true;
      "sigmoid-upscaling" = true;
      "scale-antiring" = 0.7;
      "cscale-antiring" = 0.7;
      "dither-depth" = "auto";

      # Optimized Color and HDR
      "target-prim" = "auto";
      "target-trc" = "auto";
      "gamma-auto" = true;
      "hdr-compute-peak" = true;
      "tone-mapping" = "hable";
      "tone-mapping-param" = 0.7;
      "tone-mapping-mode" = "hybrid";
      "gamut-mapping-mode" = "perceptual";
      "icc-profile-auto" = true;
      "vf" = "format=colorlevels=full:colormatrix=auto";

      # Enhanced Motion Processing
      "video-sync" = "display-resample";
      "interpolation" = true;
      "tscale" = "oversample";
      "tscale-window" = "sphinx";
      "tscale-radius" = 1.5;
      "tscale-clamp" = 0.0;

      # Advanced Debanding
      "deband" = true;
      "deband-iterations" = 4;
      "deband-threshold" = 48;
      "deband-range" = 16;
      "deband-grain" = 48;

      # Optimized Cache Settings
      "cache" = true;
      "cache-secs" = 800;
      "demuxer-max-bytes" = "800MiB";
      "demuxer-readahead-secs" = 800;
      "video-latency-hacks" = true;

      # GPU Processing
      "gpu-context" = "auto";
      "fbo-format" = "rgba32f";
      "alpha" = "blend";
      "ao" = "pipewire";

      # High-Quality Screenshots
      "screenshot-format" = "png";
      "screenshot-png-compression" = 7;
      "screenshot-high-bit-depth" = true;
      "screenshot-directory" = "~/Pictures/mpv-screenshots";
      "screenshot-template" = "%F-%P-%n";

      # Input Settings
      "input-default-bindings" = true;
      "input-ar-delay" = 500;
      "input-ar-rate" = 20;
      "input-builtin-bindings" = true;
      "input-gamepad" = true;
      "input-cursor" = true;
      "input-right-alt-gr" = true;
      "input-vo-keyboard" = true;

	  # Enhanced Audio Settings
      "audio-format" = "float";
      "audio-samplerate" = 96000;
      "audio-pitch-correction" = "no";
      "audio-channels" = "auto";
      "audio-normalize-downmix" = "no";
      "audio-resample-filter-size" = 32;
      "audio-resample-phase-shift" = 12;
      "audio-resample-cutoff" = 0.976;

      # Advanced audio settings
      "audio-buffer" = 200;
      "audio-stream-silence" = "no";
      "gapless-audio" = "yes";
      "hr-seek-framedrop" = "no";

      # Audio filter
      af = "scaletempo2";
      # Uncomment the following line for room correction if needed
      # af-add=equalizer=2:5:10:-5:10:-5:10:-3:10:8  # Example EQ curve

      # Channel layouts - uncomment as needed
      # "audio-channels"= [7.1,5.1,stereo];  # Enables 7.1, 5.1, and stereo output
      #audio-spdif-codecs=ac3,dts    # Enable passthrough for AC3 and DTS

      # Audio device selection
      "audio-device" = "auto";             # Let Pipewire handle device selection
      "audio-exclusive" = "yes";           # Uncomment for exclusive device access


      # OSD Settings
      "osd-bar" = "yes";
      "osd-font" = "Atkingson Hyperlegible";
      "osd-font-size" = 32;
      "osd-color" = "#CCFFFFFF";
      "osd-border-color" = "#DD322640";
      "osd-bar-align-y" = 0;
      "osd-border-size" = 2;
      "osd-bar-h" = 2;
      "osd-bar-w" = 60;
	  
    };

    profiles = {
      # 4K HDR Profile
      "4k-hdr" = {
        profile-desc = "4K HDR Content";
        profile-cond = "(width >= 3840 and height >= 2160)";
        "deband" = true;
        "deband-iterations" = 2;
        "interpolation" = false;
        "scale" = "ewa_lanczosharp";
        "cscale" = "ewa_lanczosharp";
        "video-sync" = "display-resample";
        "target-prim" = "bt.2020";
        "target-trc" = "pq";
        "tone-mapping" = "bt.2390";
        "tone-mapping-mode" = "hybrid";
      };

      # 1080p Profile
      "1080p" = {
        profile-desc = "Full HD Content";
        profile-cond = "(width <= 1920 and height <= 1080)";
        "scale" = "ewa_lanczosharp";
        "cscale" = "ewa_lanczosharp";
        "deband" = true;
        "deband-iterations" = 4;
        "interpolation" = true;
        "tscale" = "oversample";
      };

      # Anime Profile
      "anime" = {
        profile-desc = "Anime Content";
        "scale" = "ewa_lanczosharp";
        "deband" = true;
        "deband-iterations" = 4;
        "deband-threshold" = 35;
        "deband-range" = 20;
        "deband-grain" = 16;
        "scale-antiring" = 0.5;
        "cscale-antiring" = 0.5;
      };

      # Streaming Profile
      "protocol.http" = {
        "force-window" = true;
        "ytdl-format" = "bestvideo[height<=?2160][vcodec^=vp9][fps<=?60]+bestaudio/best";
        "cache" = true;
        "no-cache-pause" = true;
        "demuxer-max-bytes" = "800MiB";
        "demuxer-readahead-secs" = 800;
      };

      "protocol.https" = {
        profile = "protocol.http";
      };

      "protocol.ytdl" = {
        profile = "protocol.http";
      };
    };
  };

  home.file = {
    ".config/mpv/scripts/hdr_controls.lua".text = ''
      local mp = require('mp')
      -- Table of tone mapping algorithms
      local tone_mapping_options = {"bt.2390", "hable", "mobius"}
      local current_tone_mapping = 1
      -- Table of HDR peak values
      local peak_values = {100, 200, 400, 800, 1000}
      local current_peak = 1
      -- Function to cycle tone mapping
      function cycle_tone_mapping()
          current_tone_mapping = current_tone_mapping % #tone_mapping_options + 1
          local new_tone_mapping = tone_mapping_options[current_tone_mapping]
          mp.set_property("tone-mapping", new_tone_mapping)
          mp.osd_message(string.format("Tone Mapping: %s", new_tone_mapping))
      end
      -- Function to cycle HDR peak values
      function cycle_peak_values()
          current_peak = current_peak % #peak_values + 1
          local new_peak = peak_values[current_peak]
          mp.set_property_number("target-peak", new_peak)
          mp.osd_message(string.format("HDR Peak: %d nits", new_peak))
      end
      -- Register key bindings
      mp.add_key_binding("h", "cycle-tone-mapping", cycle_tone_mapping)
      mp.add_key_binding("H", "cycle-peak-values", cycle_peak_values)
    '';

    # Enhanced input configuration (removed shader-related keybindings)
    ".config/mpv/input.conf".text = ''
      # -- Playback Control --
      SPACE cycle pause
      ENTER playlist-next
      l seek 5
      h seek -5
      L seek 60
      H seek -60
      . frame-step
      , frame-back-step
      
      # -- Precise Seeking --
      RIGHT seek  5 exact
      LEFT  seek -5 exact
      Shift+RIGHT seek  30
      Shift+LEFT  seek -30
      
      # -- Speed Control --
      [ multiply speed 0.9091
      ] multiply speed 1.1
      { multiply speed 0.5
      } multiply speed 2.0
      BS set speed 1.0
      
      # -- Volume Control --
      UP    add volume  5
      DOWN  add volume -5
      m cycle mute
      WHEEL_UP   add volume 2
      WHEEL_DOWN add volume -2
      
      # -- Video Processing --
      d cycle deband
      D cycle deband-iterations +1
      Ctrl+d cycle-values deband-threshold 35 48 64
      
      # -- Audio Control --
      a cycle audio
      A cycle audio down
      CTRL+a cycle audio-device
      + add audio-delay 0.100
      - add audio-delay -0.100
      
      # -- Subtitle Control --
      s cycle sub
      S cycle sub down
      x cycle sub-visibility
      z add sub-delay -0.1
      Z add sub-delay +0.1
      v cycle sub-ass-vsfilter-aspect-compat
      V cycle sub-ass-vsfilter-blur-compat
      
      # -- Screenshot Controls --
      Ctrl+s screenshot
      Alt+s screenshot video
      
      # -- Window Controls --
      f cycle fullscreen
      ESC set fullscreen no
      Ctrl+w quit
      Alt+ENTER cycle window-scale 0.5 2 1
      
      # -- Color Adjustments --
      1 add contrast -1
      2 add contrast 1
      3 add brightness -1
      4 add brightness 1
      5 add gamma -1
      6 add gamma 1
      7 add saturation -1
      8 add saturation 1
      
      # HDR Controls
      h  script-binding cycle-tone-mapping
      H  script-binding cycle-peak-values
      
      # -- Profile Controls --
      p script-binding stats/display-stats-toggle
      P cycle-values scale nearest bilinear bicubic lanczos ewa_lanczosharp
      
      # -- Playlist Controls --
      > playlist-next
      < playlist-prev
      Ctrl+r cycle-values loop-file "inf" "no"
      R cycle-values loop-playlist "inf" "no"
      
      # -- Other Controls --
      O no-osd cycle-values osd-level 3 1
      i script-binding stats/display-stats-toggle
      ` script-binding console/enable
      
      # -- Mouse Controls --
      MOUSE_BTN0     ignore
      MOUSE_BTN0_DBL cycle fullscreen
      MOUSE_BTN2     cycle pause
      MOUSE_BTN3     add volume 2
      MOUSE_BTN4     add volume -2
      MOUSE_BTN5     seek 10
      MOUSE_BTN6     seek -10
    '';
  };
}
