{
  config, ...
}:

{
  programs.jujutsu.enable = true;
  programs.jujutsu.ediff = config.programs.emacs.enable;
  programs.jujutsu.settings = {
  user = {
    email = "nldeshmukh000@gmail.com";
    name = "heehaw";
  };
};
}
