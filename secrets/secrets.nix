{ config, pkgs, ... }:

{
  environment.systemPackages = [ 
    pkgs.age
    config.inputs.agenix.packages.${pkgs.system}.default
  ];
  
  # Basic agenix configuration
  age = {
    identityPaths = [ "/home/heehaw/.ssh/id_ed25519" ];
  };
}
