{
  config,
  lib,
  inputs,
  pkgs,
  ...
}:
let
  package = inputs.anyrun.packages.${pkgs.system}.anyrun-with-all-plugins;
in
  {
	imports = [ inputs.anyrun.homeManagerModules.default ];
    programs.anyrun = {
      enable = true;
      package = package;

      config = {
        y.fraction = 0.3;
        plugins = [
          "${package}/lib/libapplications.so"
          "${package}/lib/librink.so"
          "${package}/lib/libshell.so"
          "${package}/lib/libdictionary.so"
          "${package}/lib/libsymbols.so"
          "${package}/lib/libtranslate.so"
        ];
      };
    };
  }
