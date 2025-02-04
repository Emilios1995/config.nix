{
  description = "Emilio's darwin system";

  inputs = {
    # Package sets
    nixpkgs-23-11.url = "github:nixos/nixpkgs/nixpkgs-23.11-darwin";
    nixpkgs-23-05.url = "github:nixos/nixpkgs/nixpkgs-23.05-darwin";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";

    # Environment/system management
    darwin.url = "github:lnl7/nix-darwin/master";
    darwin.inputs.nixpkgs.follows = "nixpkgs-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs-unstable";

    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs-unstable";
    agenix.inputs.darwin.follows = "darwin";

    tree-sitter-rescript = {
     url = "flake:local-tree-sitter-rescript";
     flake = false;
    };

    tree-sitter-tailwind = {
     url = "git+ssh://git@github.com/Emilios1995/tree-sitter-tailwind?ref=main";
    };

    sg-nvim.url = "github:sourcegraph/sg.nvim";


    t-smart-tmux-session-manager = { url = "github:joshmedeski/t-smart-tmux-session-manager"; flake = false; };
    rose-pine-tmux = { url = "github:mcanueste/rose-pine-tmux"; flake = false; };

    nixneovimplugins.url ="github:jooooscha/nixpkgs-vim-extra-plugins";

    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";

    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, darwin, nixpkgs-23-05, nixpkgs-23-11, home-manager, agenix, flake-utils, ... }@inputs:
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
          agenix.darwinModules.default
          {
            nixpkgs = nixpkgsConfig;
            # `home-manager` config
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.emilio = { imports = [./home]; };
          }
        ];
      };
      emilios-mac-studio = darwinSystem {
        system = "aarch64-darwin";
        modules = [ 
          agenix.darwinModules.default
          # Main `nix-darwin` config
          ./configuration.nix
          { networking.hostName = "emilios-mac-studio"; }
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
      emilios-macbook-pro = darwinSystem {
        system = "x86_64-darwin";
        modules = [ 
          agenix.darwinModules.default
          # Main `nix-darwin` config
          ./configuration.nix
          { networking.hostName = "emilios-macbook-pro"; }
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

    # Overlays --------------------------------------------------------------- 

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

        pkgs-23-11 = _: prev: {
          pkgs-23-11 = import inputs.nixpkgs-23-11 {
            inherit (prev.stdenv) system;
            inherit (nixpkgsConfig) config;
          };
        };

        pkgs-23-05 = _: prev: {
          pkgs-23-05 = import inputs.nixpkgs-23-05 {
            inherit (prev.stdenv) system;
            inherit (nixpkgsConfig) config;
          };
        };

       tree-sitter-tailwind = final: prev: {
          tree-sitter-tailwind = inputs.tree-sitter-tailwind.packages.${prev.system}.default;
        };

        nvim = final: prev: {
          vimPlugins = prev.vimPlugins.extend (vfinal: vprev: {
             "tree-sitter-rescript" = final.vimUtils.buildVimPluginFrom2Nix {
               pname = "tree-sitter-rescript";
               version = inputs.tree-sitter-rescript.lastModifiedDate;
               src = inputs.tree-sitter-rescript;
             };
            sg-nvim = inputs.sg-nvim.packages.${prev.system}.sg-nvim;  
        });

         tree-sitter-grammars = prev.tree-sitter-grammars  // {
           tree-sitter-rescript = final.tree-sitter.buildGrammar {
              version = inputs.tree-sitter-rescript.lastModifiedDate;
              src = inputs.tree-sitter-rescript;
              language = "rescript";
              generate = true;
           };
           tree-sitter-tailwind = final.tree-sitter-tailwind;
         };
        };

       sg-nvim = final: prev: {
          sg-nvim = inputs.sg-nvim.packages.${prev.system}.default;
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

      nvim-nightly = inputs.neovim-nightly-overlay.overlays.default;
    };


 } // flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs =
        import inputs.nixpkgs-unstable { inherit (nixpkgsConfig) config overlays; inherit system; };
    in
    {
      legacyPackages = pkgs;
      devShell = pkgs.mkShell {
        packages = [ agenix.packages.${system}.default ];
      };
    });
}
