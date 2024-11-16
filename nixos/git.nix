{
  pkgs, inputs, config, ...
}: 
{
  programs.git = {
    enable = true;
	config = {
	  init = {
        defaultBranch = "main";
      };

	  user = {
		name = "heehaw";
		email = "nldeshmukh000@gmail.com";
	  };

	  core = {
		editor = "emacs";
		whitespace = "fix,-indent-with-non-tab,trailing-space,cr-at-eol";
		pager = "delta";
		#compression = 9;
	  };

	  push = {
		followTags = "true";
		#autoSetupRemote = "true";
		default = "simple";
	  };

	  merge = {
		# Add summary of changes
		summary = "true";
		# Show common ancestor in conflicts
		verbosity = 2;
		# Create backup files
		backup = "true";
	  };

	  rerere = {
		enabled = "true";
	  };

	  status = {
		# Show short status by default
		short = "true";
		# Show branch info
		branch = "true";
		# Show submodule changes
		submoduleSummary = "true";
	  };
	  
	};
	
  };
  services.openssh.enable = true;
  programs.lazygit.enable = true;
}
