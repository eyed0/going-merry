{ config, pkgs, ... }:

let
  pythonOverlay = final: prev: {
    python313 = prev.python313.override {
      packageOverrides = self: super: {

        # Disable tests *and* ensure pandas is present for the import check
        pandas-stubs = super.pandas-stubs.overridePythonAttrs (old: {
          doCheck       = false;
          doInstallCheck = false;
          checkPhase    = "";
          # Add pandas to the inputs so import pandas works
          propagatedBuildInputs = (old.propagatedBuildInputs or []) ++ [ super.pandas ];
        });

        # Disable tests for pdfplumber (it should find pandas from the main env)
        pdfplumber = super.pdfplumber.overridePythonAttrs (old: {
          doCheck    = false;
          checkPhase = "";
        });
      };
    };
  };
in
{
  nixpkgs.overlays = [ pythonOverlay ];

  home.packages = with pkgs; [
    hledger
    (python313.withPackages (ps: with ps; [
      pdfplumber
      pandas
      fuzzywuzzy
      levenshtein
    ]))
    R
    rPackages.tidyverse
    rPackages.lubridate
    rPackages.plotly
    rPackages.DT
    rPackages.forecast
    rPackages.changepoint
    rPackages.VIM
    rPackages.corrplot
    rPackages.gridExtra
  ];
}
