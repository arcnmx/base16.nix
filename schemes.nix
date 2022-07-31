{
  src
, version ? "develop"
, stdenvNoCC
, remarshal
}: stdenvNoCC.mkDerivation {
  pname = "base16-schemes";
  inherit src version;

  nativeBuildInputs = [
    remarshal
  ];

  outputs = [ "out" "json" "nix" ];

  buildPhase = ''
    printf '{\n' > list.nix
    for scheme in *.yaml; do
      slug="''${scheme%.yaml}"
      yaml2json "$scheme" - | sed -e 's/"#/"/g' > "$slug.json"
      printf '  "%s" = %s;\n' "$slug" "$json/$slug.json" >> list.nix
    done
    printf '}\n' >> list.nix
    printf '%s\n' 'builtins.mapAttrs (_: p: builtins.fromJSON (builtins.readFile p)) (import ./list.nix)' > schemes.nix
    printf '{\n  list = import ./list.nix;\n  schemes = import ./schemes.nix;\n}\n' > default.nix
  '';

  installPhase = ''
    install -d $out
    install -Dt $json *.json

    install -Dt $nix *.nix
  '';
}
