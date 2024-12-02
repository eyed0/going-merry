{ pkgs, ... }:

{
  home.packages = with pkgs; [
    enchant
    hunspell
    hunspellDicts.en_US
    # Add Hindi dictionary
    hunspellDicts.hi_IN
    # For Marathi, we'll need to manually add dictionary files
    aspell
    aspellDicts.mr
  ];

  # Create directories for additional dictionaries
  home.file.".local/share/myspell/dicts".recursive = true;

  # Configure enchant to use multiple dictionaries
  home.file.".config/enchant/enchant.ordering".text = ''
    *:hunspell,aspell
    hi:hunspell,aspell
    mr:aspell,hunspell
  '';
}
