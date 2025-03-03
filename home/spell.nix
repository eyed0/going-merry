{ pkgs, ... }:

{
  home.packages = with pkgs; [
    enchant
    hunspell
    hunspellDicts.en_US
    aspell
    aspellDicts.mr
  ];

# Create the directory structure
  home.file = {
    ".local/share/myspell/dicts/.keep".text = "";
  };
  
  # Configure enchant to use multiple dictionaries
  home.file.".config/enchant/enchant.ordering".text = ''
    *:hunspell,aspell
    mr:aspell,hunspell
  '';
}
