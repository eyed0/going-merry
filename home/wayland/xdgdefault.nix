{ config, pkgs, ... }:

{
  xdg.configFile."mimeapps.list".force = true;
  xdg = {
    enable = true;

	  # Configure org-protocol desktop entry
    desktopEntries = {
      org-protocol = {
        name = "Org Protocol";
        exec = "emacsclient %u";
        icon = "emacs";
        type = "Application";
        terminal = false;
        mimeType = ["x-scheme-handler/org-protocol"];
        categories = ["System"];
      };
    };

    mimeApps = {
      enable = true;
      defaultApplications = {

		    # Configure MIME type associations
		    "x-scheme-handler/org-protocol" = [ "org-protocol.desktop" ];
		    
        # Document formats
        "application/pdf" = [ "org.pwmt.zathura.desktop" ];
        "text/plain" = [ "emacs.desktop" ];
        "text/x-markdown" = [ "emacs.desktop" ];
        
        # Web protocols
        "text/html" = [ "firefox.desktop" ];
        "x-scheme-handler/http" = [ "firefox.desktop" ];
        "x-scheme-handler/https" = [ "firefox.desktop" ];
        "x-scheme-handler/about" = [ "firefox.desktop" ];
        "x-scheme-handler/unknown" = [ "firefox.desktop" ];
        "x-scheme-handler/ftp" = [ "firefox.desktop" ];
        
        # Image formats
        "image/jpeg" = [ "org.kde.gwenview.desktop" ];
        "image/png" = [ "org.kde.gwenview.desktop" ];
        "image/gif" = [ "org.kde.gwenview.desktop" ];
        "image/webp" = [ "org.kde.gwenview.desktop" ];
        "image/tiff" = [ "org.kde.gwenview.desktop" ];
        "image/bmp" = [ "org.kde.gwenview.desktop" ];
        "image/x-xcf" = [ "org.kde.gwenview.desktop" ];
        "image/svg+xml" = [ "org.kde.gwenview.desktop" ];
        "image/x-portable-pixmap" = [ "org.kde.gwenview.desktop" ];
        "image/x-portable-bitmap" = [ "org.kde.gwenview.desktop" ];
        "image/vnd.microsoft.icon" = [ "org.kde.gwenview.desktop" ];
        "image/x-icon" = [ "org.kde.gwenview.desktop" ];
        "image/x-xcursor" = [ "org.kde.gwenview.desktop" ];
        "image/heif" = [ "org.kde.gwenview.desktop" ];
        "image/heic" = [ "org.kde.gwenview.desktop" ];
        "image/avif" = [ "org.kde.gwenview.desktop" ];
        
        # Audio formats
        "audio/mpeg" = [ "musikcube.desktop" ];
        "audio/mp3" = [ "musikcube.desktop" ];
        "audio/flac" = [ "musikcube.desktop" ];
        "audio/wav" = [ "musikcube.desktop" ];
        "audio/m4a" = [ "musikcube.desktop" ];
        "audio/ogg" = [ "musikcube.desktop" ];
        "audio/x-vorbis+ogg" = [ "musikcube.desktop" ];
        "audio/aac" = [ "musikcube.desktop" ];
        "audio/x-aac" = [ "musikcube.desktop" ];
        "audio/x-wav" = [ "musikcube.desktop" ];
        "audio/mp4" = [ "musikcube.desktop" ];
        "audio/x-ape" = [ "musikcube.desktop" ];
        "audio/x-ms-wma" = [ "musikcube.desktop" ];
        "audio/x-musepack" = [ "musikcube.desktop" ];
        "audio/x-mod" = [ "musikcube.desktop" ];
        "audio/x-it" = [ "musikcube.desktop" ];
        "audio/x-s3m" = [ "musikcube.desktop" ];
        "audio/x-xm" = [ "musikcube.desktop" ];
        "audio/midi" = [ "musikcube.desktop" ];
        "audio/webm" = [ "musikcube.desktop" ];
        "audio/x-mpegurl" = [ "musikcube.desktop" ];  # M3U playlists
        "audio/x-scpls" = [ "musikcube.desktop" ];    # PLS playlists
        
        # Video formats
        "video/mp4" = [ "mpv.desktop" ];
        "video/x-matroska" = [ "mpv.desktop" ];
        "video/webm" = [ "mpv.desktop" ];
        "video/quicktime" = [ "mpv.desktop" ];
        "video/x-msvideo" = [ "mpv.desktop" ];        # AVI
        "video/x-ms-wmv" = [ "mpv.desktop" ];         # WMV
        "video/x-flv" = [ "mpv.desktop" ];            # Flash Video
        "video/3gpp" = [ "mpv.desktop" ];             # 3GP
        "video/3gpp2" = [ "mpv.desktop" ];            # 3GP2
        "video/x-ogm+ogg" = [ "mpv.desktop" ];        # OGM
        "video/x-theora+ogg" = [ "mpv.desktop" ];     # Theora
        "video/vnd.mpegurl" = [ "mpv.desktop" ];      # M3U8/HLS
        "video/x-m4v" = [ "mpv.desktop" ];            # M4V
        "video/mpeg" = [ "mpv.desktop" ];             # MPEG
        "video/mp2t" = [ "mpv.desktop" ];             # MPEG-TS
        "video/x-yuv4mpeg" = [ "mpv.desktop" ];       # YUV4MPEG
        
        # File manager
        "inode/directory" = [ "org.kde.dolphin.desktop" ];
        "application/x-gnome-saved-search" = [ "org.kde.dolphin.desktop" ];
      };
      
      associations.added = {
        "application/pdf" = [ "firefox.desktop" ];
      };
    };
  };

  # Ensure the applications are installed
  home.packages = with pkgs; [
	  zathura
	  xdg-utils
  ];

  # xdg.userDirs = {
  #   enable = true;
  #   createDirectories = true;
  #   documents = "$HOME/Documents";
  #   download = "$HOME/Downloads";
  #   pictures = "$HOME/Pictures";
  #   videos = "$HOME/Videos";
  #   music = "$HOME/Music";
  # };

  # programs.plasma = {
  #   enable = true;
  # };
}
