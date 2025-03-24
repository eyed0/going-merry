
{ config, pkgs, inputs, ... }:

{
  environment = {
    systemPackages = with pkgs; [

      #tree
      nh # TODO https://github.com/viperML/nh, turn it module 
      nixd
      gcc
      lldb
      #bat
      ripgrep
      fd
      lsd # replacement for ls
      broot
      helix
      mg
      rustup
	    tree-sitter
      #android-studio
	    inputs.agenix.packages.x86_64-linux.default
	    age
	    rage
	    statix # Lints and suggestions for the nix programming language

      jdk23
      maven
      jdt-language-server # For Eglot integration

      #       email

      aerc
      thunderbird
	    notmuch
      lieer

      #       apps

      nicotine-plus # soulseek
      #appimage-run
      #inkscape
      #signal-desktop #signal messanger
      #gimp-with-plugins
      arduino # electronics prototyping platform
      #kanata # A tool to improve keyboard comfort and usability with advanced customization
      #anki
	    ventoy # Bootable USB Solution
	    av1an # command-line vdo encoding framework
	    musikcube
	    kdePackages.kdenlive # vdo editor
      gurk-rs # Signal Messenger client for terminal
      astroterm # Celestial viewer for the terminal
      kdePackages.dolphin
      kdePackages.dolphin-plugins

      #       utilities

	    fontforge-gtk
      #dust # disk usage
      gcompris # educational software for children
      zoxide # A fast cd command that learns your habits
      navi # An interactive cheatsheet tool for the command-line and application launchers
      btop # graphical process/system monitor with a customizable interface
      gitui # Blazing fast terminal-ui for Git written in Rust
      starship # customizable prompt for any shell
      restic # A backup program that is fast, efficient and secure
      rsync # Fast incremental file transfer utility
      qbittorrent
      nvtopPackages.full # top for gpu
      typst # latex alternative
      #typstwriter # typst editor
      #tinymist # lsp for typst
      #digikam5
      #kate
      kdePackages.okular 
      kdePackages.ark
      unrar
      #peazip
      xarchiver
      #syncthing
      syncthingtray
      ffmpeg
      enchant #Generic spell checking library
      libreoffice
      #freetube # youtube client
      #paperwork
      #pandoc # Conversion between documentation formats
	    television # fuzzy finder TODO
	    gitnr # Create `.gitignore` files using one or more templates
	    impala # TUI for managing wifi
	    hledger
      hledger-ui
      hledger-web

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
	    networkmanagerapplet # for waybar

    ];
  };
}
