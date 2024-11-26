{ pkgs, inputs, ... }:

{

  imports = [
    inputs.anyrun.homeManagerModules.default
  ];
  
  programs.anyrun = {
    enable = true;
    config = {
      plugins = with inputs.anyrun.packages.${pkgs.system}; [
        applications
        shell
        symbols
        websearch
      ];
      
      width.fraction = 0.3;
      #y.absolute = 15;
      hidePluginInfo = true;
      closeOnClick = true;
      
      # Wayland specific settings
      layer = "overlay";
      hideIcons = false;
      ignoreExclusiveZones = false;
      showResultsImmediately = true;
      maxEntries = 10;
      
      # Advanced window positioning
      x.fraction = 0.5;
      y.fraction = 0.0;
      #verticalOffset = 10;
      #horizontalOffset = 0;
      #hideOnAction = true;
    };

    # Kanagawa Wave styling (preserved from previous config)
    extraCss = ''
      * {
        transition: 200ms ease;
        font-family: "PragmataProLiga Nerd Font";
        font-size: 1.1rem;
      }

      #window {
        background: transparent;
      }

      #entry {
        padding: 0.75rem;
        border-radius: 0.75rem;
        background: rgba(31, 31, 40, 0.95);  /* Kanagawa sumiInk0 */
        color: #DCD7BA;  /* Kanagawa fujiWhite */
        margin: 0.2rem;
      }

      #entry:selected {
        background: rgba(54, 54, 70, 0.95);  /* Kanagawa sumiInk3 */
        border: 2px solid #7E9CD8;  /* Kanagawa crystalBlue */
      }

      #input {
        padding: 0.75rem;
        margin: 0.5rem;
        border-radius: 0.75rem;
        border: 2px solid #2D4F67;  /* Kanagawa winterGreen */
        background: rgba(31, 31, 40, 0.95);  /* Kanagawa sumiInk0 */
        color: #DCD7BA;  /* Kanagawa fujiWhite */
      }

      #input:focus {
        border-color: #7E9CD8;  /* Kanagawa crystalBlue */
      }

      #plugin {
        margin: 0.5rem 0;
        padding: 0.75rem;
        color: #C8C093;  /* Kanagawa oldWhite */
      }

      box#main {
        background: rgba(31, 31, 40, 0.95);  /* Kanagawa sumiInk0 */
        border-radius: 1rem;
        padding: 0.5rem;
        border: 2px solid #2D4F67;  /* Kanagawa winterGreen */
      }

      #match {
        color: #7E9CD8;  /* Kanagawa crystalBlue */
        font-weight: bold;
      }

      #description {
        color: #957FB8;  /* Kanagawa oniViolet */
      }
    '';

    extraConfigFiles = {
      "applications.ron".text = ''
        Config(
          desktop_actions: true,
          max_entries: 10,
          terminal: Some("foot"),
          calculate_score: true,
          ignore_case: true,
        )
      '';
      
      "websearch.ron".text = ''
        Config(
          prefix: "?",
          engines: [
            Engine(
              name: "DuckDuckGo",
              url: "https://duckduckgo.com/?q={}",
              icon: None,
            ),
            Engine(
              name: "?nw",
              url: "https://wiki.nixos.org/wiki/Special:Search?search={}",
              icon: None,
            ),
            Engine(
              name: "?mn",
              url: "https://mynixos.com/search?q={}",
              icon: None,
            ),
            Engine(
              name: "?np",
              url: "https://search.nixos.org/packages?query={}",
              icon: None,
            ),
            Engine(
              name: "?no",
              url: "https://search.nixos.org/options?query={}",
              icon: None,
            ),
            Engine(
              name: "?yt",
              url: "https://www.youtube.com/results?search_query={}",
              icon: None,
            ),
          ]
        )
      '';
      
      "symbols.ron".text = ''
        Config(
          prefix: ":",
          symbols: {
        // Emoticons
        "shrug": "¯\\_(ツ)_/¯",
        "flip": "(╯°□°)╯︵ ┻━┻",
        "unflip": "┬─┬ノ(º_ºノ)",
        "lenny": "( ͡° ͜ʖ ͡°)",
        "happy": "(◕‿◕)",
        "sad": "(´;︵;`)",
        "angry": "(╬ಠ益ಠ)",
        "cry": "(╥﹏╥)",
        "cool": "(⌐■_■)",
        "dance": "♪┏(・o･)┛♪┗ ( ･o･) ┓♪",
        "magic": "(∩｀-´)⊃━☆ﾟ.*･｡ﾟ",
        "bear": "ʕ•ᴥ•ʔ",
        "cat": "(=^･ω･^=)",
        "dog": "(˙ᴥ˙)",
        "bird": "(･Θ･)",
        "fish": "><(((º>",
        "sword": "o==[]::::::::::::::::>",
        "love": "(｡♥‿♥｡)",
        "party": "(づ￣ ³￣)づ",
        "rage": "(┛◉Д◉)┛彡┻━┻",
        "sleep": "(－_－) zzZ",
        "think": "(¬‿¬)",
        "hug": "(づ｡◕‿‿◕｡)づ",
        "bye": "(｡◕‿◕｡)ﾉ",
		
        // Special Characters
        "copyright": "©",
        "registered": "®",
        "trademark": "™",
        "section": "§",
        "paragraph": "¶",
        "at": "@",
        "ampersand": "&",
        "ellipsis": "…",
        "em-dash": "—",
        "en-dash": "–",
          },
        )
      '';
            
      "shell.ron".text = ''
        Config(
          prefix: "$",
          shell: "fish",
          max_entries: 10,
          save_history: true,
          history_file: ".anyrun-shell-history",
          workdir: None,
        )
      '';

    };
  };

  # # Ensure all required packages are installed
  # home.packages = with inputs.anyrun.packages.${pkgs.system}; [
  #   anyrun
  #   anyrun-plugins.applications
  #   anyrun-plugins.rink
  #   anyrun-plugins.shell
  #   anyrun-plugins.symbols
  #   anyrun-plugins.websearch
  #   anyrun-plugins.kidex
  #   anyrun-plugins.dictionary
  #   anyrun-plugins.randr
  #   anyrun-plugins.stdin
  # ];
}
