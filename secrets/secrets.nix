
# TODO https://claude.ai/chat/7d4a0325-e86d-45ae-b93b-897c67ec7fc2
let
  heehawage = "age1svrmp2eke0dxq327rvjvgsqshknl2v4hcwg4aqxuqqngunkcu3nqszgs7y"; # Your public key from key.txt.pub
  
  # TODO ssh keys
  
  # Define groups of keys for different purposes
  allKeys = [ heehawage ];
in
{
  # Define which keys can decrypt which secrets TODO
  #"secrets/example-secret.age".publicKeys = allKeys;
  #"secrets/another-secret.age".publicKeys = [ heehaw ];
}
