{
  description = "base16";
  inputs = {
    flakelib = {
      url = "github:flakelib/fl";
    };
    nixpkgs = { };
  };
  outputs = { ... }@inputs: let
    inherit (inputs) flakelib self;
  in flakelib {
    inherit inputs;

    legacyPackages = {
      base16-format-source = {
        __functor = _: import ./format-source.nix;
        fl'config.args = {
          yq.offset = "build";
        };
      };
      base16-format-template = {
        __functor = _: import ./format-template.nix;
        fl'config.args = {
          yq.offset = "build";
        };
      };
      base16-format-scheme = {
        __functor = _: import ./format-scheme.nix;
        fl'config.args = {
          yq.offset = "build";
        };
      };
      base16-mustache = ./mustache.nix;
    };
    builders = {
      base16-build-scheme-format = ./format-scheme-build.nix;
      base16-build-template-format = ./format-template-build.nix;
      base16-build-template = ./build-template.nix;
    };
    overlays = {
      lib = final: prev: {
        lib = prev.lib.extend self.lib.overlay;
      };
      default = self.overlays.lib;
    };
    lib = import ./lib { inherit inputs; };
    config = {
      name = "base16";
    };
  } // {
    nixosModules = {
      base16 = import ./modules/nixos { inherit inputs; };
      default = self.nixosModules.base16;
    };
    homeModules = {
      base16 = import ./modules/home { inherit inputs; };
      default = self.homeModules.base16;
    };
  };
}
