{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    hledger
    (python313.withPackages (ps: with ps; [ pdfplumber pandas fuzzywuzzy levenshtein ]))
    R
    # R packages we'll need
    rPackages.tidyverse
    rPackages.lubridate
    rPackages.plotly
    rPackages.DT
    rPackages.forecast
    rPackages.changepoint
    rPackages.VIM  # for missing value visualization
    rPackages.corrplot
    rPackages.gridExtra
  ];
}
