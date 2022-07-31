{
  base16-schemes
, stdenvNoCC
}: stdenvNoCC.mkDerivation {
  pname = "base16-schemes.json";
  inherit (base16-schemes) version json nix;

  buildCommand = ''
    install -Dt $out $nix/*.nix $json/*.json
    sed -i -e "s|$json|.|g" $out/*.nix
  '';
}
