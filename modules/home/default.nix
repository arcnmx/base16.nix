{ inputs, isNixOS ? false }: { pkgs, config, options, lib, ... }: with lib; let
  inherit (inputs) self;
  base16 = lib.base16 or self.lib.base16;
  cfg = config.base16;
  defaultScheme = cfg.schemes.${cfg.defaultSchemeName};
  shellScripts = mapAttrs (key: scheme: pkgs.writeShellScriptBin "base16-${scheme.slug}" scheme.ansi.shellScript) cfg.schemes;
  termModule = { config, ... }: {
    config = {
      ansi.termPalette = mkDefault (if cfg.terminal.ansiCompatibility then 256 else 16);
      _module.args = {
        inherit pkgs;
      };
    };
  };
in {
  options.base16 = {
    schemes = mkOption {
      type = with types; let
        module = submodule [
          (import ../misc.nix { inherit inputs; })
          termModule
        ];
      in attrsOf module;
      example = { dark = "tomorrow.tomorrow-night"; };
      default = { };
    };

    alias = mkOption {
      type = with types; attrsOf (nullOr str);
      description = "deprecated";
      internal = true;
    };

    defaultScheme = mkOption {
      type = types.unspecified;
      default = defaultScheme;
    };
    defaultSchemeName = mkOption {
      type = types.str;
      default = "default";
    };

    terminal = {
      ansiCompatibility = mkEnableOption "bright colours mimic their normal counterparts" // { default = true; };
    };

    vim = {
      enable = mkEnableOption "base16 theme application for vim" // { default = cfg.shell.enable; };
      template = mkOption {
        type = types.unspecified;
        default = pkgs.base16-templates.vim.withTemplateData;
        defaultText = "pkgs.base16-templates.vim.withTemplateData";
      };
      plugin = mkOption {
        type = types.unspecified;
      };
      colorschemes = mkOption {
        type = with types; attrsOf unspecified;
      };
    };

    shell = {
      enable = mkEnableOption "base16 theme application from your shell";
      package = mkOption {
        type = types.package;
      };
      activate = mkOption {
        type = with types; attrsOf path;
      };
      applyDefault = mkOption {
        type = with types; nullOr str;
        default = cfg.defaultSchemeName;
      };
    };
  };

  config = let
    conf = {
      base16 = {
        defaultSchemeName = mkIf (cfg.schemes != { } && ! cfg.schemes ? "default") (mkDefault (head (attrNames cfg.schemes)));
        shell = {
          package = pkgs.linkFarm "base16-shell" (mapAttrsToList (key: script: {
            name = "${script.name}.sh";
            path = "${script}/bin/${script.name}";
          }) shellScripts);
          activate = mapAttrs (_: script: "${script}/bin/${script.name}") shellScripts;
        };
        vim = {
          colorschemes = mapAttrs (_: scheme:
            (cfg.vim.template scheme.templateData).base16.template.default.path
          ) cfg.schemes;
          plugin = pkgs.linkFarm "base16-vim" (mapAttrsToList (key: scheme: {
            name = "colors/base16-${cfg.schemes.${key}.slug}.vim";
            path = "${scheme}";
          }) cfg.vim.colorschemes) // {
            # https://github.com/NixOS/nixpkgs/pull/136429 requires pname in all vim plugins
            pname = "base16-vim";
          };
        };
      };
      lib.arc.base16.schemeForAlias = mapAttrs (alias: scheme:
        mapAttrs (base: colour: {
          # compatibility layer for old module
          hex = {
            inherit (colour) rgb r g b rgba a;
          };
          rgb = {
            r = colour.red.byte;
            g = colour.green.byte;
            b = colour.blue.byte;
            a = colour.alpha.byte;
          };
        }) (getAttrs base16.names cfg.schemes.${scheme})
      ) cfg.alias;
      _module.args.base16 = cfg.schemes // getAttrs (base16.names ++ [ "alias" "ansi" "map" ]) defaultScheme;
    };
    enableShellInit = cfg.shell.enable && cfg.shell.applyDefault != null;
    shellScriptDefault = shellScripts.${cfg.shell.applyDefault};
    initExtra = "${shellScriptDefault}/bin/${shellScriptDefault.name}";
    shellInit = {
      fish.interactiveShellInit = initExtra;
    } // genAttrs ["zsh" "bash"] (_: {
      inherit initExtra;
    });
    colorscheme = "base16-${defaultScheme.slug}";
    vimConf = genAttrs [ "vim" "neovim" ] (_: {
      plugins = [ cfg.vim.plugin ];
      extraConfig = mkMerge [ (mkBefore ''
        ${optionalString cfg.terminal.ansiCompatibility "let base16colorspace=256"}
        let g:base16_shell_path='${cfg.shell.package}'
      '') ''
        if !exists('g:colors_name') || g:colors_name != '${colorscheme}'
          colorscheme ${colorscheme}
        endif
      '' ];
    });
    homeConf = {
      programs = mkMerge [
        (mkIf enableShellInit shellInit)
        (mkIf cfg.vim.enable vimConf)
      ];
      home.packages = mkIf cfg.shell.enable (attrValues shellScripts);
    };
    nixosConf = {
    };
  in mkMerge (optional isNixOS nixosConf ++ optional (!isNixOS) homeConf ++ singleton conf);
}