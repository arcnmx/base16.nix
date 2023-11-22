{
  description = "base16 schemes and templates";
  inputs = {
    flakelib = {
      url = "github:flakelib/fl";
    };
    nixpkgs = { };
    base16 = {
      url = "github:arcnmx/base16.nix/flake";
      inputs = {
        flakelib.follows = "flakelib";
        nixpkgs.follows = "nixpkgs";
      };
    };
  };
  outputs = { self, flakelib, nixpkgs, ... }@inputs: let
    nixlib = nixpkgs.lib;
    inherit (self.lib) base16-data;
    mapSchemeP = name: scheme: let
      pname = "base16-scheme-${name}";
      p = { runCommand }: runCommand pname {
        passthru = {
          base16-data = scheme.config;
        };
      } ''
        ln -s ${scheme.rootPath} $out
      '';
    in nixlib.nameValuePair pname p;
    mapTemplateP = name: template: let
      pname = "base16-template-${name}";
      p = { runCommand }: runCommand pname {
        passthru = {
          base16-data = template.config;
        };
      } ''
        ln -s ${template.rootPath} $out
      '';
    in nixlib.nameValuePair pname p;
  in flakelib {
    inherit inputs;

    packages =
      nixlib.mapAttrs' mapSchemeP base16-data.schemes
      // nixlib.mapAttrs' mapTemplateP base16-data.templates;
    legacyPackages = {
    };
    lib = {
      base16-data = {
        templates = import ./templates.nix;
        schemes = import ./schemes.nix;
      };
    };
    config = {
      name = "base16-data";
    };
  };
}
