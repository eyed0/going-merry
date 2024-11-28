{ config, pkgs, lib, ... }:

{
  # Enable home-manager to install and manage clapboard
  home.packages = with pkgs; [
    clapboard
  ];

  # Create the clapboard config directory and config file
  xdg.configFile."clapboard/config.toml".text = ''
    [general]
    max_items = 50
    notification_timeout = 1000
    show_notifications = true
    menu = "fuzzel"
    history_file = "~/.local/share/clapboard/history.json"
    text_only = false
    max_size = 10048576  # 1MB

    [filters]
    exclude = [
      "^password:",
      "^secret:",
      "^token:"
    ]

    [menu.fuzzel]
    lines = 10
    width = 50
    horizontal-pad = 20
    vertical-pad = 10
    inner-pad = 5
    exit-on-keyboard-focus-loss = true
  '';

  # Ensure the history directory exists
  home.file.".local/share/clapboard/.keep".text = "";

  # If you're using systemd to manage user services
  systemd.user.services.clapboard = {
    Unit = {
      Description = "Clapboard clipboard manager";
      PartOf = ["graphical-session.target"];
      After = ["graphical-session.target"];
    };

    Service = {
      ExecStart = "${pkgs.clapboard}/bin/clapboard";
      Restart = "always";
      RestartSec = 3;
    };

    Install = {
      WantedBy = ["graphical-session.target"];
    };
  };
}
