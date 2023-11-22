{ inputs'self, inputs'base16, inputs'nixpkgs, inputs'flakegen, inputs'flakelib }: let
  self-lib = inputs'self.lib;
  nixlib = inputs'nixpkgs.lib;
  flakegen = inputs'flakegen.lib;
in {
  sourceConfigs = {
    templates = {
      blink.blacklist = true;
      textadept.root = "/base16/templates/textadept";
    };
    schemes = {
      ia.blacklist = true;
      solarized.blacklist = true;
    };
  };

  readSource = { source }: let
    data = builtins.readFile "${toString source}/list.yaml";
  in builtins.fromJSON data;

  parseSources = { sources, config ? { } }: let
    blacklist = nixlib.filterAttrs (_: { blacklist ? false, ... }: blacklist) config;
    sources' = builtins.removeAttrs sources (builtins.attrNames blacklist);
    mapSource = _name: url: flakegen.parseRepoUrl { inherit url; };
  in builtins.mapAttrs mapSource sources';

  genFlake = let
    sep = "\n    ";
    sourceNamesNix = sources: nixlib.concatMapStringsSep sep builtins.toJSON (
      builtins.attrNames sources
    );
    sourceConfigs = builtins.toJSON self-lib.sourceConfigs;
  in { sources, kind }: {
    inputs = {
      nixpkgs = { };
      flakelib.url = "github:flakelib/fl";
      base16 = {
        url = "github:arcnmx/base16.nix/flake";
        inputs = {
          nixpkgs.follows = "nixpkgs";
          flakelib.follows = "flakelib";
        };
      };
    } // builtins.mapAttrs (_: repoUrl: {
      url = flakegen.flakeUrl { inherit repoUrl; };
      flake = false;
    }) sources;
    outputs = ''
      inputs: let
        sourceNames = [
          ${sourceNamesNix sources}
        ];
        kind = "${kind}";
        sourceConfigs = builtins.fromJSON '''${sourceConfigs}''';
      in import ../outputs.nix inputs { inherit sourceNames sourceConfigs kind; }
    '';
  };
}
