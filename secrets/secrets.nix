
# TODO https://claude.ai/chat/7d4a0325-e86d-45ae-b93b-897c67ec7fc2
let
  heehawage = "age1pk3fx7z36v0j6mwr80773s0pl4fm64l8rs5jyfvt3edh8z5a998s4h8jrt"; # age public key
  
  heehawssh = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINQoPuTUsmKPmOHPOaWfIe/G//LiZTGRez4QGfv1DYUO hpvic";
  
  # Define groups of keys for different purposes
  allKeys = [ heehawage heehawssh ];
in
{
  # Define which keys can decrypt which secrets first and then run "agenix -e secrets/password.age"
  #"secrets/example-secret.age".publicKeys = allKeys;
  #"secrets/another-secret.age".publicKeys = [ heehaw ];
  "secrets/gnc3.age".publicKeys = [ heehawage ];
}
