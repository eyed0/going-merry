{ config, lib, pkgs, ... }:

let
  isNiri = config.wayland.windowManager.niri.enable or false;
  
  # Create a derivation for the clipboard config
  clipboardConfig = pkgs.writeTextFile {
    name = "clipboard-config";
    destination = "/clipboard.conf";
    text = ''
      [general]
      max_history = 150
      sync_across_devices = true
      entry_lifetime = 30
      startup_delay = 2
      auto_start = true
      minimize_to_tray = true
      save_history = true
      history_file_path = ${config.home.homeDirectory}/.clipboard/history.db

      [clipboard_modes]
      plain_text = true
      rich_text = true
      image = true
      files = true
      html = true
      markdown = true
      code = true
      urls = true

      [security]
      encrypt_clipboard = false
      encryption_key_path = ${config.home.homeDirectory}/.clipboard/encryption_key
      auto_clear_after = 3600
      require_confirmation_for_clear = true

      [filters]
      remove_sensitive_data = true
      sanitize_patterns = [
          "password",
          "secret",
          "token",
          "key",
          "api[_-]?key",
          "access[_-]?token"
      ]
      max_text_length = 1000000
      compress_images = true
      max_image_size = "10MB"

      [notifications]
      show_clipboard_change = true
      desktop_notifications = true
      notification_sound = true
      notification_timeout = 3000
      notification_position = "top-right"
      show_preview = true
      preview_length = 50

      [performance]
      cache_size = "256MB"
      max_entry_size = "10MB"
      cleanup_interval = "24h"
      index_content = true
      compress_history = true
      lazy_loading = true
      parallel_processing = true

      [shortcuts]
      copy_shortcut = "Ctrl+c"
      paste_shortcut = "Ctrl+v"
      history_shortcut = "Ctrl+Shift+H"
      clear_shortcut = "Ctrl+Shift+X"
      preferences_shortcut = "Ctrl+Shift+P"
      search_shortcut = "Ctrl+Shift+F"
      next_entry = "Alt+Right"
      previous_entry = "Alt+Left"

      [wayland]
      use_primary_selection = true
      sync_primary_selection = true
      wl_clipboard_manager = "wl-clipboard"
      fallback_to_xclip = true
    '';
  };
in
{
  # Install required packages
  home.packages = with pkgs; [
    clipboard-jh
    wl-clipboard  # Wayland clipboard utility
    xclip        # X11 clipboard utility for fallback
  ];

  # Create required directories
  home.file = {
    ".clipboard/.keep".text = "";
    ".clipboard/plugins/.keep".text = "";
    ".clipboard/scripts/.keep".text = "";
    # Link the config file
    ".config/clipboard/clipboard.conf".source = "${clipboardConfig}/clipboard.conf";
  };

  # Ensure proper Wayland integration
  home.sessionVariables = lib.mkIf isNiri {
    CLIPBOARD_WAYLAND = "1";
    CLIPBOARD_NO_DAEMON = "1";
  };

  # Add systemd user service
  systemd.user.services.clipboard = {
    Unit = {
      Description = "Clipboard Manager Service";
      After = ["graphical-session.target"];
      PartOf = ["graphical-session.target"];
    };

    Service = {
      ExecStart = "${pkgs.clipboard-jh}/bin/clipboard";
      Restart = "on-failure";
      Environment = lib.mkIf isNiri [
        "WAYLAND_DISPLAY=${config.wayland.windowManager.niri.settings.output or ""}"
        "DISPLAY=:0"
      ];
    };

    Install = {
      WantedBy = ["graphical-session.target"];
    };
  };
}
