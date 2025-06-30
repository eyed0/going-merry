{ pkgs, ... }:
{
  programs.firefox = {
    enable = true;
    policies = {
      ExtensionSettings = {
        "*".installation_mode = "blocked";
        "jid1-MnnxcxisBPnSXQ@jetpack" = {
          install_url = "https://addons.mozilla.org/en-US/firefox/downloads/latest/privacy-badger17/latest.xpi";
          installation_mode = "force_installed";
        };

        "sponsorBlocker@ajay.app" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/sponsorblock/latest.xpi";
          installation_mode = "force_installed";
        };

        "uBlock0@raymondhill.net" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
          installation_mode = "force_installed";
        };

        "jid1-BoFifL9Vbdl2zQ@jetpack" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/decentraleyes/latest.xpi";
          installation_mode = "force_installed";
        };

        "gdpr@cavi.au.dk" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/consent-o-matic/latest.xpi";
          installation_mode = "force_installed";
        };

        "org-protocol@emacsorphanage.github.com" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/org-protocol/latest.xpi";
          installation_mode = "force_installed";
        };

        "video-resumer@dallaslu.com" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/video-resumer/latest.xpi";
          installation_mode = "force_installed";
        };

        "CookieAutoDelete@kennydo.com" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/cookie-autodelete/latest.xpi";
          installation_mode = "force_installed";
        };

        "{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/bitwarden-password-manager/latest.xpi";
          installation_mode = "force_installed";
        };

        "{3c078156-979c-498b-8990-85f7987dd929}" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/sidebery/latest.xpi";
          installation_mode = "force_installed";
        };
      };
      DisableTelemetry = true;
      DisableFirefoxStudies = true;
      EnableTrackingProtection = {
        Value = true;
        Locked = true;
        Cryptomining = true;
        Fingerprinting = true;
      };
      DisablePocket = true;
      DontCheckDefaultBrowser = true;
      DisplayBookmarksToolbar = "never";
      DisplayMenuBar = "never";
      SearchBar = "unified";
      SecurityDevices = {
        Add = {
          "OpenSC PKCS#11" = "${pkgs.opensc}/lib/opensc-pkcs11.so";
        };
      };
    };
    profiles.default = {
      search = {
        force = true;
        engines = {
          "Amazon.com".metaData.hidden = true;
          "Bing".metaData.hidden = true;
          "eBay".metaData.hidden = true;
          "DuckDuckGo" = {
            urls = [
              {
                template = "https://duckduckgo.com";
                params = [
                  {
                    name = "q";
                    value = "{searchTerms}";
                  }
                ];
              }
            ];
            definedAliases = [ ",d" ];
          };
          "Google" = {
            urls = [
              {
                template = "https://google.com/search";
                params = [
                  {
                    name = "q";
                    value = "{searchTerms}";
                  }
                ];
              }
            ];
            definedAliases = [ ",g" ];
          };
          "Home Manager Options" = {
            urls = [
              {
                template = "https://mipmip.github.io/home-manager-option-search/";
                params = [
                  {
                    name = "query";
                    value = "{searchTerms}";
                  }
                ];
              }
            ];
            definedAliases = [ "ho" ];
          };
          "Nix Packages" = {
            urls = [
              {
                template = "https://search.nixos.org/packages";
                params = [
                  {
                    name = "type";
                    value = "packages";
                  }
                  {
                    name = "query";
                    value = "{searchTerms}";
                  }
                ];
              }
            ];
            definedAliases = [ "np" ];
          };
          "YouTube" = {
            urls = [
              {
                template = "https://www.youtube.com/results";
                params = [
                  {
                    name = "search_query";
                    value = "{searchTerms}";
                  }
                ];
              }
            ];
            definedAliases = [ "y" ];
          };
          "Wikipedia" = {
            urls = [
              {
                template = "https://en.wikipedia.org/wiki/Special:Search";
                params = [
                  {
                    name = "search";
                    value = "{searchTerms}";
                  }
                ];
              }
            ];
            definedAliases = [ "wik" ];
          };
          "DockerHub" = {
            urls = [
              {
                template = "https://hub.docker.com/search";
                params = [
                  {
                    name = "q";
                    value = "{searchTerms}";
                  }
                ];
              }
            ];
            definedAliases = [ "dh" ];
          };
          "GitHub" = {
            urls = [
              {
                template = "https://github.com/search";
                params = [
                  {
                    name = "q";
                    value = "{searchTerms}";
                  }
                ];
              }
            ];
            definedAliases = [ "gh" ];
          };
        };
        default = "DuckDuckGo";
      };
      id = 0;
      # userChrome and userContent CSS files
      userChrome = builtins.readFile ./userChrome.css;
      userContent = builtins.readFile ./userContent.css;
      
      settings = {
        # Basic settings
        "app.update.auto" = true;
        "dom.security.https_only_mode" = true;
        "extensions.pocket.enabled" = false;
        "browser.quitShortcut.disabled" = true;
        "browser.download.panel.shown" = true;
        "signon.rememberSignons" = false;
        "app.shield.optoutstudies.enabled" = false;
        "browser.shell.checkDefaultBrowser" = false;
        "browser.bookmarks.restore_default_bookmarks" = false;
        "browser.startup.page" = 3;
        "general.autoScroll" = true;
        "startup.homepage_welcome_url" = "";
        "browser.newtabpage.enabled" = false;
        "full-screen-api.ignore-widgets" = true;
        "browser.toolbars.bookmarks.visibility" = "never";
        "browser.aboutConfig.showWarning" = false;
        "media.videocontrols.picture-in-picture.video-toggle.enabled" = true;

        # Enhanced Privacy Settings
        "privacy.trackingprotection.enabled" = true;
        "privacy.trackingprotection.socialtracking.enabled" = true;
        "privacy.trackingprotection.cryptomining.enabled" = true;
        "privacy.trackingprotection.fingerprinting.enabled" = true;
        "privacy.donottrackheader.enabled" = true;
        "privacy.resistFingerprinting" = true;
        "privacy.resistFingerprinting.letterboxing" = true;
        "privacy.spoof_english" = 2; # spoof locale to en-US
        "privacy.clearOnShutdown.cache" = true;
        "privacy.clearOnShutdown.cookies" = false; # keep for login persistence
        "privacy.clearOnShutdown.downloads" = true;
        "privacy.clearOnShutdown.formdata" = true;
        "privacy.clearOnShutdown.history" = false; # keep for convenience
        "privacy.clearOnShutdown.sessions" = false; # keep for tab restoration
        "privacy.sanitize.sanitizeOnShutdown" = true;
        
        # Network Privacy
        "network.dns.disablePrefetch" = true;
        "network.dns.disablePrefetchFromHTTPS" = true;
        "network.predictor.enabled" = false;
        "network.prefetch-next" = false;
        "network.http.speculative-parallel-limit" = 0;
        "browser.urlbar.speculativeConnect.enabled" = false;
        "network.trr.mode" = 2; # enable DNS over HTTPS
        "network.trr.uri" = "https://mozilla.cloudflare-dns.com/dns-query";
        
        # Geolocation and sensors
        "geo.enabled" = false;
        "permissions.default.geo" = 2;
        "device.sensors.enabled" = false;
        "dom.battery.enabled" = false;
        
        # WebRTC privacy
        "media.peerconnection.enabled" = false; # disable WebRTC entirely
        "media.peerconnection.ice.default_address_only" = true;
        "media.peerconnection.ice.no_host" = true;
        
        # Referrer policy
        "network.http.referer.XOriginPolicy" = 2; # strict cross-origin referrer
        "network.http.referer.XOriginTrimmingPolicy" = 2;
        
        # Enhanced UX Settings
        "browser.download.useDownloadDir" = false; # always ask where to save
        "browser.download.alwaysOpenPanel" = false; # don't auto-open download panel
        "browser.urlbar.suggest.searches" = false; # disable search suggestions in urlbar
        "browser.urlbar.suggest.topsites" = false; # disable top sites in urlbar
        "browser.urlbar.shortcuts.bookmarks" = false; # disable bookmark shortcuts
        "browser.urlbar.shortcuts.tabs" = false; # disable tab shortcuts
        "browser.urlbar.shortcuts.history" = false; # disable history shortcuts
        "browser.urlbar.maxRichResults" = 5; # limit urlbar suggestions
        "browser.backspace_action" = 0; # backspace goes back in history
        "browser.tabs.insertRelatedAfterCurrent" = true; # new tabs next to current
        "browser.tabs.selectOwnerOnClose" = true; # return to parent tab when closing
        "browser.sessionstore.restore_pinned_tabs_on_demand" = true; # lazy load pinned tabs
        "browser.sessionstore.restore_tabs_lazily" = true; # lazy load tabs
        
        # Interface improvements
        "browser.tabs.tabMinWidth" = 80; # minimum tab width
        "browser.uidensity" = 1; # compact UI density
        "layout.css.prefers-color-scheme.content-override" = 0; # respect system dark mode
        "browser.in-content.dark-mode" = true; # dark mode for internal pages
        "devtools.theme" = "dark"; # dark devtools theme
        
        # Performance tweaks
        "gfx.webrender.all" = true; # enable WebRender
        "layers.acceleration.force-enabled" = true; # force hardware acceleration
        "media.hardware-video-decoding.force-enabled" = true;
        "browser.cache.disk.enable" = true;
        "browser.cache.memory.enable" = true;
        "browser.sessionhistory.max_entries" = 10; # limit session history
        
        # Security enhancements
        "security.tls.version.min" = 3; # minimum TLS 1.2
        "security.ssl.require_safe_negotiation" = true;
        "security.OCSP.enabled" = 1;
        "security.mixed_content.block_active_content" = true;
        "security.mixed_content.block_display_content" = true;
        "dom.security.https_first" = true; # HTTPS-First mode
        "security.insecure_connection_text.enabled" = true; # warn about HTTP
        
        # JavaScript hardening
        "javascript.options.wasm" = false; # disable WebAssembly for security
        "dom.event.clipboardevents.enabled" = false; # prevent clipboard access
        "dom.webnotifications.enabled" = false; # disable web notifications
        "permissions.default.desktop-notification" = 2; # block notifications
        
        # Form and password management
        "signon.autofillForms" = false; # disable form autofill
        "signon.generation.enabled" = false; # disable password generation
        "extensions.formautofill.addresses.enabled" = false;
        "extensions.formautofill.creditCards.enabled" = false;

        "browser.discovery.enabled" = false;
        "browser.search.suggest.enabled" = false;
        "browser.contentblocking.category" = "custom";
        "dom.private-attribution.submission.enabled" = false;
        "browser.protections_panel.infoMessage.seen" = true;

        "toolkit.telemetry.enabled" = false;
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        "svg.context-properties.content.enabled" = true;
        "toolkit.telemetry.unified" = false;
        "browser.ping-centre.telemetry" = false;
        "toolkit.telemetry.archive.enabled" = false;
        "toolkit.telemetry.bhrPing.enabled" = false;
        "toolkit.telemetry.updatePing.enabled" = false;
        "browser.translations.automaticallyPopup" = false;
        "toolkit.telemetry.hybridContent.enabled" = false;
        "toolkit.telemetry.newProfilePing.enabled" = false;
        "toolkit.telemetry.reportingpolicy.firstRun" = false;
        "toolkit.telemetry.firstShutdownPing.enabled" = false;
        "browser.newtabpage.activity-stream.telemetry" = false;
        "toolkit.telemetry.shutdownPingSender.enabled" = false;
        "browser.newtabpage.activity-stream.feeds.telemetry" = false;

        "browser.tabs.loadInBackground" = true;
        "browser.tabs.loadBookmarksInTabs" = true;
        "browser.tabs.warnOnOpen" = false;
        "browser.tabs.warnOnQuit" = false;
        "browser.tabs.warnOnClose" = false;
        "browser.tabs.loadDivertedInBackground" = false;
        "browser.tabs.warnOnCloseOtherTabs" = false;
        "browser.tabs.closeWindowWithLastTab" = false;

        "media.autoplay.default" = 0;
        "devtools.toolbox.host" = "right";
        "media.rdd-vpx.enabled" = true;
        "devtools.cache.disabled" = true;
        "media.ffmpeg.vaapi.enabled" = true;

        "browser.link.open_newwindow.restriction" = 0;
        "browser.fixup.domainsuffixwhitelist.home" = true;
        "browser.fixup.domainwhitelist.server.home" = true;
      };
    };
  };
}
