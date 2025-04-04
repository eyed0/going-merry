let
  heehawage = "age1svrmp2eke0dxq327rvjvgsqshknl2v4hcwg4aqxuqqngunkcu3nqszgs7y"; # Your public key from key.txt.pub
  
  # TODO ssh keys
  
  # Define groups of keys for different purposes
  allKeys = [ heehawage ];
in
{
  # Define which keys can decrypt which secrets
  "secrets/example-secret.age".publicKeys = allKeys;
  #"secrets/another-secret.age".publicKeys = [ heehaw ];
}
