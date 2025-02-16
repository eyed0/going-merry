{ config, lib, pkgs, ... }:

{
  services.pulseaudio.enable = false;
  
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
    jack.enable = true;
    audio.enable = true;
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
    ];
  };

  environment.systemPackages = with pkgs; [
    pavucontrol
    qpwgraph
    ladspa-sdk
    zita-convolver
  ];
}
