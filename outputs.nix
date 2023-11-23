{ self, flakelib, nixpkgs, ... }@inputs: { sourceNames, sourceConfigs, kind }: let
  nixlib = nixpkgs.lib;
  kind' = nixlib.removeSuffix "s" kind;
  mapLP = { base16-build-scheme-format, base16-build-template-format }: name: let
    builder = if kind == "templates" then base16-build-template-format else base16-build-scheme-format;
  in builder {
    inherit name;
    src = inputs.${name};
    config = sourceConfigs.${kind}.${name} or { };
  };
  mapTemplateP = name: { base16-templates }: base16-templates.${name};
  mapSchemeP = name: { base16-schemes }: base16-schemes.${name};
  mapP = name: nixlib.nameValuePair "base16-${name}" (
    if kind == "templates" then mapTemplateP name
    else mapSchemeP name
  );
  base16Packages = nixlib.listToAttrs (
    map mapP sourceNames
  );
  base16-packages = builders: nixlib.genAttrs sourceNames (mapLP builders);
  mapTemplateLM = system: name: let
    template = self.legacyPackages.${system}.base16-templates.${name};
  in nixlib.importJSON "${toString template}/templates/config.yaml";
  mapSchemeLM = system: name: let
    scheme = self.legacyPackages.${system}.base16-schemes.${name};
  in nixlib.importJSON scheme.json;
  mapLM = if kind == "templates" then mapTemplateLM else mapSchemeLM;
  mapAll = base16-packages: name: {
    inherit name;
    path = base16-packages.${name};
  };
  mkAll = { linkFarm, base16-packages }: let
    paths = map (mapAll base16-packages) sourceNames;
  in linkFarm "base16-${kind}-all" paths;
in flakelib {
  inherit inputs;
  config.name = "base16-${kind'}";
  packages = base16Packages // {
    "base16-${kind}-all" = let
      all = {
        templates = { linkFarm, base16-templates }: mkAll {
          inherit linkFarm;
          base16-packages = base16-templates;
        };
        schemes = { linkFarm, base16-schemes }: mkAll {
          inherit linkFarm;
          base16-packages = base16-schemes;
        };
      };
    in all.${kind};
  };
  legacyPackages = {
    "base16-${kind}" = { base16-build-scheme-format, base16-build-template-format }@builders: nixlib.recurseIntoAttrs (
      base16-packages builders
    );
    nix-outputs = { writeText, lib, system }: let
      sep = "\n  ";
      mapTemplateO = name: let
        data = (self.lib."${kind}Data" { inherit system; }).${name};
        dataStr = lib.replaceStrings [ "''" ] [ "'''" ] (builtins.toJSON data);
        nix = ''${name} = { config = builtins.fromJSON '''${dataStr}'''; rootPath = ./data/templates/${name}; };'';
      in nix;
      mapSchemeO = name: let
        data = (self.lib."${kind}Data" { inherit system; }).${name};
        dataStr = lib.replaceStrings [ "''" ] [ "'''" ] (builtins.toJSON data);
        nix = ''${name} = { config = builtins.fromJSON '''${dataStr}'''; rootPath = ./data/schemes/${name}; };'';
      in nix;
      mapOutput = if kind == "templates" then mapTemplateO else mapSchemeO;
      allPackages = map mapOutput sourceNames;
    in writeText "base16-${kind}.nix" ''
      {
        ${lib.concatStringsSep sep allPackages}
      }
    '';
  };
  lib = {
    "${kind}Data" = { system }: nixlib.genAttrs sourceNames (mapLM system);
  };
}
