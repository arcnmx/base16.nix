{ runCommand
, base16-format-scheme'build
, yq'build
, lib
, flakelib'lib'Std
}: let
  addPassthru = { passthru }: scheme: {
    base16 = passthru.base16 // {
      data = passthru.base16.data or { } // {
        import = lib.importJSON scheme.json;
      };
    };
  };
in { src
, name
, config ? { }
}: let
  passthru.base16 = {
    kind = "schemes";
    slug = name;
    inherit config;
  };
  scheme = runCommand "base16-schemes-${name}" {
    inherit src passthru;
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
in flakelib'lib'Std.Drv.fixPassthru (
  addPassthru { inherit passthru; }
) scheme
