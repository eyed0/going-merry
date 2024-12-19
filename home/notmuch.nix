{ config, pkgs, ... }:
{
  programs.notmuch = {
    enable = true;
    new.tags = ["new" "inbox"];
    search.excludeTags = ["deleted" "spam"];
    hooks = {
      preNew = ''
        # Sync all Gmail accounts
        for account in ~/Mail/*/; do
          if [ -d "$account" ]; then
            cd "$account"
            gmi sync
          fi
        done
      '';
    };
  };

  home.packages = with pkgs; [
    lieer
  ];

  # Create Mail directory structure
  home.file.".mail-dirs" = {
    target = "Mail";
    recursive = true;
  };
}
