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
    mapSchemeName = name: "base16-schemes-${name}";
    mapSchemeP = name: source: let
      p = { runCommand }: runCommand (mapSchemeName name) {
        inherit (source) rootPath;
        passthru = {
          base16 = {
            kind = "schemes";
            data = {
              inherit (source) config;
            };
            slug = name;
          };
        };
      } ''
        install -d $out
        ln -s $rootPath/* $out
      '';
    in p;
    mapSchemeSource = sourceSlug: schemes: schemes // {
      slug = sourceSlug;
      schemes = builtins.mapAttrs (slug: scheme: scheme // {
        inherit sourceSlug slug;
      }) schemes.config;
    };
    templatePassthru = { base16-build-template, passthru }: src: {
      base16 = passthru.base16 // {
        build-template = nixlib.setFunctionArgs (args: base16-build-template ({
          inherit src;
        } // args)) (nixlib.functionArgs base16-build-template);
      };
      withTemplateData = templateData: src.base16.build-template {
        inherit templateData;
      };
    };
    mapTemplateName = name: "base16-template-${name}";
    mapTemplateP = name: template: let
      passthru.base16 = {
        kind = "templates";
        data = {
          inherit (template) config;
        };
        slug = name;
      };
      p = { runCommand, base16-build-template, flakelib'lib'Std }: let
        drv = runCommand (mapTemplateName name) {
          inherit (template) rootPath;
          inherit passthru;
        } ''
          install -d $out
          ln -s $rootPath/* $out
        '';
      in flakelib'lib'Std.Drv.fixPassthru (templatePassthru { inherit base16-build-template passthru; }) drv;
    in p;
  in flakelib {
    inherit inputs;

    packages = { base16-schemes, base16-templates }: let
      schemeFor = source:
        nixlib.nameValuePair (mapSchemeName source.slug) base16-schemes.${source.slug};
      schemes = nixlib.listToAttrs (
        nixlib.mapAttrsToList (_: schemeFor) base16-data.schemeSources
      );
      templates = nixlib.listToAttrs (map (name:
        nixlib.nameValuePair (mapTemplateName name) base16-templates.${name}
      ) (builtins.attrNames base16-data.templates));
    in schemes // templates;
    legacyPackages = {
      base16-schemes = { runCommand }: let
        sources' = builtins.mapAttrs mapSchemeP base16-data.schemeSources;
        sources = builtins.mapAttrs (_: drv: drv { inherit runCommand; }) sources';
      in nixlib.recurseIntoAttrs sources;
      base16-templates = { callPackage }: let
        templates' = builtins.mapAttrs mapTemplateP base16-data.templates;
        templates = builtins.mapAttrs (_: nixlib.flip callPackage { }) templates';
      in nixlib.recurseIntoAttrs templates;
      base16-templated = { self'lib'base16-schemes, base16-templates, symlinkJoin }: let
        templated' = nixlib.cartesianProductOfSets {
          template = map (slug: base16-templates.${slug}) (builtins.attrNames base16-data.templates);
          scheme = builtins.attrValues self'lib'base16-schemes;
        };
        mapTemplated = template: scheme: template.withTemplateData scheme.templateData;
        templated = map ({ template, scheme }: nixlib.nameValuePair "base16-${template.base16.slug}-${scheme.slug}" (mapTemplated template scheme)) templated';
      in nixlib.recurseIntoAttrs (nixlib.listToAttrs templated);
    };
    lib = {
      base16-data = {
        templates = import ./templates.nix;
        schemeSources = builtins.mapAttrs mapSchemeSource (import ./schemes.nix);
        schemes = let
          schemes = nixlib.mapAttrsToList (_: schemes: schemes.schemes) base16-data.schemeSources;
        in nixlib.attrsets.mergeAttrsList schemes;
      };
      base16-schemes = builtins.mapAttrs (_: inputs.base16.lib.base16.evalScheme) self.lib.base16-data.schemes;
    };
    config = {
      name = "base16-data";
    };
  };
}
