{
  description = "base16 schemes and templates";
  inputs = {
    flakelib = {
      url = "github:flakelib/fl";
    };
    flakegen = {
      url = "github:flakelib/flakegen";
      inputs = {
        flakelib.follows = "flakelib";
        nixpkgs.follows = "nixpkgs";
        std.follows = "flakelib/std";
      };
    };
    nixpkgs = { };
    base16 = {
      url = "github:arcnmx/base16.nix/flake";
      inputs = {
        flakelib.follows = "flakelib";
        nixpkgs.follows = "nixpkgs";
      };
    };
    base16-schemes-tinted = {
      url = "github:tinted-theming/base16-schemes";
      flake = false;
    };
    base16-schemes-source = {
      url = "github:chriskempson/base16-schemes-source";
      flake = false;
    };
    base16-templates-source = {
      url = "github:chriskempson/base16-templates-source";
      flake = false;
    };
  };
  outputs = { self, flakelib, ... }@inputs: let
    genPath = "\${BASE16_GENERATE_ROOT-gen}";
    flakePath = {
      __toString = _: "\${BASE16_NIX_FLAKE-${toString inputs.self}}";
      schemes = "\${BASE16_SCHEMES_FLAKE-${genPath}/schemes}";
      templates = "\${BASE16_TEMPLATES_FLAKE-${genPath}/templates}";
    };
  in flakelib {
    inherit inputs;

    packages = {
      schemes-source = { format-source
      , inputs'base16-schemes-source
      }: format-source {
        name = "base16-schemes-source";
        input = inputs'base16-schemes-source;
      };
      templates-source = { format-source
      , inputs'base16-templates-source
      }: format-source {
        name = "base16-templates-source";
        input = inputs'base16-templates-source;
      };
    };
    legacyPackages = {
      base16-generate = ./generate.nix;
      base16-generate-update = { writeShellScriptBin, runtimeShell }: writeShellScriptBin "update" ''
        export CHECKOUT="${genPath}"
        exec ${runtimeShell} ${./ci/update.sh} "$@"
      '';
      schemes-flake = { flakegen'generate, schemes-source }: let
        sources = self.lib.parseSources {
          sources = self.lib.readSource { source = schemes-source; } // {
            tinted = "https://github.com/tinted-theming/base16-schemes";
          };
          config = self.lib.sourceConfigs.schemes;
        };
      in flakegen'generate {
        flake = self.lib.genFlake {
          inherit sources;
          kind = "schemes";
        };
      };
      templates-flake = { flakegen'generate, templates-source }: let
        sources = self.lib.parseSources {
          sources = self.lib.readSource { source = templates-source; };
          config = self.lib.sourceConfigs.templates;
        };
      in flakegen'generate {
        flake = self.lib.genFlake {
          inherit sources;
          kind = "templates";
        };
      };
    };
    builders = {
      format-source = { runCommand
      , base16-format-source'build
      , lib
      }: { name, input }: let
        attrs = {
          nativeBuildInputs = [ base16-format-source'build ];
          src = input;
        };
      in runCommand name attrs ''
        install -d $out
        base16-format-source $src $out/list.yaml
      '';
    };
    devShells = {
      default = { mkShell, writeShellScriptBin }: let
        base16-generate = writeShellScriptBin "base16-generate" ''
          nix --extra-experimental-features nix-command run \
          "${flakePath}#base16-generate" \
          ''${FLAKE_OPTS-} "$@"
        '';
      in mkShell {
        nativeBuildInputs = [ base16-generate ];
      };
    };
    lib = { callPackage }: callPackage ./lib.nix { } // {
      inherit flakePath genPath;
    };
    config = {
      name = "base16-generate";
    };
  };
}
