{ config, pkgs, ... }: {

  programs.mu.enable = true;
  # Email packages
  home.packages = with pkgs; [
    isync
    msmtp
  ];
}
