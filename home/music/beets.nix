### music library manager and MusicBrainz tagger
{ pkgs, ...}:

{
  programs.beets = {
    enable = true;
    settings = {
      directory = "~/Music";
      library = "~/Music/library.db";
      import = {
        move = true;                # Move files to music directory
        write = true;               # Write metadata to files
        copy_album_art = true;      # Copy album art to folder
        duplicate_action = "skip";   # Skip duplicate tracks
        timid = true;               # Ask before making any changes
      };
      paths = {
        default = "$albumartist/$album%aunique{}/$track $title";
        singleton = "$artist/Singles/$title";
        comp = "Compilations/$album%aunique{}/$track $title";
		"albumtype:soundtrack" = "Soundtracks/$album ($year)/$track - $title";
      };
	  match = {
        preferred = {
          countries = ["IN" "GB|UK" "US"];  # Prioritize Indian releases
          media = ["CD" "Digital Media"];
        };
        ignore_tags = ["year"];  # Bollywood releases often have conflicting years
      };
      ui = {
        color = true;
        terminal_width = 80;
      };
      plugins = [
        "fetchart"       # Downloads album art
        "lyrics"         # Fetches lyrics
        "lastgenre"      # Gets genres from Last.fm
        "duplicates"     # Finds duplicate tracks
        "missing"        # Reports missing tracks
        "info"          # Shows music file info
        "web"           # Web interface
        "acousticbrainz" # Gets acoustic information
        "badfiles"      # Checks for corrupt files
        "edit"          # Edit metadata in external editor
		"transliterate" # transliteration plugin
		"languages"
      ];
      acousticbrainz.auto = true;
      fetchart = {
        auto = true;
        sources = [
          "filesystem"
          "coverart"    # MusicBrainz Cover Art Archive
          "itunes"
          "amazon"
          "albumart"
        ];
      };
      lastgenre = {
        auto = true;
        count = 3;      # Number of genres to fetch
        fallback = "Unknown";
      };
	  languages = {
        force = false;  # Don't force language detection
        whitelist = ["hi" "en" "mr"];  # Hindi and English
      };
    };
  };

  home.packages = with pkgs; [
  # Core dependencies
  beets
  python3Packages.requests    # For web queries
  python3Packages.pylast      # For Last.fm support
  ];
  
}
