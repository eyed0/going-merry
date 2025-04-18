{ config, pkgs, ... }:

{
  # TODO https://claude.ai/chat/7d4a0325-e86d-45ae-b93b-897c67ec7fc2

  environment.systemPackages = [ pkgs.agenix ];

  age.identityPaths = [ "~/.config/age/key.txt" ];

  age.secrets.example-secret = {
    file = ./secrets/example-secret.age;
    owner = "heehaw";

    # group = "users";
    # for group Common values include:
    # "users" - the standard users group on most systems
    # "wheel" - administrative users
    # "nginx" - for web server secrets
    # "postgres" - for database secrets
    # group defaults to the primary group of the specified owner

    mode = "0400"; # Read-only by owner
    # Common values mode:
    # "0400" - read-only by owner (most secure for personal secrets)
    # "0440" - read-only by owner and group (for secrets shared with a service)
    # "0444" - read-only by everyone (rarely appropriate for secrets)
    # "0600" - read/write by owner (if the service needs to modify the file)
    # mode defaults to "0400" 
    
  };

  # Use the secret in a service
  # Example: Using the secret as a password file for a service
  services.someService = {
    enable = true;
    passwordFile = config.age.secrets.example-secret.path;
  };
}
