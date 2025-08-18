# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ./nixos/gaming/gaming.nix
      ./nixos/syncthing.nix
      ./nixos/footerminal.nix
      ./nixos/firefox.nix
      ./nixos/fonts/fonts.nix
      ./nixos/fishell.nix
      ./nixos/git.nix
      ./nixos/packages.nix
      ./nixos/pipewire/pipwire.nix
      #./nixos/pipewire/pipewiren.nix
      ./nixos/yazi.nix
      ./nixos/stylix.nix
      #./nixos/bluetooth.nix
      #./secrets/secrets.nix
      ./secrets/agenix.nix
    ];

  #latest linux kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelParams = [ 
    "amd_pstate=guided"  # Better power management
    "elevator=none"      # Better I/O scheduler for SSDs, Or "mq-deadline"/"bfq" for HDDs
    #"amdgpu.ppfeaturemask=0xffffffff" # Unlock all PowerPlay features
    "amdgpu.gpu_recovery=1"           # Enable GPU recovery
  ];
  services.scx.enable = true;
  services.scx.scheduler = "scx_lavd"; # default is "scx_rustland"
  
  #The kernel can load the correct driver right away:
  boot.initrd.kernelModules = [ "amdgpu" ];
  services.xserver.videoDrivers = [ "amdgpu" ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.systemd.enable = true;
  #boot.loader.timeout = 5;

  # GRUB
  #  boot.loader = {
  #  grub = {
  #    enable = true;
  #    # version = 2;
  #    device = "nodev";
  #    useOSProber = true;
  #    efiSupport = true;
  #    timeoutStyle = "menu";
  #    fontSize = 24;
  #    enableCryptodisk = true;
  #  };
  #  efi = {
  #    canTouchEfiVariables = true;
  #    efiSysMountPoint = "/boot";
  #  };
  #};
  
  # Have a system with small amounts of RAM?
  # zramSwap = {
  #   enable = true;
  #   algorithm = "zstd";
  # };
  
  networking.hostName = "nyxos"; # Define your hostname.
  #networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;
  hardware.bluetooth.enable = true;
  networking.nftables.enable = true;
  networking.networkmanager.wifi.backend = "iwd";

  # implementation of a message bus
  services.dbus.implementation = "broker";
  #Irqbalance is a Linux daemon that distributes interrupts over multiple logical CPUs.
  #This may result in improved overall performance and even reduced power consumption. 
  services.irqbalance.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Kolkata";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_IN";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_IN";
    LC_IDENTIFICATION = "en_IN";
    LC_MEASUREMENT = "en_IN";
    LC_MONETARY = "en_IN";
    LC_NAME = "en_IN";
    LC_NUMERIC = "en_IN";
    LC_PAPER = "en_IN";
    LC_TELEPHONE = "en_IN";
    LC_TIME = "en_IN";
  };

  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  # services.xserver.enable = true;

  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  programs.light.brightnessKeys.enable = true;

  services.desktopManager.plasma6.enable = true;

  services.displayManager.sessionPackages =
   [pkgs.niri]; # for niri to show in sddm
  systemd.packages = [
    pkgs.niri
    pkgs.xwayland-satellite
  ];

  
  # Optimize SSD performance
  services.fstrim.enable = true; # TRIM support for SSDs
  services.smartd.enable = true;

  #services.preload.enable = true; # Preload frequently used applications
  
  #services.displayManager.sessionPackages =
  #  [pkgs.niri]; # for niri to show in sddm

  #services.power-profiles-daemon.enable = true;
  
  # Configure keymap in X11
  #services.xserver = {
  #  xkblayout = "us";
  #  Variant = "";
  #};

  # Enable CUPS to print documents.
  #services.printing.enable = true;
  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.heehaw = {
    isNormalUser = true;
    description = "heehaw";
    extraGroups = [ "networkmanager" "wheel" "video" "input" "dialout" ];
    packages = with pkgs; [
      kdePackages.kate
      mpv
      #  thunderbird
    ];
  };

  # Emacs TODO
  services.emacs = {
    install = true;
    enable = true;
    package = pkgs.emacs-pgtk;
    startWithGraphical = true;
    defaultEditor = true;
  };

  programs.kdeconnect.enable = true;
  programs.fzf.fuzzyCompletion = true;

  hardware.logitech.wireless.enable = true;
  hardware.logitech.wireless.enableGraphical = true;

  services.tailscale = {
    enable = true;
    extraUpFlags = [
      "--ssh"
      "--accept-routes"
    ];
  };

  environment.systemPackages = with pkgs; [ tailscale ];

  networking.firewall = {
    allowedTCPPorts = [
      7777
      28900
      28910
    ];

    allowedTCPPortRanges = [
      {
        from = 27015;
        to = 27030;
      }
      {
        from = 27036;
        to = 27037;
      }
    ];

    allowedUDPPorts = [
      4380
      7777
      27036
      27900
    ];
    allowedUDPPortRanges = [
      {
        from = 27000;
        to = 27036;
      }
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  #nixpkgs.config.allowUnsupportedSystem = true;
  #nixpkgs.config.allowBroken = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  # Activate and set fish shell as default
  users.extraUsers.heehaw = {
    shell = "/run/current-system/sw/bin/fish";
  };

  environment.sessionVariables = {
    DEFAULT_BROWSER = "firefox";
    BROWSER = "firefox";
    EDITOR = "emacs";
    VISUAL = "emacs";
  };
  
  # # TODO https://github.com/openlab-aux/vuizvui/tree/master/modules/user/sternenseemann/profiles
  # # TODO shrink this module by extracting a niri module
  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    wlr.enable = true;
    config = {
      common = {
        default = ["kde" "gnome" "gtk" "wlr"];
      };
    };
    extraPortals = with pkgs; [
      kdePackages.xdg-desktop-portal-kde
      xdg-desktop-portal-wlr
      xdg-desktop-portal-gtk
      xdg-desktop-portal-gnome
    ];
  };

  systemd.user = {
    # pipewire MUST start before niri, otherwise screen sharing doesn't work
    services.pipewire = {
      wantedBy = [ "niri.service" ];
      before = [ "niri.service" ];
    };
  };
  
  #     garbage collection
  nix = {
    settings.auto-optimise-store = true;
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 10d";
    };
  };

  # experimental features flakes enable
  nix = {
    package = pkgs.nixVersions.stable;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  ############### DONT TOUCH ################################
  system.stateVersion = "25.05"; # Did you read the comment?
  ###########################################################
}
