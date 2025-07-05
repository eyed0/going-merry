
# this file is only for agenix to use dont import it into nix config
let
  heehawage = "age1pk3fx7z36v0j6mwr80773s0pl4fm64l8rs5jyfvt3edh8z5a998s4h8jrt"; # age public key
    
  # Define groups of keys for different purposes
  allKeys = [ heehawage ];
in
{
  # Define which keys can decrypt which secrets first and then run "agenix -e secrets/password.age"
  #"secrets/example-secret.age".publicKeys = allKeys;
  #"secrets/another-secret.age".publicKeys = [ heehaw ];
  "secrets/gnc3.age".publicKeys = allKeys;
}
