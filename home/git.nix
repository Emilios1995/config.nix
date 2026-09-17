{ pkgs, lib, ...}:

{

  programs.git = {
    enable = true;
    lfs.enable = true;


    settings = {
      user = {
        email = "emilios1995@gmail.com";
        name = "Emilio Srougo";
      };
      alias = {
        dft = "difftool";
      };
      credential.helper = 
        if pkgs.stdenvNoCC.hostPlatform.isDarwin then 
          "osxkeychain"
        else
          "cache --timeout=1000000000";
      core = {
        editor = "nvim";
        ignorecase = false;
      };
      rerere.enabled = true;
      push = {
        default = "simple";
        followTags = true;
      };
      apply.whitespace = "nowarn";
      
      url = {
        "https://github.com/" = { insteadOf = "gh:"; };
        "ssh://git@github.com/" = { insteadOf = "sgh:"; };
      };
      init.defaultBranch = "master";
      diff = {
        tool = "difftastic";
      };

      difftool = {
        prompt = false;

        difftastic = {
          cmd = ''difft "$LOCAL" "$REMOTE"'';
        };
      };

      pager = {
        difftool = true;
      };

      blame = {
        # can't set globally since it would break git blame if the file is missing
        #ignoreRevsFile = ".git-blame-ignore-revs";
        # Mark any lines that have had a commit skipped using --ignore-rev with a `?`
        markIgnoredLines = true;
        # Mark any lines that were added in a skipped commit and can not be attributed with a `*`
        markUnblamableLines = true;
      };

      http.postBuffer = 524288000;

    };
    ignores = [
      ".DS_STORE"
      ".DS_Store"
      "*~"
      "*.bak"
      "*.log"
      "*.swp"
      "node_modules"
      ".direnv/"
      ".vim-bookmarks"
      ".devenv/"
      ".aider*"
    ];
  };

  programs.delta = {
    enable = true;
    enableGitIntegration = true;
    options = {
      dark = false;
      syntax-theme = "Solarized (light)";
    };
  };

  programs.gh.enable = true;
  programs.gh.settings.git_protocol = "ssh";


  programs.lazygit = {
    enable = true;
    settings = {
      git.diffRenderers = [
        {
          colorArg = "always";
          command = "delta --syntax-theme OneHalfLight --paging=never";
        }
      ];
    };
  };

  home.packages = with pkgs; [difftastic];

}
