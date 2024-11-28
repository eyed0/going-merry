{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkOption types mkEnableOption;
in {
  options.programs.eww-bar = {
    enable = mkEnableOption "eww bar configuration";
    
    package = mkOption {
      type = types.package;
      default = pkgs.eww;
      description = "The eww package to use.";
    };
  };

  config = let
    configDir = "eww";
    ewwConfig = {
      "eww/eww.yuck" = {
        source = pkgs.writeText "eww.yuck" ''
          ${builtins.readFile ./eww.yuck}
        '';
        target = "${configDir}/eww.yuck";
      };

      "eww/eww.scss" = {
        source = pkgs.writeText "eww.scss" ''
          ${builtins.readFile ./eww.scss}
        '';
        target = "${configDir}/eww.scss";
      };
    };
  in
    lib.mkIf config.programs.eww-bar.enable {
	  home.packages = [
        config.programs.eww-bar.package
      ];

      xdg.configFile = ewwConfig;

      # # Optional: Add systemd user service for autostart
      # systemd.user.services.eww = {
      #   Unit = {
      #     Description = "Eww Daemon";
      #     PartOf = ["graphical-session.target"];
      #     After = ["graphical-session.target"];
      #   };
      #   Service = {
      #     Environment = "PATH=/run/current-system/sw/bin";
      #     ExecStart = "${config.programs.eww-bar.package}/bin/eww daemon --no-daemonize";
      #     Restart = "on-failure";
      #   };
      #   Install = {
      #     WantedBy = ["graphical-session.target"];
      #   };
      # };
    };
}
