{
  description = "NixOS";

  inputs = {
    agenix = {
      url = "github:ryantm/agenix";
      inputs = {
        home-manager.follows = "home-manager";
        nixpkgs.follows = "nixpkgs";
        systems.follows = "systems";
      };
    };

    agenix-rekey = {
      url = "github:oddlama/agenix-rekey";
      inputs = {
        devshell.follows = "devshell";
        flake-parts.follows = "flake-parts";
        nixpkgs.follows = "nixpkgs";
        treefmt-nix.follows = "treefmt-nix";
      };
    };

    devshell = {
      url = "github:numtide/devshell";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
    };

    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs = {
        systems.follows = "systems";
      };
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };

    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };

    nur = {
      url = "github:nix-community/NUR";
      inputs = {
        flake-parts.follows = "flake-parts";
        nixpkgs.follows = "nixpkgs";
      };
    };

    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };

    systems = {
      url = "path:./flake.systems.nix";
      flake = false;
    };

    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };
  };

  outputs =
    {
      agenix-rekey,
      devshell,
      flake-utils,
      nixpkgs,
      self,
      treefmt-nix,
      ...
    }@inputs:
    { }
    # Load all nixos hosts and apply common settings.
    // (
      let
        commonSettings = {
          specialArgs = {
            inherit inputs;
          };
        };
        hosts = self.lib.enumerateNixFiles ./hosts/nixos;
        outputs = self.lib.enumerateNixFiles ./outputs;
        loadHost =
          hostpath:
          nixpkgs.lib.attrsets.recursiveUpdate commonSettings (import hostpath commonSettings.specialArgs);
        cartesian = nixpkgs.lib.attrsets.cartesianProduct {
          host = nixpkgs.lib.attrsToList hosts;
          output = [ null ] ++ nixpkgs.lib.attrsToList outputs;
        };
        assemble =
          {
            host,
            output,
          }:
          let
            configurationName = host.name + (if output != null then "+${output.name}" else "");
            configurationBase = loadHost host.value;
            configuration = configurationBase // {
              modules =
                configurationBase.modules
                ++ [
                  ./modules
                  ./fragments/overlay-fixes.nix
                ]
                ++ (if output != null then [ output.value ] else [ ]);
            };
          in
          nixpkgs.lib.nameValuePair configurationName (nixpkgs.lib.nixosSystem configuration);
      in
      {
        nixosConfigurations = nixpkgs.lib.listToAttrs (map assemble cartesian);
      }
    )
    # Add all global devshells.
    // (
      let
        shells = self.lib.enumerateNixFiles ./shells;
        loadShell =
          shellpath: system:
          import shellpath {
            pkgs = import nixpkgs {
              inherit system;
              overlays = [
                devshell.overlays.default
              ];
            };
          };
      in
      {
        devShells = flake-utils.lib.eachDefaultSystemMap (
          system:
          nixpkgs.lib.mapAttrs (shell: shellpath: loadShell shellpath system) shells
          // {
            default =
              let
                pkgs = import nixpkgs {
                  inherit system;
                  overlays = [ agenix-rekey.overlays.default ];
                };
              in
              pkgs.mkShell {
                packages = [ pkgs.agenix-rekey ];
              };
          }
        );
      }
    )
    # Set formatters for all architectures.
    // (flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        treefmt = treefmt-nix.lib.evalModule pkgs {
          projectRootFile = "flake.nix";
          programs = {
            nixfmt.enable = true;
          };
        };
      in
      {
        formatter = treefmt.config.build.wrapper;
        checks = {
          formatting = treefmt.config.build.check;
        };
      }
    ))
    # Extra attrset entries that are not generated.
    // {
      lib = import ./lib {
        inherit inputs;
      };

      agenix-rekey = agenix-rekey.configure {
        userFlake = self;
        nixosConfigurations = self.nixosConfigurations;
      };
    };
}
