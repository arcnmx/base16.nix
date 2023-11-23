{ inputs }: { lib, config, options, ... }: with lib; let
  inherit (inputs) self;
  base16 = lib.base16 or self.lib.base16;
  cfg = config;
  mapBase16 = f: mapAttrs (_: f) (getAttrs base16.names config // config.aliases);
in {
  imports = base16.types.schemeModules;

  options = {
    ansi = mkOption {
      type = base16.shell.shellPaletteType;
    };
    map = mkOption {
      type = types.unspecified;
    };
  };
  config = let
    hashPrefix = b: "#" + b;
  in {
    ansi.palette = genAttrs base16.names (name: config.${name}.set);
    map = {
      __functor = self: mapBase16;
      hash = mapAttrs (a: mapAttrs (_: hashPrefix)) (removeAttrs config.map [ "__functor" ]);
    } // genAttrs [
      "hex" "rgb" "rgb16" "bgr" "bgr16"
      "rgba" "rgb_" "rgba16" "rgb_16"
      "argb" "_rgb" "argb16" "_rgb16"
      "bgra" "bgr_" "bgra16" "bgr_16"
      "ansiIndex" "ansiStr"
    ] (key: mapBase16 (b: b.${key}));
  } // genAttrs base16.names (base: { config, ... }: {
    options = {
      ansiIndex = mkOption {
        type = types.int;
        default = cfg.ansi.mapping.${base};
      };
      ansiStr = mkOption {
        type = types.str;
        default = toString config.ansiIndex;
      };
    };
  });
}
