
{ config, pkgs, inputs, ... }:

{
 
  programs.thunar.enable = true;
  
  environment = {
    systemPackages = with pkgs; [

      tree
      nh # TODO https://github.com/viperML/nh, turn it module 
      nixd
      gcc
      lldb
      helix
      rustup
      tree-sitter
      rage
      ragenix
      # statix # Lints and suggestions for the nix programming language

      # jdk23
      # maven
      # jdt-language-server # For Eglot integration

      #       email

      aerc
      inputs.zen-browser.packages."${system}".beta

      #       apps

      nicotine-plus # soulseek
      #appimage-run
      #inkscape
      #signal-desktop #signal messanger
      arduino # electronics prototyping platform
      arduinoOTA # Tool for uploading programs to Arduino boards over a network
      arduino-mk # Makefile for Arduino sketches
      arduino-ide # 
      #kanata # A tool to improve keyboard comfort and usability with advanced customization
      #anki
      musikcube
      kdePackages.kdenlive # vdo editor
      ffmpeg-full
      x264
      svt-av1
      libaom
      
      #astroterm # Celestial viewer for the terminal
      kdePackages.dolphin
      kdePackages.dolphin-plugins
      kdePackages.kwalletmanager

      #       utilities

      bat
      ripgrep
      fd
      lsd # replacement for ls
      fzf

      solaar
      klavaro
     
      #fontforge-gtk
      dust # disk usage
      #gcompris # educational software for children
      zoxide # A fast cd command that learns your habits
      btop-rocm # graphical process/system monitor with a customizable interface
      # starship # customizable prompt for any shell
      restic # A backup program that is fast, efficient and secure
      rsync # Fast incremental file transfer utility
      qbittorrent
      typst # latex alternative
      #tinymist # lsp for typst
      #digikam5 #Photo management application
      #kate
      kdePackages.okular 
      kdePackages.ark
      unrar
      xarchiver
      syncthingtray
      enchant #Generic spell checking library
      libreoffice
      #freetube # youtube client
      #paperwork
      #pandoc # Conversion between documentation formats
      television # fuzzy finder TODO
      #gitnr # Create `.gitignore` files using one or more templates
      #impala # TUI for managing wifi
      #streamrip #Scriptable music downloader for Qobuz, Tidal, SoundCloud, and Deezer

      #       android 
      universal-android-debloater
      android-tools

      #       System

      # wluma # TODO https://github.com/maximbaz/wluma
      brightnessctl # brightness control for waybar
      pavucontrol # valum controls
      cmake
      parted
      gparted
      #pciutils
      fastfetch
      #networkmanagerapplet # for waybar

    ];
  };
}
