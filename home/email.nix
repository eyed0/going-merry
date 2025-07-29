{ config, pkgs, ... }: {

  programs = {
    mu.enable = true;
    msmtp.enable = true;
    mbsync.enable = true;
  };

  programs.neomutt = {
    enable = true;
    
    # Basic settings
    settings = {
      # General settings
      editor = "emacs -nw"; 
      sort = "reverse-date";
      index_format = "%4C %Z %{%b %d} %-15.15L (%?l?%4l&%4c?) %s";
      date_format = "%m/%d";
      
      # Mailbox settings
      mbox_type = "Maildir";
      folder = "~/Mail";  
      spoolfile = "+INBOX";
      record = "+Sent";
      postponed = "+Drafts";
      trash = "+Trash";
      
      # Connection settings
      timeout = 300;
      mail_check = 60;
      
      # Display settings
      markers = false;
      pager_index_lines = 10;
      pager_context = 3;
      pager_stop = true;
      menu_scroll = true;
      tilde = true;
      
      # Composition settings
      edit_headers = true;
      autoedit = true;
      fast_reply = true;
      include = true;
      reply_to = true;
      reverse_name = true;
      
      # Security
      crypt_use_gpgme = true;
      crypt_autosign = false;
      crypt_verify_sig = true;
      crypt_replysign = true;
      crypt_replyencrypt = true;
      crypt_replysignencrypted = true;
    };
    
    # Key bindings
    binds = [
      { map = [ "index" "pager" ]; key = "i"; action = "noop"; }
      { map = [ "index" "pager" ]; key = "g"; action = "noop"; }
      { map = [ "index" ]; key = "gi"; action = "change-folder=+INBOX<enter>"; }
      { map = [ "index" ]; key = "gs"; action = "change-folder=+Sent<enter>"; }
      { map = [ "index" ]; key = "gd"; action = "change-folder=+Drafts<enter>"; }
      { map = [ "index" ]; key = "gt"; action = "change-folder=+Trash<enter>"; }
      { map = [ "index" "pager" ]; key = "R"; action = "group-reply"; }
      { map = [ "index" ]; key = "\\Cn"; action = "toggle-new"; }
      
      # Notmuch bindings
      { map = [ "index" ]; key = "\\"; action = "vfolder-from-query"; }
      { map = [ "index" ]; key = "X"; action = "entire-thread"; }
      
      # Sidebar bindings
      { map = [ "index" "pager" ]; key = "\\Ck"; action = "sidebar-prev"; }
      { map = [ "index" "pager" ]; key = "\\Cj"; action = "sidebar-next"; }
      { map = [ "index" "pager" ]; key = "\\Co"; action = "sidebar-open"; }
      { map = [ "index" "pager" ]; key = "\\Cp"; action = "sidebar-prev-new"; }
      { map = [ "index" "pager" ]; key = "\\Cn"; action = "sidebar-next-new"; }
      { map = [ "index" "pager" ]; key = "B"; action = "sidebar-toggle-visible"; }
    ];
    
    # Macros
    macros = [
      { map = [ "index" ]; key = "S"; action = "<sync-mailbox><shell-escape>mbsync -a<enter><shell-escape>notmuch new<enter>"; }
      { map = [ "index" ]; key = "\\Cs"; action = "<tag-prefix><modify-labels>+spam -inbox -unread<enter><tag-prefix><save-message>+Spam<enter>"; }
    ];

    sidebar = {
      enable = true;
      width = 20;
      format = "%B%?F? [%F]?%* %?N?%N/?%S";
      shortPath = true;
    };
      
  };
  
  # # Enable notmuch
  # programs.notmuch = {
  #   enable = true;
    
  #   # Notmuch configuration
  #   new = {
  #     tags = [ "unread" "inbox" ];
  #     ignore = [ ".mbsyncstate" ".uidvalidity" ];
  #   };
    
  #   search = {
  #     excludeTags = [ "deleted" "spam" ];
  #   };
    
  #   maildir = {
  #     synchronizeFlags = true;
  #   };
    
  #   # Tagging rules
  #   hooks = {
  #     postNew = ''
  #       # Tag all mail from mailing lists
  #       notmuch tag +lists -- from:noreply OR from:no-reply
        
  #       # Tag newsletters
  #       notmuch tag +newsletter -- subject:newsletter OR subject:digest
        
  #       # Tag github notifications
  #       notmuch tag +github -- from:notifications@github.com
        
  #       # Remove inbox tag from sent mail
  #       notmuch tag -inbox -- folder:Sent
        
  #       # Remove inbox tag from drafts
  #       notmuch tag -inbox -- folder:Drafts
        
  #       # Remove inbox tag from trash
  #       notmuch tag -inbox -- folder:Trash
        
  #       # Tag spam
  #       notmuch tag +spam -inbox -unread -- folder:Spam
  #     '';
  #   };
  # };

  # home.packages = with pkgs; [
  #   meson
  # ];
  

  # # unstable nixpkgs branch - mu now does not install mu4e files by default
  # programs.emacs = {
  #   extraPackages = epkgs: [
  #     pkgs.mu
  #   ];
  # };
}
