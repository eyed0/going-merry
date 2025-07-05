{ config, pkgs, ... }: {
  
  # Email packages
  home.packages = with pkgs; [
    mu
    isync
    msmtp
  ];
}
