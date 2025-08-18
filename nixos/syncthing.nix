{
  pkgs,
  inputs,
  ...
}: 

{
  services.syncthing = {
    enable = true;
    user = "heehaw";
    dataDir = "/home/heehaw/Sync/";
    #configDir = "~/.config/syncthing/";
    overrideDevices = true;     # Override devices configured in the WebUI
    overrideFolders = true;     # Override folders configured in the WebUI
    
    settings = {
      devices = {
        "device1" = {
          id = "Q4RGQWB-3XSA3T7-MOOREBO-W37MJP7-F2U5HX7-47TZROZ-HEW5MTZ-RLSLOA2";    # Unique device ID for the first device
          name = "Android";  # Friendly name for the device
          address = "dynamic";  # Use dynamic addressing (can be a specific address or dynamic)
          introducer = true;   # Allow this device to introduce new devices
        };
      };
      
      folders = {
        
        "IMP" = {            # Folder ID for the Documents folder
          path = "/home/heehaw/Sync/IMP/";   # Local path to be synchronized
          devices = [ "device1" ];     # Devices to sync this folder with
          ignorePerms = false;     # Do not sync file permissions (set to false to enable)
          rescanIntervalS = 1200;   # How often to rescan the folder (in seconds)
          # maxConflicts = 5;       # Maximum number of conflict files to keep
          # versioning = {
          #   type = "simple";     # Simple versioning mode (other options: "staggered", "trashcan", etc.)
          #   params = {
          #     keep = 5;          # Number of versions to keep in simple versioning
          #   };
          # };
        };
        
        "Photos" = {
          path = "/home/heehaw/Sync/Photos/";
          devices = [ "device1" ];
          ignorePerms = false;
          rescanIntervalS = 1200;
        };
        
        "Whatsapp" = {
          path = "/home/heehaw/Sync/whatsapp";
          devices = [ "device1" ];
          ignorePerms = false;
          rescanIntervalS = 1200;
        };
        
        "songs" = {
          path = "/home/heehaw/00/songs/";
          devices = [ "device1" ];
          ignorePerms = false;
          rescanIntervalS = 1200;
        };
        
        "flakes" = {
          path = "/home/heehaw/flake/";
          devices = [ "device1" ];
          ignorePerms = false;
          rescanIntervalS = 1200;
        };
        
        # "doom" = {
        #   path = "/home/heehaw/.config/doom/";
        #   devices = [ "device1" ];
        #   ignorePerms = false;
        #   rescanIntervalS = 1200;
        # };
        
        "org" = {
          path = "/home/heehaw/org/";
          devices = [ "device1" ];
          ignorePerms = false;
          rescanIntervalS = 1200;
        };
        
		    # "emacsInit" = {
		    #   path = "/home/heehaw/.emacs.d";
		    #   ignorePatterns = [
		    #   	"*"
		    #   	"!/home/heehaw/.emacs.d/init.el"
		    #   	"!/home/heehaw/.emacs.d/early-init.el"
        #     "!/home/heehaw/.emacs.d/configs/**"
		    #   ];
		    #   devices = [ "device1"];
		    #   ignorePerms = false;
		    #   rescanIntervalS = 1200;
		    # };
        
      };
      # options = {
      #   listenAddress = "0.0.0.0:22000";  # Address and port for Syncthing to listen on
      #   globalAnnounce = true;            # Enable global announcement of the device
      #   globalAnnounceIntervalS = 3600;   # How often to announce the device globally
      #   relaysEnabled = true;             # Enable relay connections for devices behind NAT
      #   relays = [ "st-relay.syncthing.net:443" ];  # Relay servers to use
      #   logLevel = "info";                # Log level (options: "debug", "info", "warning", "error")
      # };
    };
  };
}
