{ config, pkgs, lib, ... }:

{
  systemd.user.services.kanata = {
    Unit = {
      Description = "Kanata keyboard remapper";
      PartOf = ["graphical-session.target"];
    };
    Service = {
      ExecStart = "${pkgs.kanata}/bin/kanata-cmd-allowed --device /dev/input/event1 --cfg %E/kanata/config.kbd";
      Restart = "always";
    };
    Install = {
      WantedBy = ["graphical-session.target"];
    };
  };

  xdg.configFile."kanata/config.kbd".text = ''
    (defcfg
      process-unmapped-keys yes
      danger-enable-cmd yes
      log-level debug
    )

    ;; Define system commands
    (defvar
      terminal "foot"
      editor "emacsclient -c"
      brightness-up "brightnessctl set +5%"
      brightness-down "brightnessctl set 5%-"
      volume-up "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
      volume-down "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
      volume-mute "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
    )

    ;; Define keyboard configuration with Fn layer
    (defsrc
      esc  f1   f2   f3   f4   f5   f6   f7   f8   f9   f10  f11  f12
      grv  1    2    3    4    5    6    7    8    9    0    -    =    bspc
      tab  q    w    e    r    t    y    u    i    o    p    [    ]    \
      caps a    s    d    f    g    h    j    k    l    ;    '    ret
      lsft z    x    c    v    b    n    m    ,    .    /    rsft
      lctl lmet lalt           spc            ralt rmet rctl
    )

    ;; Function layer for Fn key combinations
    (deflayer fn
      _    _    @br- @br+ _    @vol- @vol+ @mute _    _    _    _    _
      _    _    _    _    _    _    _    _    _    _    _    _    _    _
      _    _    _    _    _    _    _    _    _    _    _    _    _    _
      _    _    _    _    _    _    _    _    _    _    _    _    _
      _    _    _    _    _    _    _    _    _    _    _    _
      _    _    _              _              _    _    _
    )

    ;; Default layer
    (deflayer default
      _    _    _    _    _    _    _    _    _    _    _    _    _
      _    _    _    _    _    _    _    _    _    _    _    _    _    _
      _    _    _    _    _    _    _    _    _    _    _    _    _    _
      lctl _    _    _    _    _    _    _    _    _    _    _    _
      _    _    _    _    _    _    _    _    _    _    _    _
      _    _    _              _              _    _    _
    )

    ;; Define custom actions
    (defalias
      br-    (cmd brightness-down)
      br+    (cmd brightness-up)
      vol-   (cmd volume-down)
      vol+   (cmd volume-up)
      mute   (cmd volume-mute)
    )

    ;; Your specific key overrides for calculator and insert keys
    (defoverrides
      140 (cmd terminal)    ;; Calculator key -> Launch foot terminal
      110 (cmd editor)      ;; Insert key -> Launch emacs client
    )
  '';

  home.packages = with pkgs; [
    kanata
  ];
}

# KEY_PROG2 (149) 
