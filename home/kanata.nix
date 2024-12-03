{ config, pkgs, lib, ... }:

{
  services.kanata = {
    enable = true;
    
    keyboards = {
      default = {
        config = ''
          ;; Kanata configuration for laptop with special keys
          
          ;; Process keys in raw mode to catch manufacturer-specific scancodes
          (defcfg
            process-unmapped-keys yes
            danger-enable-cmd yes
          )

          ;; Define keyboard configuration
          (defsrc
            esc  f1   f2   f3   f4   f5   f6   f7   f8   f9   f10  f11  f12
            grv  1    2    3    4    5    6    7    8    9    0    -    =    bspc
            tab  q    w    e    r    t    y    u    i    o    p    [    ]    \
            caps a    s    d    f    g    h    j    k    l    ;    '    ret
            lsft z    x    c    v    b    n    m    ,    .    /    rsft
            lctl lmet lalt           spc            ralt rmet rctl
            nlck kp7  kp8  kp9
            kp4  kp5  kp6
            kp1  kp2  kp3
            kp0  kp.
          )

          ;; Define system commands for laptop controls
          (defvar
            brightness-up "brightnessctl set +5%"
            brightness-down "brightnessctl set 5%-"
            volume-up "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
            volume-down "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
            volume-mute "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
            terminal "foot"
            editor "emacsclient -c"
          )

          ;; Define your custom mappings with function keys
          (deflayer default
            esc  @br-  @br+  @vol- @vol+ @mute f6   f7   f8   f9   f10  f11  f12
            grv  1    2    3    4    5    6    7    8    9    0    -    =    bspc
            tab  q    w    e    r    t    y    u    i    o    p    [    ]    \
            lctl a    s    d    f    g    h    j    k    l    ;    '    ret
            lsft z    x    c    v    b    n    m    ,    .    /    rsft
            lctl lmet lalt           spc            ralt rmet rctl
            @num kp7  kp8  kp9
            kp4  kp5  kp6
            kp1  kp2  kp3
            kp0  kp.
          )

          ;; Define custom actions
          (defalias
            br-    (cmd brightness-down)      ;; Brightness down
            br+    (cmd brightness-up)        ;; Brightness up
            vol-   (cmd volume-down)         ;; Volume down
            vol+   (cmd volume-up)           ;; Volume up
            mute   (cmd volume-mute)         ;; Volume mute
            num    XX                        ;; Make Num Lock always on by making it do nothing
          )

          (defoverrides
            140 (cmd terminal)
            110 (cmd editor) 
          )
        '';
        
        devices = [
          "/dev/input/event1"
        ];
      };
    };
  };

  home.packages = with pkgs; [
    kanata
    # evtest  # Adding evtest for scancode identification
  ];

  home.activation = {
    setupInputPermissions = lib.hm.dag.entryAfter ["writeBoundary"] ''
      sudo chmod a+rw /dev/input/event1 || true
      sudo usermod -aG video $USER || true
    '';
  };
}
