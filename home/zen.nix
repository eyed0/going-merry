{inputs, ...}: {
  imports = [inputs.zen-browser.homeModules.beta];
  programs.zen-browser = {
    enable = true;
    
    policies = {
      # Existing policies
      AutofillAddressEnabled = false;
      AutofillCreditCardEnabled = false;
      DisableAppUpdate = true;
      DisableFeedbackCommands = true;
      DisablePocket = true;
      DNSOverHTTPS = {
        Enabled = false;
        Locked = true;
      };
      DontCheckDefaultBrowser = true;
      EnableTrackingProtection = {
        Value = true;
        Locked = true;
        Cryptomining = true;
        Fingerprinting = true;
      };
      NoDefaultBookmarks = true;
      OfferToSaveLogins = false;
      
      # Additional privacy policies
      DisableSystemAddonUpdate = true;
      DisableProfileImport = true;
      DisableProfileRefresh = true;
      DisableCrashReporter = true;
      BlockAboutAddons = false;
      BlockAboutConfig = false;
      BlockAboutProfiles = false;
      BlockAboutSupport = false;
      DisableSecurityBypass = {
        InvalidCertificate = true;
        SafeBrowsing = true;
      };
      
      # Enhanced tracking protection
      Cookies = {
        Default = "reject-tracker-and-partition-foreign";
        AcceptThirdParty = "never";
        RejectTracker = true;
        Locked = true;
      };
      
      # Disable various Firefox services
      DisableFirefoxAccounts = true;
      DisableFirefoxScreenshots = true;
      DisableForgetButton = false; # Keep this for privacy
      DisableFormHistory = true;
      DisableMasterPasswordCreation = false; # Allow if you want master passwords
      DisableSetDesktopBackground = true;
      
      # Network policies
      NetworkPrediction = false;
      
      # Homepage and new tab
      Homepage = {
        URL = "about:blank";
        Locked = false;
        StartPage = "homepage";
      };
      NewTabPage = false;
      
      # Search settings
      SearchSuggestEnabled = false;
      
      # Download behavior
      DownloadDirectory = "\${home}/Downloads";
      PromptForDownloadLocation = false;
      
      # Security policies
      EncryptedMediaExtensions = {
        Enabled = false; # Disable DRM if not needed
        Locked = true;
      };
      
      # Permissions
      Permissions = {
        Camera = {
          BlockNewRequests = true;
          Locked = true;
        };
        Microphone = {
          BlockNewRequests = true;
          Locked = true;
        };
        Location = {
          BlockNewRequests = true;
          Locked = true;
        };
        Notifications = {
          BlockNewRequests = true;
          Locked = true;
        };
        Autoplay = {
          Default = "block-audio-video";
          Locked = true;
        };
      };
      
      # Content blocking
      WebsiteFilter = {
        Block = [
          "*://*.doubleclick.net/*"
          "*://*.googleadservices.com/*"
          "*://*.googlesyndication.com/*"
          "*://*.facebook.com/tr/*"
        ];
      };
      
      # Extensions
      ExtensionSettings = {
        # Bitwarden Password Manager
        "{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/file/4307738/bitwarden_password_manager-2024.6.3.xpi";
          installation_mode = "force_installed";
        };
        
        # uBlock Origin
        "uBlock0@raymondhill.net" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
          installation_mode = "force_installed";
        };
        
        # SponsorBlock
        "sponsorBlocker@ajay.app" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/sponsorblock/latest.xpi";
          installation_mode = "force_installed";
        };
        
        # YouTube High Definition
        "{7b1bf0b6-a1b9-42b0-b75d-252036438bdc}" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/youtube-high-definition/latest.xpi";
          installation_mode = "force_installed";
        };
        
        # Web Capture (Org mode)
        "org-capture@cam.github.io" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/org-web-capture/latest.xpi";
          installation_mode = "force_installed";
        };
        
        # Consent-O-Matic
        "gdpr@cavi.au.dk" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/consent-o-matic/latest.xpi";
          installation_mode = "force_installed";
        };
        
        # Tampermonkey
        "{22671e08-06b4-4ac1-82d8-9cd4b9b8c69d}" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/tampermonkey/latest.xpi";
          installation_mode = "force_installed";
        };
        
        # Video Resumer
        "{70e0b9b8-9b03-44c8-8cda-0a6b32a6c9c7}" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/video-resumer/latest.xpi";
          installation_mode = "force_installed";
        };
      };
      
      };
  };
}
