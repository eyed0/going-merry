{ config, lib, pkgs, ... }:

let
  # Helper function for enabling features only if Niri is active
  isNiri = config.wayland.windowManager.niri.enable or false;
in
{
  home.packages = with pkgs; [
    clipboard
    wl-clipboard  # Wayland clipboard utility
    xclip        # X11 clipboard utility for fallback
  ];

  # Create required directories and ensure proper permissions
  home.file.".clipboard/.keep".text = "";
  home.file.".clipboard/plugins/.keep".text = "";
  home.file.".clipboard/scripts/.keep".text = "";

  programs.clipboard = {
    enable = true;
    
    settings = {
      general = {
        max_history = 100;
        sync_across_devices = true;
        entry_lifetime = 30;
        startup_delay = 2;  # Delay in seconds before starting the service
        auto_start = true;
        minimize_to_tray = true;
        save_history = true;
        history_file_path = "${config.home.homeDirectory}/.clipboard/history.db";
      };

      clipboard_modes = {
        plain_text = true;
        rich_text = true;
        image = true;
        files = true;
        html = true;
        markdown = true;
        code = true;
        urls = true;
      };

      security = {
        encrypt_clipboard = false;
        encryption_key_path = "${config.home.homeDirectory}/.clipboard/encryption_key";
        auto_clear_after = 3600;  # Clear sensitive data after 1 hour
        require_confirmation_for_clear = true;
        allowed_apps = [
          ".*"  # Allow all apps by default
        ];
        blocked_apps = [
          "keepassxc"  # Example: block specific apps
          "bitwarden"
        ];
      };

      filters = {
        remove_sensitive_data = true;
        sanitize_patterns = [
          "password"
          "secret"
          "token"
          "key"
          "api[_-]?key"
          "access[_-]?token"
          "\\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}\\b"  # Email addresses
        ];
        max_text_length = 1000000;  # 1MB text limit
        compress_images = true;
        max_image_size = "10MB";
      };

      notifications = {
        show_clipboard_change = true;
        desktop_notifications = true;
        notification_sound = true;
        notification_timeout = 3000;  # 3 seconds
        notification_position = "top-right";
        show_preview = true;
        preview_length = 50;  # characters
      };

      performance = {
        cache_size = "256MB";
        max_entry_size = "10MB";
        cleanup_interval = "24h";
        index_content = true;
        compress_history = true;
        lazy_loading = true;
        parallel_processing = true;
      };

      shortcuts = {
        copy_shortcut = "Ctrl+c";
        paste_shortcut = "Ctrl+v";
        history_shortcut = "Ctrl+Shift+H";
        clear_shortcut = "Ctrl+Shift+X";
        preferences_shortcut = "Ctrl+Shift+P";
        search_shortcut = "Ctrl+Shift+F";
        next_entry = "Alt+Right";
        previous_entry = "Alt+Left";
      };

      wayland = lib.mkIf isNiri {
        use_primary_selection = true;
        sync_primary_selection = true;
        niri_integration = {
          enable = true;
          follow_focus = true;  # Update clipboard when focus changes
          preserve_clipboard = true;  # Keep clipboard content when Niri restarts
          handle_screenshots = true;  # Automatically copy screenshots
        };
        wl_clipboard_manager = "wl-clipboard";
        fallback_to_xclip = true;
      };

      plugins = {
        enable = true;
        plugin_directory = "${config.home.homeDirectory}/.clipboard/plugins";
        allowed_plugins = ["*"];
        auto_update_plugins = true;
      };

      scripts = {
        enable = true;
        script_directory = "${config.home.homeDirectory}/.clipboard/scripts";
        allowed_script_extensions = [".sh" ".py" ".js"];
        script_timeout = 5;  # seconds
      };

      search = {
        enable = true;
        fuzzy_search = true;
        case_sensitive = false;
        search_in_content = true;
        max_search_results = 100;
        highlight_matches = true;
      };
    };
  };

  # Ensure proper Wayland integration
  home.sessionVariables = lib.mkIf isNiri {
    CLIPBOARD_WAYLAND = "1";
    CLIPBOARD_NO_DAEMON = "1";  # Let Niri manage the clipboard daemon
  };

  # Add systemd user service for clipboard
  systemd.user.services.clipboard = {
    Unit = {
      Description = "Clipboard Manager Service";
      After = ["graphical-session.target"];
      PartOf = ["graphical-session.target"];
    };

    Service = {
      ExecStart = "${pkgs.clipboard}/bin/clipboard";
      Restart = "on-failure";
      Environment = [
        "WAYLAND_DISPLAY=${config.wayland.windowManager.niri.settings.output}"
        "DISPLAY=:0"
      ];
    };

    Install = {
      WantedBy = ["graphical-session.target"];
    };
  };
}
