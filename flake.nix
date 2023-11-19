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
    };
    builders = {
      base16-build-scheme-format = { runCommand
      , base16-format-scheme'build
      , yq'build
      }: { src, name, config ? { } }: runCommand "base16-schemes-${name}" {
        inherit src;
        nativeBuildInputs = [ base16-format-scheme'build yq'build ];
        schemeDir = config.root or "";
        outputs = [ "out" "json" ];
      } ''
        install -d "$out"
        base16-format-scheme "$src$schemeDir" "$out" > schemes.txt
        SCHEME_JSON='{}'
        while read -r scheme; do
          SCHEME_JSON="$(yq --sort-keys -M \
            --slurpfile scheme "$out/$scheme.yaml" \
            ". + { \"$scheme\": \$scheme[0] }" <<< "$SCHEME_JSON"
          )"
        done < schemes.txt
        printf '%s' "$SCHEME_JSON" > $json
      '';
      base16-build-template-format = { runCommand
      , base16-format-template'build
      , yq'build
      }: { src, name, config ? { } }: runCommand "base16-templates-${name}" {
        inherit src;
        nativeBuildInputs = [ base16-format-template'build yq'build ];
        templateDir = config.root or "" + "/templates";
      } ''
        install -d "$out/templates"
        base16-format-template "$src$templateDir" "$out/templates"
      '';
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
