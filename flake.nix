{
  description = "Emilio's darwin system";

  inputs = {
    # Package sets
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixpkgs-23.05-darwin";
    nixpkgs-unstable.url = github:NixOS/nixpkgs/nixpkgs-unstable;
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";

    # Environment/system management
    darwin.url = "github:lnl7/nix-darwin/master";
    darwin.inputs.nixpkgs.follows = "nixpkgs-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs-unstable";

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    tree-sitter-rescript = {
     url = "github:nkrkv/tree-sitter-rescript";
     flake = false;
    };

    nvim-treesitter-rescript = {
     url = "github:nkrkv/nvim-treesitter-rescript";
     flake = false;
    };

    t-smart-tmux-session-manager = { url = "github:joshmedeski/t-smart-tmux-session-manager"; flake = false; };
    rose-pine-tmux = { url = "github:mcanueste/rose-pine-tmux"; flake = false; };

    nixneovimplugins.url ="github:jooooscha/nixpkgs-vim-extra-plugins";
  };

  outputs = { self, darwin, nixpkgs-stable, home-manager, ... }@inputs:
  let 

    inherit (darwin.lib) darwinSystem;
    inherit (inputs.nixpkgs-unstable.lib) attrValues makeOverridable optionalAttrs singleton;

    # Configuration for `nixpkgs`
    nixpkgsConfig = {
      config = { allowUnfree = true; };
      overlays = attrValues self.overlays;
    };
  in
  {
    darwinConfigurations = rec {
      v-mac = darwinSystem {
        system = "x86_64-darwin";
        modules = [ 
          # Main `nix-darwin` config
          ./configuration.nix
          # `home-manager` module
          home-manager.darwinModules.home-manager
          {
            nixpkgs = nixpkgsConfig;
            # `home-manager` config
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.emilio = { imports = [./home]; };
          }
        ];
      };
      mac-studio = darwinSystem {
        system = "aarch64-darwin";
        modules = [ 
          # Main `nix-darwin` config
          ./configuration.nix
          # `home-manager` module
          home-manager.darwinModules.home-manager
          {
            nixpkgs = nixpkgsConfig;
            # `home-manager` config
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.emilio = { imports = [./home]; };
          }
        ];
      };
    };

    # Overlays --------------------------------------------------------------- {{{

    overlays = {
      # Overlays to add various packages into package set

      # Using this to get the latest rescript lsp from the vscode extension
      vscode-extensions = inputs.nix-vscode-extensions.overlays.default;

      # Regularly updated nvim plugins
      neovim-nix = inputs.nixneovimplugins.overlays.default;

      # Overlay useful on Macs with Apple Silicon
        apple-silicon = final: prev: optionalAttrs (prev.stdenv.system == "aarch64-darwin") {
          # Add access to x86 packages system is running Apple Silicon
          pkgs-x86 = import inputs.nixpkgs-unstable {
            system = "x86_64-darwin";
            inherit (nixpkgsConfig) config;
          };
        }; 

        pkgs-stable = _: prev: {
          pkgs-stable = import inputs.nixpkgs-stable {
            inherit (prev.stdenv) system;
            inherit (nixpkgsConfig) config;
          };
        };

        tree-sitter-rescript = final: prev: {
          vimPlugins = prev.vimPlugins.extend (vfinal: vprev: {
            "nvim-treesitter-rescript" = final.vimUtils.buildVimPluginFrom2Nix {
              pname = "nvim-treesitter-rescript";
              version = inputs.nvim-treesitter-rescript.lastModifiedDate;
              src = inputs.nvim-treesitter-rescript;
            };
          });
         tree-sitter-grammars = prev.tree-sitter-grammars  // {
           tree-sitter-rescript = final.tree-sitter.buildGrammar {
              version = inputs.nvim-treesitter-rescript.lastModifiedDate;
              src = inputs.nvim-treesitter-rescript;
              language = "rescript";
              #generate = true;
              location  = "tree-sitter-rescript";
           };
         };
        };
       tmux = final: prev: { 
        tmuxPlugins = prev.tmuxPlugins // {
          t-smart-tmux-session-manager = final.tmuxPlugins.mkTmuxPlugin {
          pluginName = "t-smart-tmux-session-manager";
          rtpFilePath = "t-smart-tmux-session-manager.tmux";
          src = inputs.t-smart-tmux-session-manager;
          version = inputs.t-smart-tmux-session-manager.shortRev;
        };
        rose-pine-tmux = final.tmuxPlugins.mkTmuxPlugin {
          pluginName = "rose-pine-tmux";
          rtpFilePath = "rose-pine-tmux.tmux";
          src = inputs.rose-pine-tmux;
          version = inputs.rose-pine-tmux.shortRev;
        };
      };
      };
    };

 };
}
